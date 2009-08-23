package jac.utils
{
	import flash.events.Event;
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
				if (Capabilities.playerType == "desktop")
					getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.addEventListener(Event.EXITING, onExiting, false, -1000);
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
					getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.addEventListener(Event.EXITING, onExiting, false, -1000);
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