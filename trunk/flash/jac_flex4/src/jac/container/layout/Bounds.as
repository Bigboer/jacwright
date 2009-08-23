package jac.container.layout
{
	import flash.geom.Rectangle;
	
	import mx.styles.IStyleClient;
	
	public class Bounds
	{
		
		public var top:Number;
		public var percentTop:Number;
		public var right:Number;
		public var percentRight:Number;
		public var bottom:Number;
		public var percentBottom:Number;
		public var left:Number;
		public var percentLeft:Number;
		
		
		public function Bounds(top:Number = NaN, right:Number = NaN, bottom:Number = NaN, left:Number = NaN)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		
		private function setTop(value:Object):Bounds
		{
			if (value is Number) {
				value = String(value);
			}
			if (!value) return this;
			
			if (value is String) {
				value = parseUnit(String(value));
			}
			if (value.isPercent) {
				top = NaN;
				percentTop = value.number;
			} else {
				top = value.number;
				percentTop = NaN;
			}
			return this;
		}
		
		public function getTop(height:Number):Number
		{
			return percentTop ? percentTop*height : top;
		}
		
		
		private function setRight(value:Object):Bounds
		{
			if (value is Number) {
				value = String(value);
			}
			if (!value) return this;
			
			if (value is String) {
				value = parseUnit(value as String);
			}
			if (value.isPercent) {
				right = NaN;
				percentRight = value.number;
			} else {
				right = value.number;
				percentRight = NaN;
			}
			return this;
		}
		
		public function getRight(width:Number):Number
		{
			return percentRight ? percentRight*width : right;
		}
		
		
		private function setBottom(value:Object):Bounds
		{
			if (value is Number) {
				value = String(value);
			}
			if (!value) return this;
			
			if (value is String) {
				value = parseUnit(value as String);
			}
			if (value.isPercent) {
				bottom = NaN;
				percentBottom = value.number;
			} else {
				bottom = value.number;
				percentBottom = NaN;
			}
			return this;
		}
		
		public function getBottom(height:Number):Number
		{
			return percentBottom ? percentBottom*height : bottom;
		}
		
		
		private function setLeft(value:Object):Bounds
		{
			if (value is Number) {
				value = String(value);
			}
			if (!value) return this;
			
			if (value is String) {
				value = parseUnit(value as String);
			}
			if (value.isPercent) {
				left = NaN;
				percentLeft = value.number;
			} else {
				left = value.number;
				percentLeft = NaN;
			}
			return this;
		}
		
		public function getLeft(width:Number):Number
		{
			return percentLeft ? percentLeft*width : left;
		}
		
		
		public function toRect(parentWidth:Number, parentHeight:Number):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			rect.top = getTop(parentHeight);
			rect.right = getRight(parentWidth);
			rect.bottom = getBottom(parentHeight);
			rect.left = getLeft(parentWidth);
			return rect;
		}
		
		
		public function clone():Bounds
		{
			var b:Bounds = new Bounds(top, right, bottom, left);
			b.percentTop = percentTop;
			b.percentRight = percentRight;
			b.percentBottom = percentBottom;
			b.percentLeft = percentLeft;
			return b;
		}
		
		
		public static function fromStyleClient(client:IStyleClient, styleShortcut:String, stylePrefix:String = null, zeroOut:Boolean = false):Bounds
		{
			var shortValue:String = client.getStyle(styleShortcut);
			var bounds:Bounds = fromString(shortValue, zeroOut);
			
			// hack since styles formated as Lengths default to 0 instead of NaN, would be nice to override the shortvalue.
			if (shortValue) {
				return bounds;
			}
			
			var top:String = stylePrefix ? stylePrefix + "Top" : "top";
			var right:String = stylePrefix ? stylePrefix + "Right" : "right";
			var bottom:String = stylePrefix ? stylePrefix + "Bottom" : "bottom";
			var left:String = stylePrefix ? stylePrefix + "Left" : "left";
			
			// allow specific overriding
			bounds.setTop(client.getStyle(top));
			bounds.setRight(client.getStyle(right));
			bounds.setBottom(client.getStyle(bottom));
			bounds.setLeft(client.getStyle(left));
			
			return bounds;
		}
		
		
		public static function fromString(value:String, zeroOut:Boolean = false):Bounds
		{
			var bounds:Bounds = zeroOut ? new Bounds(0, 0, 0, 0) : new Bounds();
			
			if (!value) return bounds;
			
			var numbers:Array = value.split(/\s+/);
			var n:int = numbers.length;
			for (var i:int = 0; i < n; i++) {
				var unit:Object = parseUnit(numbers[i]);
				numbers[i] = unit;
			}
			
			if (n == 1) {
				bounds.setTop(numbers[0]).setRight(numbers[0]).setBottom(numbers[0]).setLeft(numbers[0]);
			} else if (n == 2) {
				bounds.setTop(numbers[0]).setRight(numbers[1]).setBottom(numbers[0]).setLeft(numbers[1]);
			} else if (n == 3) {
				bounds.setTop(numbers[0]).setRight(numbers[1]).setBottom(numbers[2]).setLeft(numbers[1]);
			} else if (n == 4) {
				bounds.setTop(numbers[0]).setRight(numbers[1]).setBottom(numbers[2]).setLeft(numbers[3]);
			}
			
			return bounds;
		}
		
		
		public static function parseUnit(value:String):Object
		{
			var num:Number = parseFloat(value);
			if (isNaN(num)) return NaN;
			var isPercent:Boolean = value.charAt(value.length - 1) == "%";
			if (isPercent) num *= .01;
			return {number: num, isPercent: isPercent};
		}
		
		public static function getPixels(unit:Object, percentValue:Number):Number
		{
			if (!unit) return NaN;
			return unit.isPercent ? unit.number * percentValue : unit.number;
		}
		
		public function toString():String
		{
			return "[Bounds(top: " + top + ", right: " + right + ", bottom: " + bottom + ", left: " + left + "]";
		}
	}
}