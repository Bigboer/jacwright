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
	
	import flight.net.IResponse;
	import flight.net.Response;
	
	/**
	 * Flash Remoting service class. Abstracts the NetConnection and allows
	 * calls to be made with IResponses coming back.
	 */
	public class RemoteService
	{
		public var gateway:String;
		public var source:String;
		
		/**
		 * Constructor.
		 * 
		 * @param The service gateway
		 */
		public function RemoteService(gateway:String = null)
		{
			this.gateway = gateway;
		}
		
		
		/**
		 * Get a package or class/object on which to call the method.
		 * 
		 * @param The name of the package or class/object
		 * 
		 * @return A new remote service instance which points to that package.
		 */
		public function get(name:String):RemoteService
		{
			var service:RemoteService = new RemoteService(gateway);
			service.source = source ? source + "." + name : name;
			return service;
		}
		
		
		/**
		 * Call a method on the service or package.
		 * 
		 * @param The name of the method to call.
		 * @param The parameters needing to be passed to the call.
		 * 
		 * @return An IReponse object to respond to the results.
		 */
		public function call(method:String, params:Array):IResponse
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