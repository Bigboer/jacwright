////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2009 Tyler Wright, Jacob Wright
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
package jac.utils
{
	
	public class Color
	{
		
		private var _r:uint = 0;
		private var _g:uint = 0;
		private var _b:uint = 0;
		
		private var _h:uint = 0;
		private var _l:uint = 0;
		private var _s:uint = 0;
		
		private var invalidateRGB:Boolean;
		private var invalidateHLS:Boolean;
		
		
		public function Color(value:Object)
		{
			if (value is Number)
				color = value as Number;
			else if (value.r != null)
				rgb = value;
			else if (value.h != null)
				hls = value;
		}
		
		
		// :: Public Methods :: //
		
		public function brighten(amount:int):uint
		{
			l += amount;
			return color;
		}
		
		// :: Getters / Setters :: //
		
		public function get color():uint
		{
			return (r << 16) + (g << 8) + (b << 0);
		}
		
		public function set color(value:uint):void
		{
			r = (value >> 16) & 0xFF;
			g = (value >> 8) & 0xFF;
			b = (value >> 0) & 0xFF;
		}
		
		public function get r():uint {
			if (invalidateRGB)
				validateRGB();
			
			return _r;
		}
		public function set r(value:uint):void {
			_r = value;
			invalidateHLS = true;
		}
		
		public function get g():uint {
			if (invalidateRGB)
				validateRGB();
			
			return _g;
		}
		public function set g(value:uint):void {
			_g = value;
			invalidateHLS = true;
		}
		
		public function get b():uint {
			if (invalidateRGB)
				validateRGB();
			
			return _b;
		}
		public function set b(value:uint):void {
			_b = value;
			invalidateHLS = true;
		}
		
		public function get h():uint {
			if (invalidateHLS)
				validateHLS();
			
			return _h;
		}
		public function set h(value:uint):void {
			_h = value;
			invalidateRGB = true;
		}
		
		public function get l():uint {
			if (invalidateHLS)
				validateHLS();
			
			return _l;
		}
		public function set l(value:uint):void {
			_l = value;
			invalidateRGB = true;
		}
		
		public function get s():uint {
			if (invalidateHLS)
				validateHLS();
			
			return _s;
		}
		public function set s(value:uint):void {
			_s = value;
			invalidateRGB = true;
		}
		
		public function get rgb():Object {
			return {r:r, g:g, b:b};
		}
		public function set rgb(value:Object):void {
			r = value.r;
			g = value.g;
			b = value.b;
		}
		
		public function get hls():Object {
			return {h:h, l:l, s:s};
		}
		public function set hls(value:Object):void {
			h = value.h;
			l = value.l;
			s = value.s;
		}
		
		// :: Private Methods :: //
		
		private function validateHLS():void {
			var rDec:Number = _r / 255;
			var gDec:Number = _g / 255;
			var bDec:Number = _b / 255;
			
			var max:Number = Math.max( Math.max(rDec, gDec), bDec);
			var min:Number = Math.min( Math.min(rDec, gDec), bDec);
			var delta:Number = max-min;
			
			var hDec:Number = 0;
			var lDec:Number = (max + min) / 2;
			var sDec:Number = 0;
			
			if (delta != 0) {
				if (rDec == max)
					hDec = ((gDec - bDec) / delta) / 6;
				else if (gDec == max)
					hDec = (2 + (bDec - rDec) / delta) / 6;
				else if (bDec == max)
					hDec = (4 + (rDec - gDec) / delta) / 6;
				
				if (hDec < 0)
					hDec += 1;
				
				if (lDec < 0.5)
					sDec = delta / lDec / 2;
				else
					sDec = delta / (2 - lDec * 2);
			}
			
			_h = Math.round(hDec * 240);
			_l = Math.round(lDec * 240);
			_s = Math.round(sDec * 240);
			
			invalidateHLS = false;
		}
		
		private function validateRGB():void {
			var hDec:Number = _h / 240;
			var lDec:Number = _l / 240;
			var sDec:Number = _s / 240;
			
			var rgb:Array = [hDec + 1/3, hDec, hDec - 1/3];
			
			var a:Number = (lDec < 0.5) ? lDec * (sDec + 1) : lDec + sDec - lDec * sDec;
			var b:Number = lDec * 2 - a;
			
			for (var i:int = 0; i < rgb.length; i++) {
				if (rgb[i] < 0)
					rgb[i]++;
				else if (rgb[i] > 1)
					rgb[i]--;
				
				if (rgb[i] * 6 < 1)
					rgb[i] = b + (a - b) * rgb[i] * 6;
				else if (rgb[i] * 2 < 1)
					rgb[i] = a;
				else if (rgb[i] * 3 < 2)
					rgb[i] = b + (a - b) * (2/3 - rgb[i]) * 6;
				else
					rgb[i] = b;
				
				rgb[i] = Math.round(rgb[i] * 255);
			}
			
			_r = rgb[0];
			_g = rgb[1];
			_b = rgb[2];
			
			invalidateRGB = false;
		}
	}
}