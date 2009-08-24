package jac.filesystem
{
	import flash.desktop.Icon;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import jac.net.IResponse;
	import jac.net.Response;
	
	public class AsyncFile extends EventDispatcher
	{
		public static function get applicationDirectory():AsyncFile
		{
			return new AsyncFile(File.applicationDirectory.nativePath);
		}
		
		public static function get applicationStorageDirectory():AsyncFile
		{
			return new AsyncFile(File.applicationStorageDirectory.nativePath);
		}
		
		public static function get desktopDirectory():AsyncFile
		{
			return new AsyncFile(File.desktopDirectory.nativePath);
		}
		
		public static function get documentsDirectory():AsyncFile
		{
			return new AsyncFile(File.documentsDirectory.nativePath);
		}
		
		public static function get userDirectory():AsyncFile
		{
			return new AsyncFile(File.userDirectory.nativePath);
		}
		
		public static function createTempDirectory():AsyncFile
		{
			return new AsyncFile(File.createTempDirectory().nativePath);
		}
		
		public static function createTempFile():AsyncFile
		{
			return new AsyncFile(File.createTempFile().nativePath);
		}
		
		public static function getRootDirectories():Array
		{
			return File.getRootDirectories().map(toAsyncFile);
		}
		
		
		
		protected var _file:File;
		protected var _stream:FileStream;
		
		public function AsyncFile(path:String = null)
		{
			_file = new File(path);
		}
		
		public function get file():File
		{
			return _file;
		}
		
		public function get stream():FileStream
		{
			return _stream;
		}
		
		public function get createdDate():Date
		{
			return file.creationDate;
		}
		
		public function get creator():String
		{
			return file.creator;
		}
		
		public function get data():ByteArray
		{
			return file.data;
		}
		
		public function get exists():Boolean
		{
			return file.exists;
		}
		
		public function get extension():String
		{
			return file.extension;
		}
		
		public function get icon():Icon
		{
			return file.icon;
		}
		
		public function get isDirectory():Boolean
		{
			return file.isDirectory;
		}
		
		public function get isHidden():Boolean
		{
			return file.isHidden;
		}
		
		public function get isOpen():Boolean
		{
			return stream != null;
		}
		
		public function get isPackage():Boolean
		{
			return file.isPackage;
		}
		
		public function get isSymbolicLink():Boolean
		{
			return file.isSymbolicLink;
		}
		
		public function get modificationDate():Date
		{
			return file.modificationDate;
		}
		
		public function get name():String
		{
			return file.name;
		}
		
		[Bindable("nativePathChange")]
		public function get nativePath():String
		{
			return file.nativePath;
		}
		
		public function set nativePath(value:String):void
		{
			if (file.nativePath == value) {
				return;
			}
			file.nativePath = value;
			dispatchEvent(new Event("nativePathChange"));
		}
		
		public function get parent():AsyncFile
		{
			return toAsyncFile(file.parent);
		}
		
		public function get size():Number
		{
			return file.size;
		}
		
		public function get spaceAvailable():Number
		{
			return file.spaceAvailable;
		}
		
		public function get type():String
		{
			return file.type;
		}
		
		[Bindable("nativePathChange")]
		public function get url():String
		{
			return file.url;
		}
		
		public function set url(value:String):void
		{
			if (file.url == value) {
				return;
			}
			file.url = value;
			dispatchEvent(new Event("nativePathChange"));
		}
		
		// TODO make sure this is right
		public function browse(typeFilter:Array = null):IResponse
		{
			file.browse(typeFilter);
			return new Response()
				.addCompleteEvent(file, Event.SELECT)
				.addCancelEvent(file, Event.CANCEL)
				.handle(toAsyncFile);
		}
		
		public function browseForDirectory(title:String):IResponse
		{
			file.browseForDirectory(title);
			return new Response()
				.addCompleteEvent(file, Event.SELECT)
				.addCancelEvent(file, Event.CANCEL)
				.handle(toAsyncFile);
		}
		
		public function browseForOpen(title:String, typeFilter:Array = null):IResponse
		{
			file.browseForOpen(title, typeFilter);
			return new Response()
				.addCompleteEvent(file, Event.SELECT)
				.addCancelEvent(file, Event.CANCEL)
				.handle(toAsyncFile);
		}
		
		public function browseForOpenMultiple(title:String, typeFilter:Array = null):IResponse
		{
			file.browseForOpenMultiple(title, typeFilter);
			var response:Response = new Response();
			response.addCompleteEvent(file, FileListEvent.SELECT_MULTIPLE, "files");
			response.addCancelEvent(file, Event.CANCEL);
			return response.handle(toFileList);
		}
		
		public function browseForSave(title:String):IResponse
		{
			file.browseForSave(title);
			return new Response()
				.addCompleteEvent(file, Event.SELECT)
				.addCancelEvent(file, Event.CANCEL)
				.handle(toAsyncFile);
		}
		
		public function cancel():void
		{
			file.cancel();
		}
		
		public function canonicalize():void
		{
			file.canonicalize();
		}
		
		public function clone():AsyncFile
		{
			return toAsyncFile(file);
		}
		
		public function copyTo(newLocation:AsyncFile, overwrite:Boolean = false):IResponse
		{
			file.copyToAsync(newLocation.file, overwrite);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		public function createDirectory():void
		{
			file.createDirectory();
		}
		
		public function deleteDirectory(deleteDirectoryContents:Boolean = false):IResponse
		{
			file.deleteDirectoryAsync(deleteDirectoryContents);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		public function deleteFile():IResponse
		{
			file.deleteFileAsync();
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		// TODO make sure this is right
		public function download(request:URLRequest, defaultFileName:String = null):IResponse
		{
			file.download(request, defaultFileName);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		public function getDirectoryListing():IResponse
		{
			file.getDirectoryListingAsync();
			
			var response:Response = new Response();
			response.addCompleteEvent(file, FileListEvent.DIRECTORY_LISTING, "files");
			response.addCancelEvent(file, IOErrorEvent.IO_ERROR);
			return response.handle(toFileList);
		}
		
		public function getRelativePath(ref:AsyncFile, useDotDot:Boolean = false):String
		{
			return file.getRelativePath(ref.file, useDotDot);
		}
		
		public function load():void
		{
			return file.load();
		}
		
		public function moveTo(newLocation:AsyncFile, overwrite:Boolean = false):IResponse
		{
			file.moveToAsync(newLocation.file, overwrite);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		public function moveToTrash():IResponse
		{
			file.moveToTrashAsync();
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		public function resolvePath(path:String):AsyncFile
		{
			return toAsyncFile(file.resolvePath(path));
		}
		// TODO make sure this is right
		public function save(data:Object, defaultFileName:String = null):void
		{
			file.save(data, defaultFileName);
		}
		
		public override function toString():String
		{
			return file.toString();
		}
		// TODO make sure this is right
		public function upload(request:URLRequest, uploadDataFieldName:String = null, testUpload:Boolean = false):IResponse
		{
			file.upload(request, uploadDataFieldName, testUpload);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		// TODO make sure this is right
		public function uploadUnencoded(request:URLRequest):IResponse
		{
			file.uploadUnencoded(request);
			var response:Response = new Response();
			response.addCompleteEvent(_file, Event.COMPLETE);
			response.addCancelEvent(_file, SecurityErrorEvent.SECURITY_ERROR);
			response.addCancelEvent(_file, IOErrorEvent.IO_ERROR);
			return response.handle(toAsyncFile);
		}
		
		
		
		
		
		public function open(fileMode:String):IResponse
		{
			_stream = new FileStream();
			stream.openAsync(file, fileMode);
			return new Response()
				.addCompleteEvent(stream, Event.COMPLETE)
				.addCancelEvent(stream, IOErrorEvent.IO_ERROR)
				.handle(toAsyncFile);
		}
		
		public function close():IResponse
		{
			stream.close();
			return new Response()
				.addCompleteEvent(stream, Event.CLOSE)
				.addCancelEvent(stream, IOErrorEvent.IO_ERROR)
				.handle(toAsyncFile);
		}
		
		public function read():IResponse
		{
			var stream:FileStream = new FileStream()
			stream.openAsync(file, FileMode.READ);
			return new Response()
				.addCompleteEvent(stream, Event.COMPLETE)
				.addCancelEvent(stream, IOErrorEvent.IO_ERROR)
				.handle(toByteArray);
		}
		
		public function write(byteArray:ByteArray):IResponse
		{
			var stream:FileStream = new FileStream()
			stream.openAsync(file, FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.bytesAvailable);
			stream.close();
			return new Response()
				.addCompleteEvent(stream, Event.CLOSE)
				.addCancelEvent(stream, IOErrorEvent.IO_ERROR)
				.handle(toThis);
		}
		
		public function readText():IResponse
		{
			var stream:FileStream = new FileStream()
			stream.openAsync(file, FileMode.READ);
			return new Response()
				.addCompleteEvent(stream, Event.COMPLETE)
				.addCancelEvent(stream, IOErrorEvent.IO_ERROR)
				.handle(toText);
		}
		
		public function writeText(text:String):IResponse
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(text);
			return write(byteArray);
		}
		
		/**
		 * Watch a file or directory for changes. When there is a change respond
		 * with an info object containing the change/changes.
		 * 
		 * @param Whether it should be recursive through directories or not
		 */
		public function watch(recursive:Boolean = true):IResponse
		{
			var watcher:FileWatcher = new FileWatcher(this, recursive);
			return watcher.watch();
		}
		
		
		
		protected static function toFileList(files:Array):Array
		{
			return files.map(toAsyncFile);
		}
		
		protected static function toAsyncFile(file:File, index:int = 0, array:Array = null):AsyncFile
		{
			return new AsyncFile(file.nativePath);
		}
		
		protected function toByteArray(stream:FileStream):ByteArray
		{
			var byteArray:ByteArray = new ByteArray();
			stream.readBytes(byteArray, 0, stream.bytesAvailable);
			stream.close();
			return byteArray;
		}
		
		protected function toText(stream:FileStream):String
		{
			var text:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return text;
		}
		
		protected function toThis(stream:FileStream):AsyncFile
		{
			return this;
		}
	}
}