package jac.ui
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	public class ModalDialogWindow extends DialogWindow
	{
		private var windowCreated:Boolean = false;
		protected var currentFocus:InteractiveObject;
		
//		protected override function commitProperties():void
//		{
//			super.commitProperties();
//			
//			if (!windowCreated && nativeWindow)
//			{
//				nativeWindow.addEventListener(Event.DEACTIVATE, onDeactivate);
//				nativeWindow.stage.addEventListener(FocusEvent.FOCUS_IN, onFocusChange);
//			}
//		}
//		
//		protected function onFocusChange(event:FocusEvent):void
//		{
//			currentFocus = event.target as InteractiveObject;
//		}
//		
//		protected function onDeactivate(event:Event):void
//		{
//			callLater(restoreFocus);
//		}
//		
//		protected function restoreFocus():void
//		{
//			nativeWindow.activate();
//			nativeWindow.stage.focus = currentFocus;
//		}
	}
}