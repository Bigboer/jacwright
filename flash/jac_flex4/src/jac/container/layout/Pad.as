package jac.container.layout
{
	import mx.styles.IStyleClient;
	
	public class Pad
	{
		public var horizontal:Number;
		public var vertical:Number;
		
		public function Pad(horizontal:Number = 0, vertical:Number = 0)
		{
			this.horizontal = horizontal;
			this.vertical = vertical;
		}
		
		
		public static function fromStyleClient(client:IStyleClient, width:Number, height:Number):Pad
		{
			var h:Number = Bounds.getPixels(Bounds.parseUnit(client.getStyle("horizontalGap")), width);
			var v:Number = Bounds.getPixels(Bounds.parseUnit(client.getStyle("verticalGap")), height);
			
			return new Pad(h, v);
		}
	}
}