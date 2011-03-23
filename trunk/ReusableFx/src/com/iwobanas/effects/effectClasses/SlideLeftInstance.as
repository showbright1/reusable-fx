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
	 *  The SlideLeftInstance class implements the instance class
	 *  for the SlideLeft effect.
	 *  Flex creates an instance of this class when it plays a SlideLeft effect;
	 *  you do not create one yourself.
	 */
	public class SlideLeftInstance extends SlideInstance
	{
		/**
		 *  Constructor. 
		 * 
		 *  @param target The Object to animate with this effect.
		 */
		public function SlideLeftInstance(target:Object)
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
        		rect.x += value[0] - visibleRect.width;
        	}
        	else
        	{
        		rect.x += value[0];
        	}

            target.scrollRect = rect;
        }
        
        override protected function initVisibleRect():void
        {
        	super.initVisibleRect();
        	if (showTarget)
        	{
        		visibleRect.right = target.width;
        	}
        	else
        	{
        		visibleRect.left = 0;
        	}
        }
        
	}
}