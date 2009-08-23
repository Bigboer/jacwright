////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{

import flash.display.Sprite;
import mx.utils.NameUtil;


[Style(name="align", type="String", inherit="no", enumeration="top,right,bottom,left,fill,none")]
[Style(name="tile", type="String", inherit="no", enumeration="top,right,bottom,left,none")]
[Style(name="clearTile", type="Boolean", inherit="no")]

[Style(name="anchor", type="String", inherit="no")]
[Style(name="left", type="String", inherit="no")]
[Style(name="right", type="String", inherit="no")]
[Style(name="top", type="String", inherit="no")]
[Style(name="bottom", type="String", inherit="no")]

[Style(name="margin", type="String", inherit="no")]
[Style(name="marginLeft", type="String", inherit="no")]
[Style(name="marginRight", type="String", inherit="no")]
[Style(name="marginTop", type="String", inherit="no")]
[Style(name="marginBottom", type="String", inherit="no")]

[Style(name="padding", type="String", inherit="no")]
[Style(name="paddingLeft", type="String", inherit="no")]
[Style(name="paddingRight", type="String", inherit="no")]
[Style(name="paddingTop", type="String", inherit="no")]
[Style(name="paddingBottom", type="String", inherit="no")]

[Style(name="horizontalGap", type="String", inherit="no")]
[Style(name="verticalGap", type="String", inherit="no")]

[Style(name="width", type="String", inherit="no")]
[Style(name="height", type="String", inherit="no")]

/**
 *  FlexSprite is a subclass of the Player's Sprite class
 *  and the superclass of UIComponent.
 *  It overrides the <code>toString()</code> method
 *  to return a string indicating the location of the object
 *  within the hierarchy of DisplayObjects in the application.
 */
public class FlexSprite extends Sprite
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
     *  Constructor.
	 *
	 *  <p>Sets the <code>name</code> property to a string
	 *  returned by the <code>createUniqueName()</code>
	 *  method of the mx.utils.NameUtils class.</p>
	 *
	 *  <p>This string is the name of the object's class concatenated
	 *  with an integer that is unique within the application,
	 *  such as <code>"Button17"</code>.</p>
	 *
	 *  @see flash.display.DisplayObject#name
	 *  @see mx.utils.NameUtil#createUniqueName()
     */
    public function FlexSprite()
	{
		super();

		try
		{
			name = NameUtil.createUniqueName(this);
		}
		catch(e:Error)
		{
			// The name assignment above can cause the RTE
			//   Error #2078: The name property of a Timeline-placed
			//   object cannot be modified.
			// if this class has been associated with an asset
			// that was created in the Flash authoring tool.
			// The only known case where this is a problem is when
			// an asset has another asset PlaceObject'd onto it and
			// both are embedded separately into a Flex application.
			// In this case, we ignore the error and toString() will
			// use the name assigned in the Flash authoring tool.
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

    /**
	 *  Returns a string indicating the location of this object
	 *  within the hierarchy of DisplayObjects in the Application.
	 *  This string, such as <code>"MyApp0.HBox5.Button17"</code>,
	 *  is built by the <code>displayObjectToString()</code> method
	 *  of the mx.utils.NameUtils class from the <code>name</code>
	 *  property of the object and its ancestors.
	 *  
	 *  @return A String indicating the location of this object
	 *  within the DisplayObject hierarchy. 
	 *
	 *  @see flash.display.DisplayObject#name
	 *  @see mx.utils.NameUtil#displayObjectToString()
     */
    override public function toString():String
	{
		return NameUtil.displayObjectToString(this);
	}
}

}
