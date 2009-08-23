package jac.container.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	import mx.styles.IStyleClient;

	public class ChildInfo
	{
		public static var aligns:Array = ["top", "right", "bottom", "left", "fill"];
		public var component:IUIComponent;
		public var styleClient:IStyleClient;
		public var width:Number;
		public var height:Number;
		public var tile:String;
		public var clear:Boolean;
		public var align:String;
		public var margin:Rectangle;
		public var anchor:Rectangle;
		public var horizontalCenter:Number;
		public var verticalCenter:Number;
		
		public function ChildInfo(child:DisplayObject, parentWidth:Number, parentHeight:Number)
		{
			component = child as IUIComponent;
			styleClient = child as IStyleClient;
			if (component) {
				width = getWidth(parentWidth);
				height = getHeight(parentHeight);
			}
			if (styleClient) {
				anchor = Bounds.fromStyleClient(styleClient, "anchor").toRect(parentWidth, parentHeight);
				horizontalCenter = Bounds.getPixels(Bounds.parseUnit(styleClient.getStyle("horizontalCenter")), width);
				verticalCenter = Bounds.getPixels(Bounds.parseUnit(styleClient.getStyle("verticalCenter")), height);
				
				margin = Bounds.fromStyleClient(styleClient, "margin", "margin", true).toRect(parentWidth, parentHeight);
				align = styleClient.getStyle("align");
				clear = styleClient.getStyle("clearTile") || false;
				if (aligns.indexOf(align) == -1) align = null;
				tile = styleClient.getStyle("tile");
				if (aligns.indexOf(tile) == -1 || tile == "fill") tile = null;
				
				// there is an implicit align of top or left with tile if no align is set
				if (tile && !align) {
					align = (tile == "right" || tile == "left") ? "top" : "left";
				}
			}
		}
		
		
		
		/**
		 * Get the width of a child. This will give us the explicit width if set,
		 * the percentWidth after that if set, then the width (percent or pixel)
		 * from the stylesheet if set, and finally the measured width.
		 * 
		 * @param The child which needs a width found.
		 * @param The parent width which any percent will be based off of.
		 * @return The width in pixels this child should be.
		 */
		private function getWidth(parentWidth:Number):Number
		{
			if (component.explicitWidth) return component.explicitWidth;
			
			if (component.percentWidth) return component.percentWidth*.01 * parentWidth;
			
			if (styleClient) {
				var unit:Object = Bounds.parseUnit(styleClient.getStyle("width"));
				if (unit) {
					return Bounds.getPixels(unit, parentWidth);
				}
			}
			return component.measuredWidth;
		}
		
		/**
		 * Get the height of a child. This will give us the explicit height if set,
		 * the percentHeight after that if set, then the height (percent or pixel)
		 * from the stylesheet if set, and finally the measured height.
		 * 
		 * @param The child which needs a height found.
		 * @param The parent height which any percent will be based off of.
		 * @return The height in pixels this child should be.
		 */
		private function getHeight(parentHeight:Number):Number
		{
			if (component.explicitHeight) return component.explicitHeight;
			
			if (component.percentHeight) return component.percentHeight*.01 * parentHeight;
			
			if (styleClient) {
				var unit:Object = Bounds.parseUnit(styleClient.getStyle("height"));
				if (unit) {
					return Bounds.getPixels(unit, parentHeight);
				}
			}
			return component.measuredHeight;
		}
		
		
	}
}