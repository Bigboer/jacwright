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
	import jac.motion.easing.EasingFraction;
	import jac.motion.easing.IEaser;
	import jac.motion.easing.Linear;
	import jac.motion.easing.Power;
	import jac.motion.easing.Sine;
	
	public class Easing
	{
		
		public static var none:IEaser = new Linear();
		
		public static var inQuad:IEaser = new Power(EasingFraction.IN, 2);
		public static var outQuad:IEaser = new Power(EasingFraction.OUT, 2);
		public static var inOutQuad:IEaser = new Power(EasingFraction.IN_OUT, 2);
		
		public static var inCubic:IEaser = new Power(EasingFraction.IN, 3);
		public static var outCubic:IEaser = new Power(EasingFraction.OUT, 3);
		public static var inOutCubic:IEaser = new Power(EasingFraction.IN_OUT, 3);
		
		public static var inQuart:IEaser = new Power(EasingFraction.IN, 3);
		public static var outQuart:IEaser = new Power(EasingFraction.OUT, 3);
		public static var inOutQuart:IEaser = new Power(EasingFraction.IN_OUT, 3);
		
		public static var inQuint:IEaser = new Power(EasingFraction.IN, 3);
		public static var outQuint:IEaser = new Power(EasingFraction.OUT, 3);
		public static var inOutQuint:IEaser = new Power(EasingFraction.IN_OUT, 3);
		
		public static var inSine:IEaser = new Sine(EasingFraction.IN);
		public static var outSine:IEaser = new Sine(EasingFraction.OUT);
		public static var inOutSine:IEaser = new Sine(EasingFraction.IN_OUT);
		
//	
//		/**
//		 * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inExpo (fraction:Number):Number {
//			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
//		}
//	
//		/**
//		 * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outExpo (fraction:Number):Number {
//			return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
//		}
//	
//		/**
//		 * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inOutExpo (fraction:Number):Number {
//			if (t==0) return b;
//			if (t==d) return b+c;
//			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
//			return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
//		}
//	
//		/**
//		 * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outInExpo (fraction:Number):Number {
//			if (t < d/2) return outExpo (t*2, b, c/2, d);
//			return inExpo((t*2)-d, b+c/2, c/2, d);
//		}
//	
//		/**
//		 * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inCirc (fraction:Number):Number {
//			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
//		}
//	
//		/**
//		 * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outCirc (fraction:Number):Number {
//			return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
//		}
//	
//		/**
//		 * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
// 		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inOutCirc (fraction:Number):Number {
//			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
//			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
//		}
//	
//		/**
//		 * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outInCirc (fraction:Number):Number {
//			if (t < d/2) return outCirc (t*2, b, c/2, d);
//			return inCirc((t*2)-d, b+c/2, c/2, d);
//		}
//	
//		/**
//		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param a		Amplitude.
//		 * @param p		Period.
//		 * @return		The correct value.
//		 */
//		public static function inElastic (fraction:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
//			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
//			var s:Number;
//			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
//			else s = p/(2*Math.PI) * Math.asin (c/a);
//			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
//		}
//	
//		/**
//		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param a		Amplitude.
//		 * @param p		Period.
//		 * @return		The correct value.
//		 */
//		public static function outElastic (fraction:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
//			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
//			var s:Number;
//			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
//			else s = p/(2*Math.PI) * Math.asin (c/a);
//			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
//		}
//	
//		/**
//		 * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param a		Amplitude.
//		 * @param p		Period.
//		 * @return		The correct value.
//		 */
//		public static function inOutElastic (fraction:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
//			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
//			var s:Number;
//			if (!a || a < Math.abs(c)) { a=c; s=p/4; }
//			else s = p/(2*Math.PI) * Math.asin (c/a);
//			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
//			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
//		}
//	
//		/**
//		 * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param a		Amplitude.
//		 * @param p		Period.
//		 * @return		The correct value.
//		 */
//		public static function outInElastic (fraction:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
//			if (t < d/2) return outElastic (t*2, b, c/2, d, a, p);
//			return inElastic((t*2)-d, b+c/2, c/2, d, a, p);
//		}
//	
//		/**
//		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
//		 * @return		The correct value.
//		 */
//		public static function inBack (fraction:Number, s:Number = Number.NaN):Number {
//			if (!s) s = 1.70158;
//			return c*(t/=d)*t*((s+1)*t - s) + b;
//		}
//	
//		/**
//		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
//		 * @return		The correct value.
//		 */
//		public static function outBack (fraction:Number, s:Number = Number.NaN):Number {
//			if (!s) s = 1.70158;
//			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
//		}
//	
//		/**
//		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
//		 * @return		The correct value.
//		 */
//		public static function inOutBack (fraction:Number, s:Number = Number.NaN):Number {
//			if (!s) s = 1.70158;
//			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
//			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
//		}
//	
//		/**
//		 * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @param s		Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
//		 * @return		The correct value.
//		 */
//		public static function outInBack (fraction:Number, s:Number = Number.NaN):Number {
//			if (t < d/2) return outBack (t*2, b, c/2, d, s);
//			return inBack((t*2)-d, b+c/2, c/2, d, s);
//		}
//	
//		/**
//		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inBounce (fraction:Number):Number {
//			return c - outBounce (d-t, 0, c, d) + b;
//		}
//	
//		/**
//		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outBounce (fraction:Number):Number {
//			if ((t/=d) < (1/2.75)) {
//				return c*(7.5625*t*t) + b;
//			} else if (t < (2/2.75)) {
//				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
//			} else if (t < (2.5/2.75)) {
//				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
//			} else {
//				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
//			}
//		}
//	
//		/**
//		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function inOutBounce (fraction:Number):Number {
//			if (t < d/2) return inBounce (t*2, 0, c, d) * .5 + b;
//			else return outBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
//		}
//	
//		/**
//		 * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration.
//		 *
//		 * @param t		Current time (in frames or seconds).
//		 * @param b		Starting value.
//		 * @param c		Change needed in value.
//		 * @param d		Expected easing duration (in frames or seconds).
//		 * @return		The correct value.
//		 */
//		public static function outInBounce (fraction:Number):Number {
//			if (t < d/2) return outBounce (t*2, b, c/2, d);
//			return inBounce((t*2)-d, b+c/2, c/2, d);
//		}

	}
}