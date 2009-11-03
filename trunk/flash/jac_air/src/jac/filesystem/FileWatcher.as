package jac.filesystem
{
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import flight.vo.ValueObject;
	
	import jac.net.IResponse;
	import jac.net.Response;
	
	public class FileWatcher
	{
		protected var file:AsyncFile;
		protected var recursive:Boolean;
		protected var files:Array = [];
		protected var fileModification:Object = {};
		protected var timer:Timer = new Timer(10000);
		
		protected var checkedFiles:Object;
		protected var addedFiles:Array;
		protected var changedFiles:Array;
		protected var deletedFiles:Array;
		
		protected var response:IResponse;
		protected var waitingDirectories:uint = 0;
		
		protected var start:Number;
		
		public function FileWatcher(file:AsyncFile, recursive:Boolean = true)
		{
			this.file = file;
			this.recursive = recursive;
//			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		public function watch():IResponse
		{
			response = new Response();
			start = getTimer();
			if (file.isDirectory) {
				waitingDirectories++;
				file.getDirectoryListing().onComplete(onAddListing);
			} else {
				addFile(file);
			}
			
			return response;
		}
		
		
		protected function onAddListing(list:Array):void
		{
			list.forEach(addFile);
			waitingDirectories--;
			
			if (waitingDirectories == 0) {
				doneAdding();
			}
		}
		
		protected function addFile(file:AsyncFile, index:int = 0, array:Array = null):void
		{
			if (file.isHidden) return;
			
			files.push(file.nativePath);
			fileModification[file.nativePath] = file.modificationDate.getTime();
			
			if (file.isDirectory && !file.isPackage && recursive) {
				waitingDirectories++;
				file.getDirectoryListing().onComplete(onAddListing);
			}
			
			if (waitingDirectories == 0) {
				doneAdding();
			}
		}
		
		protected function doneAdding():void
		{
			trace("Took", (getTimer() - start)/1000, "seconds to scan", files.length, "files");
			//timer.start();
			setTimeout(check, 10);
		}
		
//		protected function onTimer(event:TimerEvent):void
//		{
//			check();
//		}
		
		protected function check():void
		{
			checkedFiles = ValueObject.clone(fileModification);
			
			addedFiles = [];
			changedFiles = [];
			deletedFiles = [];
			
			start = getTimer();
			if (file.isDirectory) {
				waitingDirectories++;
				file.getDirectoryListing().onComplete(onCheckListing);
			} else {
				checkFile(file);
			}
		}
		
		
		protected function onCheckListing(list:Array):void
		{
			list.forEach(checkFile);
			waitingDirectories--;
			
			if (waitingDirectories == 0) {
				doneChecking();
			}
		}
		
		protected function checkFile(file:AsyncFile, index:int = 0, array:Array = null):void
		{
			if (file.isHidden || !file.exists) return;
			
			var path:String = file.nativePath;
			if ( !(path in checkedFiles)) {
				addedFiles.push(file);
			} else if (checkedFiles[path] != file.modificationDate.getTime()) {
				changedFiles.push(file);
			} else {
				delete checkedFiles[path];
			}
			
			if (file.isDirectory && !file.isPackage && recursive) {
				waitingDirectories++;
				file.getDirectoryListing().onComplete(onCheckListing);
			}
			
			if (waitingDirectories == 0) {
				doneChecking();
			}
		}
		
		protected function doneChecking():void
		{
			trace("Took", (getTimer() - start)/1000, "seconds to check", files.length, "files");
			
			for (var path:String in checkedFiles) {
				deletedFiles.push(new AsyncFile(path));
			}
			
			if (addedFiles.length || changedFiles.length || deletedFiles.length) {
				response.complete({addedFiles: addedFiles, changedFiles: changedFiles, deletedFiles: deletedFiles});
			} else {
				setTimeout(check, 2000);
			}
		}
	}
}