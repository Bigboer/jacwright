package jac.net.rest
{
	import flash.net.URLVariables;
	
	import jac.utils.JSON;
	
	public class JSONFormat implements IRestFormat
	{
		
		public function getContentType():String
		{
			return "application/json";
		}
		
		public function getUrlContentType():String
		{
			return "json";
		}
		
		public function encode(data:Object):String
		{
			return data == null ? null : JSON.encode(data);
		}
		
		public function decode(data:String):Object
		{
			return data ? JSON.decode(data) : null;
		}
		
	}
}