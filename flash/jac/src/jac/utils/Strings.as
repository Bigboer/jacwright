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
package jac.utils
{
	import mx.utils.ObjectProxy;
	
	public dynamic class Strings extends ObjectProxy
	{
		/**
		 * This may be set to true to throw errors for strings which don't exist
		 */
		public static var throwErrors:Boolean = false;
		protected static var instance:Strings = new Strings();
		
		/**
		 * Returns the bindable translation object
		 */
		public static function get strings():Strings {
			return instance;
		}
		
		/**
		 * Returns the set translation for a string, or null if none has been defined
		 */
		public static function get(string:String):String {
			if (throwErrors && !(string in instance))
				throw new Error("String '" + string + "' undefined");
			return instance[string] || "";
		}
		
		/**
		 * Sets the translation for a string. An object of string->translation values may
		 * also be used to set many at once.
		 */
		public static function set(string:Object, translation:String = null):void {
			if (translation) {
				instance[string] = translation;
			} else {
				for (var i:String in string)
					instance[i] = string[i];
			}
		}
	}
}