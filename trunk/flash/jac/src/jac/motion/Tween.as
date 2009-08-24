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
package jac.motion
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import jac.net.IResponse;
	import jac.net.Response;
	
	import jac.motion.easing.IEaser;
	
	public class Tween
	{
		public static var timer:Timer = new Timer(30);
		public var target:Object;
		public var params:Array = [];
		public var startTime:Number;
		
		public var duration:Number = 1;
		public var easing:IEaser = Easing.none;
		
		protected var response:Response;
		
		public function Tween(target:Object = null, params:Object = null)
		{
			this.target = target;
			
			if ("duration" in params) duration = params.duration;
			if ("easing" in params) easing = params.easing;
			
			for (var i:String in params) {
				if (i in target) {
					this.params.push(new Value(i, target[i], params[i]));
					trace("Tweening", i, "from", target[i], "to", params[i]);
				}
			}
		}
		
		
		public function start():IResponse
		{
			if (!timer.running) {
				timer.start();
			}
			
			timer.addEventListener(TimerEvent.TIMER, onUpdate);
			startTime = getTimer();
			
			return response = new Response();
		}
		
		
		public function stop():void
		{
			timer.removeEventListener(TimerEvent.TIMER, onUpdate);
			
			if (!timer.hasEventListener(TimerEvent.TIMER)) {
				timer.stop();
			}
			
			response.complete(this);
		}
		
		
		protected function onUpdate(event:Event):void
		{
			var time:Number = getTimer() - startTime;
			var value:Value;
			var duration:Number = this.duration*1000;
			
			if (time >= duration) {
				for each(value in params) {
					target[value.name] = value.end;
				}
				stop();
			} else {
				for each(value in params) {
					target[value.name] = value.start + value.delta*easing.ease(time/duration);
				}
			}
		}

	}
}

internal final class Value
{
	public var name:String;
	public var start:Number;
	public var delta:Number;
	public var end:Number;
	
	public function Value(name:String, start:Number, end:Number):void
	{
		this.name = name;
		this.start = start;
		this.end = end;
		this.delta = start - end;
	}
}
