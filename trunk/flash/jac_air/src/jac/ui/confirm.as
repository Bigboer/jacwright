package jac.ui
{
	
	/**
	 * Pops up a syncronous confirm prompt. Same as the javascript confirm.
	 */
	public function confirm(text:String):Boolean
	{
		return alertLoader.window.confirm(text);
	}
}
