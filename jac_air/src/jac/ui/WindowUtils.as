package jac.ui
{
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import jac.utils.Preferences;
	
	public class WindowUtils
	{
		protected static var registeredWindows:Dictionary = new Dictionary();
		
		/**
		 * Centers a window in it's current screen or the main screen if it does not lie within a screen
		 * Optionally centers the window over another window
		 */
		public static function centerWindow(window:NativeWindow, parent:NativeWindow = null):void
		{
			var screens:Array = Screen.getScreensForRectangle(window.bounds);
			var bounds:Rectangle = (parent != null ? parent.bounds : Screen(screens.length > 0 ? screens[0] : Screen.mainScreen).visibleBounds);
			window.x = bounds.x + bounds.width/2 - window.width/2;
			window.y = bounds.y + bounds.height/2 - window.height/2;
		}
		
		/**
		 * Registers a window under a name. When the window is closed its size and position will be saved
		 * to a sharedobject. When first registered if there is a size and position stored for that
		 * window it will be restored to that position.
		 */
		public static function registerWindow(name:String, window:NativeWindow, defaultSize:Rectangle = null):void
		{
			var data:Object = Preferences.getPreference("window.size", {})[name];
			var size:Rectangle;
			var bounds:Rectangle = Screen.mainScreen.visibleBounds;
			
			if (data == null && defaultSize != null)
			{
				size = defaultSize;
				size.x = bounds.x + bounds.width/2 - size.width/2;
				size.y = bounds.y + bounds.height/2 - size.height/2;
			}
			else if (data != null)
				size = new Rectangle(data.x, data.y, data.width, data.height);
			
			if (!size)
			{
				// default is 80% of the main screen size
				window.width = bounds.width*.8;
				window.height = bounds.height*.8;
				window.x = bounds.x + bounds.width/2 - window.width/2;
				window.y = bounds.y + bounds.height/2 - window.height/2;
			}
			else
			{
				var visibleArea:Rectangle = new Rectangle();
				for each (var screen:Screen in Screen.screens)
					visibleArea = visibleArea.union(screen.visibleBounds);
				
				size.x = Math.max(visibleArea.left, Math.min(visibleArea.right - size.width, size.x));
				size.y = Math.max(visibleArea.top, Math.min(visibleArea.bottom - size.height, size.y));
				size.right = Math.min(visibleArea.right, size.right);
				size.bottom = Math.min(visibleArea.bottom, size.bottom);
				
				window.bounds = new Rectangle(size.x, size.y, size.width, size.height);
				
				// fix for bug (on mac only, or others?)
				window.height -= window.globalToScreen(new Point(0, 0)).y - window.y;
			}
			
			registeredWindows[window] = {name: name, bounds: window.bounds.clone()};
			// try and be the last event called so if the event is prevented we aren't saving the position
			window.addEventListener(NativeWindowBoundsEvent.MOVE, onBoundsChange);
			window.addEventListener(NativeWindowBoundsEvent.RESIZE, onBoundsChange);
			window.addEventListener(Event.CLOSE, onWindowClose, false, -1000);
		}
		
		/**
		 * Saves the position of registered windows when they move
		 */
		protected static function onBoundsChange(event:Event):void
		{
			var window:NativeWindow = event.target as NativeWindow;
			var info:Object = registeredWindows[window];
			info.bounds = window.bounds.clone();
		}
		
		/**
		 * Saves the position of a registered window before it closes
		 */
		protected static function onWindowClose(event:Event):void
		{
			var window:NativeWindow = event.target as NativeWindow;
			var info:Object = registeredWindows[window];
			delete registeredWindows[window];
			var b:Rectangle = info.bounds;
			Preferences.getPreference("window.size")[info.name] = {x: b.x, y: b.y, width: b.width, height: b.height};
		}
	}
}