package jac.ui
{
	import flash.display.NativeWindow;
	
	public class Tooltip extends NativeWindow
	{
		public function Tooltip()
		{
			super(null);
		}
		
		
			
//			protected function creationCompleteHandler():void
//			{
//				addEventListener(MouseEvent.CLICK, onClick);
//				
//				var options:NativeWindowInitOptions = new NativeWindowInitOptions();
//				options.type = NativeWindowType.LIGHTWEIGHT;
//				options.systemChrome = NativeWindowSystemChrome.NONE;
//				options.transparent = true;
//				win = new NativeWindow(options);
//				win.alwaysInFront = true;
//				win.visible = false;
//				win.stage.scaleMode = StageScaleMode.NO_SCALE;
//				win.stage.align = StageAlign.TOP_LEFT;
//				var root:Sprite = new Sprite();
//				win.stage.addChild(root);
//				root.graphics.beginFill(0x999999, .5);
//				root.graphics.drawRect(0, 0, 100, 20);
//				win.activate();
//			}
//			
//			protected function onClick(event:MouseEvent):void
//			{
//				win.visible = false;
//				var point:Point = nativeWindow.globalToScreen(new Point(event.stageX, event.stageY));
//				win.x = point.x;
//				win.y = point.y;
//				win.visible = true;
//			}

	}
}