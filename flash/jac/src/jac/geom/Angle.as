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
package jac.geom
{
	/**
	 * Utility class that helps transform between degrees and radians. The
	 * default angle is radians.
	 */
	public class Angle
	{
		/**
		 * Takes a string value of an angle (e.g. deg(90)) and converts it into
		 * radians.
		 */
		public static function fromString(angle:String):Number
		{
			var parts:Array = angle.match(/(\d*.?\d+)(\w*)/);
			var value:Number = parseFloat(parts[1]);
			if (isNaN(value)) {
				return 0;
			}
			var unit:String = parts[2] || "deg";
			if (unit == "deg") {
				value = fromDegrees(value);
			} else if (unit == "grad") {
				value = fromGrads(value);
			} else if (unit != "rad") {
				return 0; // syntax error
			}
			
			return value;
		}
		
		
		/**
		 * Converts grads to radians, for use with Transform rotations.
		 */
		public static function fromGrads(grads:Number):Number
		{
			return grads * Math.PI/200;
		}
		
		
		/**
		 * Converts degrees to radians, for use with Transform rotations.
		 */
		public static function fromDegrees(degrees:Number):Number
		{
			return degrees * Math.PI/180;
		}
		
		/**
		 * Converts radians to degrees, for use with Transform rotations.
		 */
		public static function toDegree(radians:Number):Number
		{
			return radians * 180/Math.PI;
		}
		
		
	}
}