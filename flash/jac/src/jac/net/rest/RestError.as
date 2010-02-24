package jac.net.rest
{
	public class RestError extends Error
	{
		public function RestError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}