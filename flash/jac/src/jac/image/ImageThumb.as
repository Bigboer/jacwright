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
package jac.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import jac.net.IResponse;
	
	import mx.core.UIComponent;

	public class ImageThumb extends UIComponent
	{
		protected var _url:String;
		protected var _source:BitmapData;
		protected var _resizeStyle:String = ResizeStyle.CONSTRAIN_PROPORTIONS;
		protected var bitmap:Bitmap;
		protected var response:IResponse;
		protected var maxBitmapWidth:Number;
		protected var maxBitmapHeight:Number;
		
		
		[Bindable("urlChange")]
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			if (value == _url) return;
			_url = value;
			refreshBitmap();
			dispatchEvent(new Event("urlChange"));
		}
		
		
		[Bindable("sourceChange")]
		public function get source():BitmapData
		{
			return _source;
		}
		
		public function set source(value:*):void
		{
			if (value is String) {
				url = value;
				return;
			}
			
			if (value is Class) {
				value = new value();
			}
			
			if (value is BitmapData) {
				_source = value as BitmapData;
			} else if (value is Bitmap) {
				_source = Bitmap(value).bitmapData;
			} else if (source is DisplayObject) {
				_source = new BitmapData(value.width, value.height, true, 0);
				_source.draw(value);
			} else {
				throw new ArgumentError("Image source must be a url or a BitmapData object");
			}
			
			if (_url) {
				url = null;
			}
			dispatchEvent(new Event("sourceChange"));
		}
		
		
		[Inspectable(enumeration="constrainProportions,center,crop,stretch", defaultValue="constrainProportions")]
		[Bindable("resizeStyleChange")]
		public function get resizeStyle():String
		{
			return _resizeStyle;
		}
		
		public function set resizeStyle(value:String):void
		{
			if (value == _resizeStyle) return;
			_resizeStyle = value;
			refreshBitmap();
			dispatchEvent(new Event("resizeStyleChange"));
		}
		
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (unscaledWidth != maxBitmapWidth || unscaledHeight != maxBitmapHeight) {
				refreshBitmap();
			}
		}
		
		
		protected function refreshBitmap():void
		{
			if (response) {
				response.cancel(new Error("Refreshing"));
			}
			maxBitmapWidth = getExplicitOrMeasuredWidth();
			maxBitmapHeight = getExplicitOrMeasuredHeight();
			if (_url) {
				response = ImageLibrary.getInstance().getImage(_url, maxBitmapWidth, maxBitmapHeight, _resizeStyle).onComplete(onBitmapData);
			} else if (_source && bitmap) {
				bitmap.bitmapData = ImageUtils.resizeImage(_source, maxBitmapWidth, maxBitmapHeight, _resizeStyle);
			} else if (bitmap) {
				bitmap.bitmapData = null;
			}
		}
		
		
		protected function onBitmapData(bitmapData:BitmapData):void
		{
			bitmap.bitmapData = bitmapData;
			bitmap.x = (maxBitmapWidth - bitmapData.width)/2;
			bitmap.y = (maxBitmapHeight - bitmapData.height)/2;
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			bitmap = new Bitmap();
			addChild(bitmap);
			refreshBitmap();
		}
		
	}
}