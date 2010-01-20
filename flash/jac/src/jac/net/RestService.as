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
package jac.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	import flight.net.IResponse;
	import flight.net.Response;
	import flight.progress.Progress;
	
	import jac.net.rest.IRestFormat;
	
	public class RestService
	{
		public var _baseUrl:String;
		public var format:IRestFormat;
		
		public function RestService(format:IRestFormat, baseUrl:String = "")
		{
			this.baseUrl = baseUrl;
			this.format = format;
		}
		
		public function get baseUrl():String
		{
			return _baseUrl;
		}
		
		public function set baseUrl(value:String):void
		{
			value = value.replace(/^\s|\s$/, "");
			if (value != "") {
				if (value.charAt(value.length - 1) != "/") {
					value += "/";
				}
			}
			
			if (value == _baseUrl) return;
			
			_baseUrl = value;
		}
		
		public function GET(path:String, params:Object = null):IResponse
		{
			params = getParams(params);
			return sendRequest("GET", path, null, getParams(params));
		}
		
		public function POST(path:String, data:Object):IResponse
		{
			return sendRequest("POST", path, format.encode(data));
		}
		
		public function PUT(path:String, data:Object):IResponse
		{
			return sendRequest("PUT", path, format.encode(data));
		}
		
		public function DELETE(path:String, params:Object = null):IResponse
		{
			return sendRequest("DELETE", path, null, getParams(params));
		}
		
		
		protected function sendRequest(method:String, path:String, data:Object = null, params:URLVariables = null):Response
		{
			if (params == null) params = new URLVariables();
			format.modifyURLVariables(params);
			var vars:String = params.toString();
			var request:URLRequest = new URLRequest(getUrl(path) + (vars ? "?" + vars : ""));
			request.method = method;
			request.data = data;
			request.contentType = format.getContentType();
			request.requestHeaders.push(new URLRequestHeader("Accept", format.getContentType()));
			
			if (Capabilities.playerType != "Desktop" && method == "PUT" || method == "DELETE") {
				request.method = "POST";
				request.requestHeaders.push(new URLRequestHeader("X-HTTP-Method-Override", method));
			}
			
			var response:Response = new Response();
			
			var stream:URLStream = new URLStream();
			
			var progress:Progress = new Progress(stream);
			response.progress = progress;
			response.addCompleteEvent(stream, Event.COMPLETE).addCancelEvent(stream, SecurityErrorEvent.SECURITY_ERROR).addCancelEvent(stream, IOErrorEvent.IO_ERROR);
			response.addResultHandler(getStreamData).addResultHandler(format.decode);
			
			stream.load(request);
			
			return response;
		}
		
		protected function getParams(params:Object):URLVariables
		{
			if (params != null) {
				var vars:URLVariables = new URLVariables();
				for (var i:String in params) {
					vars[i] = params[i];
				}
				params = vars;
			}
			return params as URLVariables;
		}
		
		protected function getUrl(path:String):String
		{
			if (_baseUrl.length && path.charAt(0) == "/") {
				path = path.substr(1);
			}
			return baseUrl + path;
		}
		
		protected function getStreamData(stream:URLStream):*
		{
			return stream.readUTFBytes(stream.bytesAvailable);
		}
	}
}
