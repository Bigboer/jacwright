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
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	/**
	 * Flash Remoting service class which can be dynamically used to call
	 * methods on the service.
	 */
	public dynamic class RemoteProxy extends Proxy
	{
		public var gateway:String;
		public var source:String;
		protected var sources:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param The service gateway
		 */
		public function RemoteProxy(gateway:String = null)
		{
			this.gateway = gateway;
		}
		
		
		/**
		 * In the call <code>proxy.package.sayHi("mom")</code> the package part
		 * is handled by this getProperty method. It returns a new instance of
		 * RemoteProxy with the source set to the package ready for calls to be
		 * made on it.
		 */
		flash_proxy override function getProperty(name:*):* 
		{
			name = name.toString();
			var service:RemoteProxy;
			if (name in sources) {
				service = sources[name];
			} else {
				sources[name] = service = new RemoteProxy(gateway);
				service.source = source ? source + "." + name : name;
			}
			return service;
		}
		
		
		/**
		 * In the call <code>proxy.package.sayHi("mom")</code> the sayHi part
		 * is handled by this callProperty method. It sends the call to the
		 * server. The paramaters passed in will be passed to the server except
		 * if the last parameter is a function then that function will be called
		 * with the results of this service call when they return, or if the
		 * last two parameters are functions the second to the last will be the
		 * function called on a result and the last will be called on a fault.
		 */
		flash_proxy override function callProperty(method:*, ...params):* 
		{
			var response:Response = new Response();
			var command:String = source ? source + "." + method : method;
			params = [command, response.createResponder()].concat(params);
			var conn:NetConnection = new NetConnection();
			conn.connect(gateway);
			conn.call.apply(null, params);
			return response;
		}
	}
}