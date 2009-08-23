package jac.db
{
	import flash.events.Event;

	public class DatabaseEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const COMPLETE:String = "complete";
		public static const ALL_COMPLETE:String = "allComplete";
		
		public var successful:Boolean;
		public var result:*;
		public var error:Error;
		
		public function DatabaseEvent(type:String, success:Boolean, result_or_error:* = null)
		{
			super(type);
			
			this.successful = success;
			if (success) {
				result = result_or_error;
			} else {
				error = result_or_error;
			}
		}
		
	}
}