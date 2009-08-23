package jac.ui
{
	import flash.display.NativeWindow;
	import flash.geom.Rectangle;

	public class DialogWindow extends NativeWindow
	{
		private var windowCreated:Boolean = false;
		
		public function DialogWindow()
		{
			super(null);
//			showStatusBar = false;
		}
		
//		protected override function commitProperties():void
//		{
//			super.commitProperties();
//			
//			if (!windowCreated && nativeWindow)
//			{
//				windowCreated = true;
//				var area:Rectangle = nativeWindow.bounds;
//				nativeWindow.x = area.x + area.width/2 - nativeWindow.width/2;
//				nativeWindow.y = area.y + area.height/2 - nativeWindow.height/2;
//			}
//		}
	}
}