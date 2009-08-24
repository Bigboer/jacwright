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
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import jac.net.IResponse;
	import jac.net.Response;
	import flight.utils.Singleton;
	
	public class ImageLibrary
	{
		[Embed(source="jac/assets/missingImage.png")]
		protected var missingImageClass:Class;
		protected var missingImageBox:Sprite;
		protected var expires:uint;
		protected var timer:Timer;
		
		/**
		 * Stores all the bitmap objects for images that have been loaded with
		 * their URL as the key.
		 */
		protected var images:Object = {};
		
		
		public static function getInstance(scope:Object = null, defaultExpires:uint = 0):ImageLibrary
		{
			var lib:ImageLibrary = Singleton.getInstance(ImageLibrary, scope) as ImageLibrary;
			lib.expires = defaultExpires;
			return lib;
		}
		
		/**
		 * Constructor. Creates the default missing image bitmap data to return
		 * when there is an error loading an image.
		 */
		public function ImageLibrary()
		{
			var missingImage:Bitmap = new missingImageClass();
			images.missingImage = missingImage.bitmapData;
			missingImageBox = new Sprite();
			missingImageBox.addChild(missingImage);
			timer = new Timer(15000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		
		private function onTimer():void
		{
			flushExpiredImages();
		}
		
		
		public function flushExpiredImages():void
		{
			var now:uint = getTimer();
			for (var i:String in images) {
				var data:Image = images[i];
				if (data.expires && data.expires < now) {
					data.bitmapData.dispose();
					delete images[i];
				}
			}
		}
		
		public function clean():void
		{
			for (var i:String in images) {
				var data:Image = images[i];
				data.bitmapData.dispose();
				delete images[i];
			}
		}
		
		
		/**
		 * Will return a BitmapData object as the result of the IResponse object
		 * handler. If the image has been loaded once already it will call the
		 * result handlers immediately. Otherwise they will be called once the
		 * image is loaded. The image must be in a domain with a crossdomain
		 * policy, otherwise the bitmap data cannot be retrieved, stored,
		 * resized, and reused as the library needs to.
		 * 
		 * @param The url for the image to be loaded.
		 * @param Optionally the size the image must fit to.
		 * @param Optionally whether the image should constrain its proportions
		 * when resizing to fit in the <code>size</code> parameter.
		 * @param Optionally set an expires time in minutes for when this image
		 * should be let go from memory.
		 * 
		 * @return The response object which may have result or fault handlers
		 * added to it. This allows for async and non-async operations.
		 */
		public function getImage(url:String, width:uint = 0, height:uint = 0, resizeStyle:String = "constrainProportions", expires:uint = 0):IResponse
		{
			var response:Response = new Response();
			expires = expires || this.expires;
			expires = expires ? expires*60000 + getTimer() : 0;
			
			if (url in images) {
				var image:Image = images[url];
				image.expires = expires;
				var bitmapData:BitmapData = image.bitmapData;
				response.handle(sizeImage, width, height, resizeStyle);
				response.complete(bitmapData);
				return response;
			}
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest(url));
			response.addCompleteEvent(loader, Event.COMPLETE);
			response.addCancelEvent(loader, IOErrorEvent.IO_ERROR);
			response.addCancelEvent(loader, SecurityErrorEvent.SECURITY_ERROR);
			response.handle(convertToLoader)
				.handle(storeImage, url, expires)
				.handle(sizeImage, width, height, resizeStyle)
				.handleError(returnMissingImage, response, width, height);
			return response;
		}
		
		
		/**
		 * Turns the results of the loader.load into bitmapdata.
		 */
		protected function sizeImage(data:Object, width:uint, height:uint, resizeStyle:String = "constrainProportions"):BitmapData
		{
			var bitmapData:BitmapData = data as BitmapData;
			if (!width && !height || width == bitmapData.width && height == bitmapData.height) {
				return bitmapData;
			} else {
				return ImageUtils.resizeImage(bitmapData, width, height, resizeStyle);
			}
		}
		
		
		/**
		 * Turns the results of the loader.load into bitmapdata.
		 */
		protected function storeImage(data:Object, url:String, expires:uint):BitmapData
		{
			var content:DisplayObject = LoaderInfo(data).content;
			var bitmapData:BitmapData;
			if (content is Bitmap) {
				bitmapData = Bitmap(content).bitmapData;
			} else {
				bitmapData = ImageUtils.snapshot(content);
			}
			
			images[url] = new Image(bitmapData, expires);
			return bitmapData;
		}
		
		
		/**
		 * 
		 */
		protected function convertToLoader(data:Object):Response
		{
			var urlLoader:URLLoader = data as URLLoader;
			var response:Response = new Response();
			var loader:Loader = new Loader();
			response.addCompleteEvent(loader.contentLoaderInfo, Event.COMPLETE);
			response.addCancelEvent(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR);
			response.addCancelEvent(loader.contentLoaderInfo, SecurityErrorEvent.SECURITY_ERROR);
			loader.loadBytes(urlLoader.data);
			return response;
		}
		
		
		/**
		 * Returns a missing image icon in place of the image when there is an
		 * error.
		 */
		protected function returnMissingImage(error:Error, response:Response, width:uint, height:uint):void
		{
			var image:BitmapData = images.missingImage;
			if (width && height) {
				if (missingImageBox.width != width || missingImageBox.height != height) {
					missingImageBox.graphics.clear();
					missingImageBox.graphics.beginFill(0, .4);
					missingImageBox.graphics.drawRect(0, 0, width, height);
					missingImageBox.graphics.drawRect(1, 1, width - 2, height - 2);
					missingImageBox.graphics.beginFill(0, .1);
					missingImageBox.graphics.drawRect(0, 0, width, height);
					missingImageBox.graphics.endFill();
				}
				image = ImageUtils.snapshot(missingImageBox);
			}
			response.removeHandler(convertToLoader).removeHandler(storeImage).removeHandler(sizeImage).complete(image);
		}
	}
}

import flash.display.BitmapData;

internal final class Image
{
	public var bitmapData:BitmapData;
	public var expires:uint;
	
	public function Image(bitmapData:BitmapData, expires:uint)
	{
		this.bitmapData = bitmapData;
		this.expires = expires;
	}
}