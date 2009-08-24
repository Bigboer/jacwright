////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Jacob Wright, Tyler Wright
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
	import flight.progress.IProgress;
	import flight.utils.IMerging;
	
	/**
	 * An IResponse object represents a response to some action, replacing a
	 * function's regular return value in order to support asynchronous actions.
	 * By adding callback handlers an invoking object can receive the action's
	 * result when it completes.
	 */
	public interface IResponse
	{
		/**
		 * Indication of whether the response is in progress, has been completed
		 * or has faulted. Valid values of status are 'progress', 'result' and
		 * 'fault' respectfully.
		 * 
		 * @see		flight.net.ResponseStatus
		 */
		[Bindable(event="statusChange")]
		function get status():String;
		function set status(value:String):void;
		
		/**
		 * The progress of the response completion. Valuable when measuring
		 * asynchronous progression.
		 * 
		 * @see		flight.progress.IProgress
		 */
		[Bindable(event="progressChange")]
		function get progress():IProgress;
		function set progress(value:IProgress):void;
		
		/**
		 * Adds a callback handler to be invoked with the successful results of
		 * the response. Result handlers receive data and have the opportunity
		 * to format the data for subsequent handlers. They can also trigger the
		 * response's fault if the data is invalid by returning an Error.
		 * 
		 * <p>The method signature should describe a data object as the first
		 * parameter. Additional parameters may be defined and provided when
		 * adding the result handler.</p>
		 * 
		 * <p>To format data for subsequent handlers the result handler may
		 * return a new value in its method signature. To end the result cycle
		 * and trigger the fault cycle an Error type should be returned.
		 * Additionally returning another IResponse type will link this response
		 * to the other's completion. Otherwise the return type should be
		 * <code>void</code>.</p>
		 * 
		 * <p>
		 * <pre>
		 * 	// example of a formatting handler - also showing a possible fault
		 * 	private function onResult(data:Object):Object
		 * 	{
		 * 		var amf:ByteArray = data as ByteArray;
		 * 		try {
		 * 			data = amf.readObject();
		 * 		} catch (error:Error) {
		 * 			// ejects out of the result handling phase and into fault handling
		 * 			return new Error("Invalid AMF response: " + amf.toString());
		 * 		}
		 * 		return data;
		 * 	}
		 * </pre>
		 * </p>
		 * 
		 * @param	handler			The handler method to be invoked upon
		 * 							response success.
		 * @param	resultParams	Additional parameters to be passed to the
		 * 							handler upon execution.
		 * 
		 * @return					A reference to this instance of IResponse,
		 * 							useful for method chaining.
		 */
		function handle(resultHandler:Function, ... resultParams):IResponse;
		
		/**
		 * Removes a result callback handler that has been previously added.
		 * 
		 * @param	handler			The handler method to remove.
		 * 
		 * @return					A reference to this instance of IResponse,
		 * 							useful for method chaining.
		 */
		function removeHandler(resultHandler:Function):IResponse;
		
		/**
		 * Adds a callback handler to be invoked with the failure of the
		 * response, receiving an error.
		 * 
		 * <p>The method signature should describe an error type as the first
		 * parameter. Additional parameters may be defined and provided when
		 * adding the fault handler.</p>
		 * 
		 * <p>To cancel the fault cycle the handler may return an IResponse in
		 * its method signature, otherwise the return type should be
		 * <code>void</code>. Returning another IResponse type will link this
		 * response to the other's completion.</p>
		 * 
		 * <p>
		 * <pre>
		 * 	import mx.controls.Alert;
		 * 	
		 * 	// example of a fault handler
		 * 	private function onFault(error:Error):void
		 * 	{
		 * 		Alert.show(error.message, "Error");
		 * 	}
		 * </pre>
		 * </p>
		 * 
		 * @param	handler			The handler method to be invoked upon
		 * 							response failure.
		 * @param	resultParams	Additional parameters to be passed to the
		 * 							handler upon execution.
		 * 
		 * @return					A reference to this instance of IResponse,
		 * 							useful for method chaining.
		 */
		function handleError(errorHandler:Function, ... errorParams):IResponse;
		
		/**
		 * Removes a fault callback handler that has been previously added.
		 * 
		 * @param	handler			The handler method to remove.
		 * 
		 * @return					A reference to this instance of IResponse,
		 * 							useful for method chaining.
		 */
		function removeErrorHandler(errorHandler:Function):IResponse;
		 
		/**
		 * Completes the response with the specified data, triggering the result
		 * cycle.
		 * 
		 * @param	data			The resulting data.
		 */
		function complete(data:Object):void;
		
		/**
		 * Cancels the response with an error, triggering the fault cycle.
		 * 
		 * @param	error			The faulting error.
		 */
		function cancel(error:Error):void;
		
	}
}