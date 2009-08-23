package jac.ui
{
	
	/**
	 * Pops up a syncronous prompt. Same as the javascript prompt.
	 */
	public function prompt(question:String, defaultValue:String = ""):String
	{
		return alertLoader.window.prompt(question, defaultValue);
	}
}
