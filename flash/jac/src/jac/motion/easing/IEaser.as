////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package jac.motion.easing
{
/**
 *  The IEaser interface is implemented by classes that provide time-easing
 *  functionality for the Animation class. 
 *  Implementors are responsible for the single
 *  function, <code>ease()</code>, which takes and returns a fraction according
 *  to the easing behavior desired. As a simple example, LinearEase simply 
 *  returns the same input fraction, since there is no easing performed by
 *  that easer. As another example, a reversing easer could be written which
 *  returned the inverse fraction, (1 - <code>fraction</code>).
 * 
 *  <p>By easing the fractional values of the time elapsed in an animation, 
 *  these classes are easing the resulting values of the animation, but they
 *  only have to deal with the fractional value of time instead of any
 *  specific object types.</p>
 * 
 *  @see spark.effects.animation.Animation
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IEaser
{
    /**
     *  Takes the fraction representing the elapsed duration of an animation
     *  (a value between 0.0 to 1.0) and returns a new elapsed value. 
     *  This  value is used to calculate animated property values. 
     *  By changing the value of the elapsed fraction, you effectively change
     *  the animation of the property.
     * 
     *  @param fraction The elapsed fraction of an animation, from 0.0 to 1.0.
     * 
     *  @return The eased value for the elapsed time. Typically, this value
     *  should be constrained to lie between 0.0 and 1.0, although it is possible
     *  to return values outside of this range. Note that the results of
     *  returning such values are undefined, and depend on what kind of 
     *  effects are using this eased value. For example, an object moving
     *  in a linear fashion can have positions calculated outside of its start 
     *  and end point without a problem, but other value types (such as color) 
     *  may not result in desired effects if they use time values that cause
     *  them to surpass their endpoint values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function ease(fraction:Number):Number;
}
}
