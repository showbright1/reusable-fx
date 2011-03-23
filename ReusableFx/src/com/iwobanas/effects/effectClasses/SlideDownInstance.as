/*
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
License for the specific language governing rights and limitations
under the License.

The Original Code is: www.iwobanas.com code samples.

The Initial Developer of the Original Code is Iwo Banas.
Portions created by the Initial Developer are Copyright (C) 2009
the Initial Developer. All Rights Reserved.

Contributor(s):
*/
package com.iwobanas.effects.effectClasses
{
	import flash.geom.Rectangle;

	/**
	 *  The SlideDownInstance class implements the instance class
	 *  for the SlideDown effect.
	 *  Flex creates an instance of this class when it plays a SlideDown effect;
	 *  you do not create one yourself.
	 */
	public class SlideDownInstance extends SlideInstance
	{
		/**
		 *  Constructor. 
		 * 
		 *  @param target The Object to animate with this effect.
		 */
		public function SlideDownInstance(target:Object)
		{
			super(target);
		}
		
		/**
		 * @private
		 * Update target component <code>scrollRect</code> depending on current tween values.
		 * value[0] is the current x value (tweened from 0 to visibleRect.width)
		 * value[1] is the current y value (tweened from 0 to visibleRect.height)
		 */
        override public function onTweenUpdate(value:Object):void {
        	super.onTweenUpdate(value);
        	
        	var rect:Rectangle = visibleRect.clone();
        	if (showTarget)
        	{
        		rect.y += visibleRect.height - value[1];
        	}
        	else
        	{
        		rect.y -= value[1];
        	}
        	
            target.scrollRect = rect;
        }
        
        override protected function initVisibleRect():void
        {
        	super.initVisibleRect();
        	if (showTarget)
        	{
        		visibleRect.top = 0;
        	}
        	else
        	{
        		visibleRect.bottom = target.height;
        	}
        }
        
	}
}