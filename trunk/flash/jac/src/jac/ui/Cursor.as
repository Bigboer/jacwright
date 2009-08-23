////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Jacob Wright
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////
package jac.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import flight.utils.Singleton;

	/**
	 * Cursor is a helper class to use custom cursors registered with it in your flash application.
	 */
	public class Cursor
	{
		
		public static const AUTO:String = "auto";
		public static const ARROW:String = "arrow";
		public static const BUTTON:String = "button";
		public static const HAND:String = "hand";
		public static const HELP:String = "help";
		public static const CROSS_HAIR:String = "crossHair";
		public static const MOVE:String = "move";
		public static const WEST:String = "west";
		public static const EAST:String = "east";
		public static const NORTH:String = "north";
		public static const SOUTH:String = "south";
		public static const NORTH_WEST:String = "northWest";
		public static const NORTH_EAST:String = "northEast";
		public static const SOUTH_WEST:String = "southWest";
		public static const SOUTH_EAST:String = "southEast";
		public static const NORTH_SOUTH:String = "northSouth";
		public static const EAST_WEST:String = "eastWest";
		public static const NORTH_WEST_SOUTH_EAST:String = "northWestSouthEast";
		public static const NORTH_EAST_SOUTH_WEST:String = "northEastSouthWest";
		public static const COLUMN:String = "column";
		public static const ROW:String = "row";
		public static const VERTICAL_TEXT:String = "verticalText";
		public static const CONTEXT_MENU:String = "contextMenu";
		public static const NO_DROP:String = "noDrop";
		public static const NOT_ALLOWED:String = "notAllowed";
		public static const PROGRESS:String = "progress";
		public static const WAIT:String = "wait";
		public static const ALIAS:String = "alias";
		public static const CELL:String = "cell";
		public static const COPY:String = "copy";
		public static const ZOOM_IN:String = "zoomIn";
		public static const ZOOM_OUT:String = "zoomOut";
		public static const NONE:String = "none";
		
		
		private var flashHandled:Array = ["auto", "arrow", "button", "hand"];
		private var objects:Dictionary = new Dictionary(true);
		private var cursors:Object = {};
		private var stack:Array = [];
		private var currentCursor:DisplayObject;
		
		
		public function Cursor()
		{
			Singleton.enforceSingleton(this);
			init();
		}
		
		
		protected function init():void
		{
			registerCursor(Cursor.ALIAS, DefaultCursors.ALIAS);
			registerCursor(Cursor.CELL, DefaultCursors.CELL);
			registerCursor(Cursor.COLUMN, DefaultCursors.COLUMN);
			registerCursor(Cursor.CONTEXT_MENU, DefaultCursors.CONTEXT_MENU);
			registerCursor(Cursor.COPY, DefaultCursors.COPY);
			registerCursor(Cursor.CROSS_HAIR, DefaultCursors.CROSS_HAIR);
			registerCursor(Cursor.EAST, DefaultCursors.EAST);
			registerCursor(Cursor.EAST_WEST, DefaultCursors.EAST_WEST);
			registerCursor(Cursor.HELP, DefaultCursors.HELP);
			registerCursor(Cursor.MOVE, DefaultCursors.MOVE);
			registerCursor(Cursor.NO_DROP, DefaultCursors.NO_DROP);
			registerCursor(Cursor.NONE, DefaultCursors.NONE);
			registerCursor(Cursor.NORTH, DefaultCursors.NORTH);
			registerCursor(Cursor.NORTH_EAST, DefaultCursors.NORTH_EAST);
			registerCursor(Cursor.NORTH_EAST_SOUTH_WEST, DefaultCursors.NORTH_EAST_SOUTH_WEST);
			registerCursor(Cursor.NORTH_SOUTH, DefaultCursors.NORTH_SOUTH);
			registerCursor(Cursor.NORTH_WEST, DefaultCursors.NORTH_WEST);
			registerCursor(Cursor.NORTH_WEST_SOUTH_EAST, DefaultCursors.NORTH_WEST_SOUTH_EAST);
			registerCursor(Cursor.NORTH_SOUTH, DefaultCursors.NOT_ALLOWED);
			registerCursor(Cursor.PROGRESS, DefaultCursors.PROGRESS);
			registerCursor(Cursor.ROW, DefaultCursors.ROW);
			registerCursor(Cursor.SOUTH, DefaultCursors.SOUTH);
			registerCursor(Cursor.SOUTH_EAST, DefaultCursors.SOUTH_EAST);
			registerCursor(Cursor.SOUTH_WEST, DefaultCursors.SOUTH_WEST);
			registerCursor(Cursor.VERTICAL_TEXT, DefaultCursors.VERTICAL_TEXT);
			registerCursor(Cursor.WAIT, DefaultCursors.WAIT);
			registerCursor(Cursor.WEST, DefaultCursors.WEST);
			registerCursor(Cursor.ZOOM_IN, DefaultCursors.ZOOM_IN);
			registerCursor(Cursor.ZOOM_OUT, DefaultCursors.ZOOM_OUT);
		}
		
		
		public static function getInstance():Cursor
		{
			return Singleton.getInstance(Cursor) as Cursor;
		}
		
		
		public static function useCursor(interactiveObject:InteractiveObject, cursor:String):void
		{
			Cursor.getInstance().useCursor(interactiveObject, cursor);
		}
		
		
		public function registerCursor(name:String, cursor:Object):void
		{
			if (cursor is Class) {
				cursor = new cursor();
			}
			
			if ( !(cursor is DisplayObject) ) {
				throw new ArgumentError("Cursor registration failed. Cursors must be display objects.");
			}
			
			if (cursor is InteractiveObject) {
				InteractiveObject(cursor).mouseEnabled = false;
				if (cursor is DisplayObjectContainer) {
					DisplayObjectContainer(cursor).mouseChildren = false;
				}
			}
			
			cursors[name] = cursor;
		}
		
		
		public function useCursor(interactiveObject:InteractiveObject, cursor:String):void
		{
			if (cursor == AUTO) {
				delete objects[interactiveObject];
				interactiveObject.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				interactiveObject.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			} else {
				objects[interactiveObject] = cursor;
				interactiveObject.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				interactiveObject.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		/**
		 * Handle the rollOver event.
		 */
		private function onRollOver(event:MouseEvent):void
		{
			showObjectCursor(event.target as InteractiveObject);
			
			// update the custom cursor right away if any
			if (currentCursor) {
				onMouseMove(event);
			}
		}
		
		/**
		 * Handle the rollOut event.
		 */
		private function onRollOut(event:MouseEvent):void
		{
			hideObjectCursor(event.target as InteractiveObject);
			
			// update the next custom cursor right away if any
			if (currentCursor) {
				onMouseMove(event);
			}
		}
		
		/**
		 * Handle a mouseMove event when there is a custom cursor on the stage.
		 */
		private function onMouseMove(event:MouseEvent):void
		{
			currentCursor.x = event.stageX;
			currentCursor.y = event.stageY;
			event.updateAfterEvent();
		}
		
		/**
		 * Handle a mouseLeave event. The mouse does a rollOut of all the items on the stage.
		 */
		private function onMouseLeave(event:Event):void
		{
			hideObjectCursor(null);
		}
		
		/**
		 * Process and show an object's cursor.
		 */
		private function showObjectCursor(interactiveObject:InteractiveObject):void
		{
			if (stack.length) {
				removeCursor(stack[stack.length - 1].object);
			}
			var depth:uint = 0;
			var p:DisplayObject = interactiveObject;
			while (p = p.parent) depth++;
			stack.push({object: interactiveObject, depth: depth});
			stack.sortOn("depth");
			addCursor(stack[stack.length - 1].object);
		}
		
		/**
		 * Remove or hide an object's cursor.
		 */
		private function hideObjectCursor(interactiveObject:InteractiveObject):void
		{
			while (stack.length && stack.pop().object != interactiveObject);
			
			if (interactiveObject) {
				removeCursor(interactiveObject);
			}
			
			if (stack.length) {
				addCursor(stack[stack.length - 1].object);
			}
		}
		
		/**
		 * Place the cursor on the stage if custom, or set the Mouse.cursor property if not.
		 */
		private function addCursor(interactiveObject:InteractiveObject):void
		{
			var cursor:String = objects[interactiveObject];
			
			if (cursor == AUTO) {
				Mouse.show();
				if ("cursor" in Mouse) {
					Mouse["cursor"] = AUTO;
				}
			} else if (cursor in cursors) {
				Mouse.hide();
				var display:DisplayObject = cursors[cursor];
				interactiveObject.stage.addChild(display);
				currentCursor = display;
				interactiveObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				interactiveObject.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			} else if ("cursor" in Mouse) {
				try {
					Mouse["cursor"] = cursor;
				} catch (e:ArgumentError) {
					Mouse["cursor"] = AUTO;
				}
			}
		}
		
		/**
		 * Remove the cursor on the stage if custom, or set AUTO if not.
		 */
		private function removeCursor(interactiveObject:InteractiveObject):void
		{
			var cursor:String = objects[interactiveObject];
			
			// custom cursor type
			if (cursor in cursors) {
				Mouse.show();
				var display:DisplayObject = cursors[cursor];
				interactiveObject.stage.removeChild(display);
				currentCursor = null;
				interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				interactiveObject.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			// built-in cursor type
			} else if ("cursor" in Mouse) {
				Mouse["cursor"] = AUTO; // handle flash 9 nicely
			}
		}
		
		
	}
}