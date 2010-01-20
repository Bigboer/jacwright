package jac.net.rest
{
	import flash.net.URLVariables;
	
	public interface IRestFormat
	{
		function getContentType():String;
		
		function modifyURLVariables(vars:URLVariables):void;
		
		function encode(data:Object):String;
		
		function decode(data:String):Object;
	}
}