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
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	public class Preferences
	{
		protected static var so:SharedObject;
		protected static var _prefs:Object;
		protected static var _securePrefs:Object;
		
		public static function getPreference(type:String, defaultValue:* = null):*
		{
			if (!prefs.hasOwnProperty(type))
				prefs[type] = defaultValue;
			
			return prefs[type];
		}
		
		public static function setPreference(type:String, value:*):void
		{
			prefs[type] = value;
		}
		
		public static function getSecurePreference(type:String, defaultValue:* = null):*
		{
			if (!securePrefs.hasOwnProperty(type))
				securePrefs[type] = defaultValue;
			
			return securePrefs[type];
		}
		
		public static function setSecurePreference(type:String, value:*):void
		{
			securePrefs[type] = value;
		}
		
		protected static function get prefs():Object
		{
			if (_prefs == null)
			{
				so = SharedObject.getLocal("preferences");
				_prefs = so.data;
				if (Capabilities.playerType == "desktop") {
					getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.addEventListener("exiting", onExiting, false, -1000);
				} else {
					try {
						var works:Boolean = ExternalInterface.call("eval", "true");
					} catch (e:Error) { }
					if (works) {
						ExternalInterface.addCallback("_prefOnBeforeUnloadSave", onExiting);
						ExternalInterface.call("eval", "window.attachEvent ? window.attachEvent('onbeforeunload', _prefOnBeforeUnloadSave) : window.addEventListener('beforeunload', _prefOnBeforeUnloadSave, false)");
					}
				}
			}
			
			return _prefs;
		}
		
		protected static function get securePrefs():Object
		{
			if (_securePrefs == null)
			{
				if (Capabilities.playerType == "desktop")
				{
					var EncryptedLocalStore:Object = getDefinitionByName("flash.data.EncryptedLocalStore");
					var ba:ByteArray = EncryptedLocalStore.getItem("preferences");
					_securePrefs = ba ? (ba.readObject() || {}) : {};
					// try to make it happen last, after everything else
					getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.addEventListener("exiting", onExiting, false, -1000);
				}
				else
					_securePrefs = prefs;
			}
			
			return _securePrefs;
		}
		
		protected static function onExiting(event:Event):void
		{
			if (so)
				so.flush();
			
			if (_securePrefs)
			{
				var ba:ByteArray = new ByteArray();
				ba.writeObject(_securePrefs);
				var EncryptedLocalStore:Object = getDefinitionByName("flash.data.EncryptedLocalStore");
				EncryptedLocalStore.setItem("preferences", ba);
			}
		}
	}
}