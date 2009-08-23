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
	import flight.events.Dispatcher;
	
	import mx.core.IMXMLObject;

	public class UseCursor extends Dispatcher implements IMXMLObject
	{
		private var _cursor:String;
		
		[Bindable("cursorChange")]
		public function get cursor():String
		{
			return _cursor;
		}
		
		public function set cursor(value:String):void
		{
			if (value == null) value = "auto";
			if (_cursor == value) return;
			
			var old:String = _cursor;
			_cursor = value;
			//Cursor.useCursor(target, cursor);
			
			propertyChange("cursor", old, value);
		}
		
		
		public function initialized(document:Object, id:String):void
		{
			
		}
	}
}