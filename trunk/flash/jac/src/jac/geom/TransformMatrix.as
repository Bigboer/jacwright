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
	import flash.geom.Matrix;
	
	public final class TransformMatrix extends Matrix
	{
		
		/**
		 * Constructor, same as the Matrix constructor.
		 */
		public function TransformMatrix(a:Number=1, b:Number=0, c:Number=0, d:Number=1, tx:Number=0, ty:Number=0)
		{
			super(a, b, c, d, tx, ty);
		}
		
		
		/**
		 * Copies the properties of matrix m to this matrix.
		 * 
		 * @return This matrix.
		 */
		public function become(m:Matrix):TransformMatrix
		{
			a = m.a;
			b = m.b;
			c = m.c;
			d = m.d;
			tx = m.tx;
			ty = m.ty;
			return this;
		}
		
		
		/**
		 * Multiplies this object with <code>matrix</code> and returns the
		 * result. This is the reverse of concat.
		 * 
		 * @param A Matrix or Transform instance.
		 * @return A new matrix.
		 */
		public function multiply(m:Matrix):TransformMatrix
		{
			m = fromMatrix(m);
			m.concat(this);
			return m as TransformMatrix;
		}
		
		
		/**
		 * Divides this object with <code>matrix</code> and returns the result.
		 * This is the reverse of concatinating an inverse of matrix.
		 * 
		 * @param A Matrix or Transform instance.
		 * @return A new matrix.
		 */
		public function divide(m:Matrix):TransformMatrix
		{
			m = fromMatrix(m);
			m.invert();
			m.concat(this);
			return m as TransformMatrix;
		}
		
		
		/**
		 * Get the inverse of this matrix.
		 * 
		 * @return The inverse of this matrix.
		 */
		public function inverse():TransformMatrix
		{
			var m:TransformMatrix = cloneTransform();
			m.invert();
			return m;
		}
		
		
		/**
		 * Translate this matrix and return the result.
		 * 
		 * @return A new matrix.
		 */
		public function translateMatrix(dx:Number, dy:Number):TransformMatrix
		{
			var m:TransformMatrix = cloneTransform();
			m.translate(dx, dy);
			return m;
		}
		
		
		/**
		 * Rotate this matrix and return the result.
		 * 
		 * @return A new matrix.
		 */
		public function rotateMatrix(angle:Number):TransformMatrix
		{
			var m:TransformMatrix = cloneTransform();
			m.rotate(angle);
			return m;
		}
		
		
		/**
		 * Scale this matrix and return the result.
		 * 
		 * @return A new matrix.
		 */
		public function scaleMatrix(scaleX:Number = 1, scaleY:Number = 1):TransformMatrix
		{
			var m:TransformMatrix = cloneTransform();
			m.scale(scaleX, scaleY);
			return m;
		}
		
		
		/**
		 * Skew this matrix and return the result.
		 * 
		 * @return A new matrix.
		 */
		public function skewPercent(percentX:Number = 0, percentY:Number = 0):TransformMatrix
		{
			var skew:TransformMatrix = new TransformMatrix(1, percentY, percentX);
			return multiply(skew);
		}
		
		
		/**
		 * Skew this matrix and return the result.
		 * 
		 * @return A new matrix.
		 */
		public function skewAngle(angleX:Number = 0, angleY:Number = 0):TransformMatrix
		{
			var skew:TransformMatrix = new TransformMatrix(1, Math.tan(angleY), Math.tan(angleX));
			return multiply(skew);
		}
		
		
		/**
		 * Checks if this matrix equals the identity matrix. Anything
		 * multiplied by the identity matrix is equal to the result.
		 * 
		 * @return Whether this is an identity matrix or not.
		 */ 
		public function isIdentity():Boolean
		{
			return (a == 1
				&& b == 0
				&& c == 0
				&& d == 1
				&& tx == 0
				&& ty == 0);
		}
		
		
		/**
		 * Compares against <code>matrix</code> to determine if it is equal to
		 * this object. This does not check if <code>matrix</code> is of the
		 * the same type (e.g. Matrix vs Transform), just whether they
		 * represent the same transformation.
		 * 
		 * @return Whether or not the matrices are equal.
		 */ 
		public function equals(matrix:Matrix):Boolean
		{
			return (a == matrix.a
				&& b == matrix.b
				&& c == matrix.c
				&& d == matrix.d
				&& tx == matrix.tx
				&& ty == matrix.ty);
		}
		
		/**
		 * Clones this Transform and returns the result. Could not
		 * override the parent <code>clone</code> method because the signatures
		 * are different. <code>clone2</code> returns a Transform.
		 * 
		 * @return A clone of this Transform.
		 */
		public function cloneTransform():TransformMatrix
		{
			return new TransformMatrix(a, b, c, d, tx, ty);
		}
		
		
		/**
		 * Creates a new Transform from the provided matrix. This
		 * effectively clones and converts the matrix to a Transform.
		 * 
		 * @return The new Transform which equals <code>matrix</code>
		 */
		public static function fromMatrix(matrix:Matrix):TransformMatrix
		{
			return new TransformMatrix(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		}
		
		/**
		 * Takes two matrices and interpolates between the two for tweening.
		 * Use this to tween between two matrices.
		 * 
		 * @param Starting or base matrix to interpolate or tween from.
		 * @param The matrix to tween too.
		 * @param The percentage of the path complete, often 0.0 to 0.1 though
		 * not always.
		 */
		public static function interpolate(m1:Matrix, m2:Matrix, fration:Number):TransformMatrix
		{
			return new TransformMatrix(
				m1.a + (m2.a - m1.a)*fration,
				m1.b + (m2.b - m1.b)*fration,
				m1.c + (m2.c - m1.c)*fration,
				m1.d + (m2.d - m1.d)*fration,
				m1.tx + (m2.tx - m1.tx)*fration,
				m1.ty + (m2.ty - m1.ty)*fration);
		}
		
		/**
		 * Parses a matrix from a string representation. Supports the formats
		 * allowed in SVG.
		 * 
		 * @param A transform string. Format from SVG.
		 * @return A Transform object.
		 */
		public static function fromString(transformString:String):TransformMatrix
		{
			var t:TransformMatrix = new TransformMatrix();
			var command:Array;
			var regex:RegExp = new RegExp('(\\w+)\\s*\\(([^\\)]*)\\)', 'ig');
			
			while (command = regex.exec(transformString)) {
				var method:String = command[1];
				var params:Array = command[2].split(/\s*,\s*|\s+/);
				
				switch (method) {
					case "matrix":
						if (params.length != 6) continue;
						params.map(toNumber);
						t.a = params[0];
						t.b = params[1];
						t.c = params[2];
						t.d = params[3];
						t.tx = params[4];
						t.ty = params[5];
						break;
					case "translate":
						if (params.length == 0) continue;
						params.map(toNumber);
						t.translate(params[0], params.length > 1 ? params[1] : 0);
						break;
					case "scale":
						if (params.length == 0) continue;
						params.map(toNumber);
						t.scale(params[0], params.length > 1 ? params[1] : params[0]);
						break;
					case "rotate":
						if (params.length < 1) continue;
						if (params.length == 3) {
							var x:Number = parseFloat(params[1]);
							var y:Number = parseFloat(params[1]);
							t.translate(x, y);
							t.rotate(Angle.fromString(params[0]));
							t.translate(-x, -y);
						} else {
							t.rotate(Angle.fromString(params[0]));
						}
						break;
					case "skewX":
						if (params.length < 1) continue;
						t.skewAngle(Angle.fromString(params[0]));
						break;
					case "skewY":
						if (params.length < 1) continue;
						t.skewAngle(0, Angle.fromString(params[0]));
						break;
				}
			}
			return t;
		}
		
		/**
		 * Convert string numbers to floats.
		 */
		private static function toNumber(number:String, index:int, arr:Array):Number
		{
			return parseFloat(number);
		}
		
		
		//////////////  PROPERTIES  //////////////////
		//////////////////////////////////////////////
		
		
		public function get scaleX():Number
		{
			return Math.abs(Math.sqrt( Math.pow(a, 2) + Math.pow(b, 2) ));
		}
		public function set scaleX(value:Number):void
		{
			var adjust:Number = skewY;
			a = value * Math.cos(adjust);
			b = value * Math.sin(adjust);
		}
		
		public function get scaleY():Number
		{
			return Math.abs(Math.sqrt( Math.pow(c, 2) + Math.pow(d, 2) ));
		}
		public function set scaleY(value:Number):void
		{
			var adjust:Number = skewX;
			c = value * -Math.sin(adjust);
			d = value * Math.cos(adjust);
		}
		
		public function get skewX():Number
		{
			return Math.abs(Math.acos(d/scaleY));
		}
		public function set skewX(value:Number):void
		{
			var adjust:Number = scaleY;
			c = adjust * -Math.sin(value);
			d = adjust * Math.cos(value);
		}
		
		public function get skewY():Number
		{
			return Math.abs(Math.acos(a/scaleX));
		}
		public function set skewY(value:Number):void
		{
			var adjust:Number = scaleX;
			a = adjust * Math.cos(value);
			b = adjust * Math.sin(value);
		}
		
		public function get rotation():Number
		{
			return skewY;
		}
		public function set rotation(value:Number):void
		{
			skewX = value;
			skewY = value;
		}
		
	}
}