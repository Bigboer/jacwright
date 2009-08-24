////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Tyler Wright
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
package jac.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * Data object representing a progression of any type.
	 */
	public class Progress extends EventDispatcher implements IProgress
	{
		private var loader:IEventDispatcher;
		private var _type:String = "";
		private var _position:Number = 0;
		private var _percent:Number = 0;
		private var _length:Number = 1;
		
		/**
		 * Constructs a Progress object, optionally allowing the instance to be
		 * tied to an IEventDispatcher dispatching a <code>ProgressEvent</code>.
		 * 
		 * @param	progressor			An IEventDispatcher object that
		 * 								dispatches a <code>ProgressEvent</code>.
		 */
		public function Progress(progressor:IEventDispatcher = null)
		{
			this.loader = progressor;
			if (progressor != null) {
				_type = "bytes";
				progressor.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			}
		}
		
		/**
		 * The type of progression represented by this object as a string, for
		 * example: "bytes", "packets" or "pixels".
		 */
		[Bindable(event="typeChange")]
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			if (_type == value) {
				return;
			}
			
			_type = value;
			if (hasEventListener("typeChange")) {
				dispatchEvent(new Event("typeChange"));
			}
		}
		
		/**
		 * The current position in the progression, between 0 and
		 * <code>length</code>.
		 */
		[Bindable(event="positionChange")]
		public function get position():Number
		{
			return _position;
		}
		public function set position(value:Number):void
		{
			value = Math.max(0, Math.min(_length, value));
			if (_position == value) {
				return;
			}
			
			_position = value;
			_percent = _position / _length;
			
			if (hasEventListener("positionChange")) {
				dispatchEvent(new Event("positionChange"));
			}
			if (hasEventListener("percentChange")) {
				dispatchEvent(new Event("percentChange"));
			}
		}
		
		/**
		 * The percent complete in the progress, as a number between 0 and 1
		 * with 1 being 100% complete.
		 */
		[Bindable(event="percentChange")]
		public function get percent():Number
		{
			return _percent;
		}
		public function set percent(value:Number):void
		{
			value = Math.max(0, Math.min(1, value));
			if (_percent == value) {
				return;
			}
			
			_percent = value;
			_position = _percent * _length;
			
			if (hasEventListener("percentChange")) {
				dispatchEvent(new Event("percentChange"));
			}
			if (hasEventListener("positionChange")) {
				dispatchEvent(new Event("positionChange"));
			}
		}
		
		/**
		 * The total length of the progression.
		 */
		[Bindable(event="lengthChange")]
		public function get length():Number
		{
			return _length;
		}
		public function set length(value:Number):void
		{
			value = Math.max(0, value);
			if (_length == value) {
				return;
			}
			
			_length = value;
			if (_position > _length) {
				position = _length;
			} else if (_position > 0) {
				percent = _position / _length;
			}
			if (hasEventListener("lengthChange")) {
				dispatchEvent(new Event("lengthChange"));
			}
		}
		
		/**
		 * Listener to an IEventDispatcher on the "progress" event.
		 */
		private function onProgress(event:ProgressEvent):void
		{
			length = event.bytesTotal;
			position = event.bytesLoaded;
		}
		
	}
}