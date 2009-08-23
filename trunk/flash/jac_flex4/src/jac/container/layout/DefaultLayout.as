package jac.container.layout
{
	import flash.geom.Rectangle;
	
	import mx.styles.IStyleClient;
	
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.Skin;
	import spark.layouts.BasicLayout;

	public class DefaultLayout extends BasicLayout
	{
		
		public override function measure():void
		{
			super.measure();
			
//			if (target.numChildren == 0) {
//				target.measuredWidth = target.measuredHeight = 10;
//			}
		}
		
		
		
		public override function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			
			var target:GroupBase = super.target;
			var styleTarget:IStyleClient = target;
			
			// if this is in a skin, use the styles from the owner
			if (target.owner is Skin) {
				styleTarget = target.owner as Skin;
			}
			
			var n:int = target.numChildren;
			if (n == 0) return;
			
			// This will keep track of the current space available for aligning and tiling items
			var alignArea:Rectangle = new Rectangle(0, 0, width, height);
			var alignMargin:Rectangle = new Rectangle();
			var tileArea:Rectangle;
			var tileMargin:Rectangle;
			
			var pad:Pad = Pad.fromStyleClient(styleTarget, width, height);
			var padding:Bounds = Bounds.fromStyleClient(styleTarget, "padding", "padding", true);
			
			// discount the chrome and padding for the staring aligning area
			alignArea.top += padding.getTop(height);
			alignArea.right -= padding.getRight(width);
			alignArea.bottom -= padding.getBottom(height);
			alignArea.left += padding.getLeft(width);
			
			var child:ChildInfo;
			
			// keep track of the last align direction
			var childDock:String;
			
			for (var i:int = 0; i < n; i++) {
				child = new ChildInfo(target.getChildAt(i), width, height);
				
				// skip if the child is not included in layout
				if (!child.component || !child.styleClient || !child.component.includeInLayout) {
					continue;
				}
				
				// the order to handle settings is 1. tiling, 2. aligning. 3. anchoring 4. anything else
				
				///// TILE //////
				if (child.tile) {
					
					if (childDock != child.align || tileArea == null || child.clear) {
						
						tileArea = alignArea.clone();
						tileMargin = alignMargin.clone();
						
					} else {
						// if the tileArea is too small for the tile, clone it again?? TODO check if this is right
						if (child.tile == "right" || child.tile == "left") {
							if (tileArea.width < child.width + child.margin.left + child.margin.right) {
								tileArea = alignArea.clone();
								tileMargin = alignMargin.clone();
							}
						} else if (tileArea.height < child.height + child.margin.top + child.margin.bottom) {
							tileArea = alignArea.clone();
							tileMargin = alignMargin.clone();
						}
						
					}
					
					applyAlignment(child, child.tile, tileArea, getCurrentMargin(child.margin, tileMargin, pad), pad);
					updateAlignment(child, child.tile, tileArea, getCurrentMargin(child.margin, tileMargin, pad), pad);
					updateAlignment(child, child.align, alignArea, getCurrentMargin(child.margin, alignMargin, pad), pad);
					
					
				///// ALIGN //////
				} else if (child.align) {
					tileArea = null;
					applyAlignment(child, child.align, alignArea, getCurrentMargin(child.margin, alignMargin, pad), pad);
					updateAlignment(child, child.align, alignArea, alignMargin, pad);
				} else {
					applyAnchor(child, width, height);
				}
				
				childDock = child.align;
			}
			
		}
		
		
		/**
		 * Place the child in its correct position and set its width/height as needed.
		 */
		private function applyAlignment(child:ChildInfo, align:String, area:Rectangle, currentMargin:Rectangle, pad:Pad):void
		{
			var w:Number = child.width;
			var h:Number = child.height;
			
			switch(align)
			{
				case "left" :
					child.component.x = area.x + currentMargin.left;
					child.component.y = area.y + currentMargin.top;
					if(child.tile == null)
						h = area.height - currentMargin.top - currentMargin.bottom;
					else if(child.align == "bottom")
						child.component.y = area.y + area.height - child.height - currentMargin.bottom;
					break;
				case "top" :
					child.component.x = area.x + currentMargin.left;
					child.component.y = area.y + currentMargin.top;
					if(child.tile == null)
						w = area.width - currentMargin.left - currentMargin.right;
					else if(child.align == "right")
						child.component.x = area.x + area.width - child.width - currentMargin.right;
					break;
				case "right" :
					child.component.x = area.x + area.width - child.width - currentMargin.right;
					child.component.y = area.y + currentMargin.top;
					if(child.tile == null)
						h = area.height - currentMargin.top - currentMargin.bottom;
					else if(child.align == "bottom")
						child.component.y = area.y + area.height - child.height - currentMargin.bottom;
					break;
				case "bottom" :
					child.component.x = area.x + currentMargin.left;
					child.component.y = area.y + area.height - child.height - currentMargin.bottom;
					if(child.tile == null)
						w = area.width - currentMargin.left - currentMargin.right;
					else if(child.align == "right")
						child.component.x = area.x + area.width - child.width - currentMargin.right;
					break;
				case "fill" : // tile cannot be fill, only align, ChildInfo validates tile.
					child.component.x = area.x + currentMargin.left;
					child.component.y = area.y + currentMargin.top;
					w = area.width - currentMargin.left - currentMargin.right;
					h = area.height - currentMargin.top - currentMargin.bottom;
					break;
			}
			child.component.setActualSize(w, h);
		}
		
		
		
		/**
		 * Update the area and margin so that following children can space accordingly.
		 */
		private function updateAlignment(child:ChildInfo, align:String, area:Rectangle, lastMargin:Rectangle, pad:Pad):void
		{
			var pos:Number;
			switch(align)
			{
				case "left" :
					if(area.left < (pos = child.component.x + child.width + pad.horizontal) )
					{
						area.left = pos;
						lastMargin.left = child.margin.right;
					}
					break;
				case "top" :
					if(area.top < (pos = child.component.y + child.height + pad.vertical) )
					{
						area.top = pos;
						lastMargin.top = child.margin.bottom;
					}
					break;
				case "right" :
					if(area.right > (pos = child.component.x - pad.horizontal) )
					{
						area.right = pos;
						lastMargin.right = child.margin.left;
					}
					break;
				case "bottom" :
					if(area.bottom > (pos = child.component.y - pad.vertical) )
					{
						area.bottom = pos;
						lastMargin.bottom = child.margin.top;
					}
					break;
			}
		}
		
		
		
		private function applyAnchor(child:ChildInfo, parentWidth:Number, parentHeight:Number):void
		{
			var w:Number = child.width;
			var h:Number = child.height;
			var anchor:Rectangle = child.anchor;
			
			if( !isNaN(anchor.left) ) {
				
				if( !isNaN(anchor.right) ) {
					w = parentWidth - anchor.left - anchor.right;
				}
				child.component.x = anchor.left;
				
			} else if( !isNaN(anchor.right) ) {
				child.component.x = parentWidth - anchor.right - child.width;
			} else if ( !isNaN(child.horizontalCenter)) {
				child.component.x = (parentWidth - child.width)/2 + child.horizontalCenter;
			}
			
			if( !isNaN(anchor.top) ) {
				
				if( !isNaN(anchor.bottom) ) {
					h = parentHeight - anchor.top - anchor.bottom;
				}
				
				child.component.y = anchor.top;
			} else if( !isNaN(anchor.bottom) ) {
				child.component.y = parentHeight - anchor.bottom - child.height;
			} else if ( !isNaN(child.verticalCenter)) {
				child.component.y = (parentHeight - child.height)/2 + child.verticalCenter;
			}
			
			child.component.setActualSize(w, h);
		}
		
		
		
		
		private function getCurrentMargin(childMargin:Rectangle, lastMargin:Rectangle, pad:Pad):Rectangle
		{
			pad = new Pad();// testing for now
			var currentMargin:Rectangle = lastMargin.clone();
			currentMargin.left = Math.max(childMargin.left, currentMargin.left, pad.horizontal);
			currentMargin.top = Math.max(childMargin.top, currentMargin.top, pad.vertical);
			currentMargin.right = Math.max(childMargin.right, currentMargin.right, pad.horizontal);
			currentMargin.bottom = Math.max(childMargin.bottom, currentMargin.bottom, pad.vertical);
			return currentMargin;
		}
		
		
		
	}
}