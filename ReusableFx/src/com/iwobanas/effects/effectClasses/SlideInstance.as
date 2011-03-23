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
	import com.iwobanas.utils.ComponentUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.mx_internal;
	import mx.effects.effectClasses.TweenEffectInstance;
	import mx.events.FlexEvent;

	/**
	 * The SlideInstance is a base class for all slide effects instance classes.
	 * This class contains most of logic related to slide effect initialization 
	 * and finalization. 
	 * Inheriting classes overrides <code>initVisibleRect</code> function to set the visible component bounds
	 * and <code>onTweenUpdate</code> function to animate slide in a given direction.
	 */
	public class SlideInstance extends TweenEffectInstance
	{
		/**
		 *  Constructor. 
		 * 
		 *  @param target The Object to animate with this effect.
		 */
		public function SlideInstance(target:Object)
		{
			super(target);
		}
		
		protected var _showTarget:Boolean = true;
		protected var _showExplicitlySet:Boolean;
		
		/**
		 * Specifies that the target component is becoming visible, 
     	 * <code>true</code>, or invisible, <code>false</code>.
     	 * 
     	 * If this value is not set default value is used depending 
     	 * on triggering event type (see SlideDown effect documentation).
		 */
		public function get showTarget():Boolean
		{
			return _showTarget;
		}
		
		/**
		 * @private
		 */
		public function set showTarget(value:Boolean):void
		{
			_showTarget = value;
			_showExplicitlySet = true;
		}
		
		/**
		 * @private
		 * Backup of the <code>scrollRect</code> property saved before effect starts.
		 */
		protected var scrollRect:Rectangle;
		
		/**
		 * @private
		 * Rectangle describing visible bounds of the target component.
		 * 
		 * This value should not be modified directly instead override 
		 * initVisibleRect function.
		 */
		protected var visibleRect:Rectangle;

		/**
		 * @private
		 * Initialize visibleRect property.
		 * By default visibleRect it is set to visible bounds of the target component 
		 * including any dropshadows or filters.
		 * Override this function to change this behavior.
		 */		
		protected function initVisibleRect():void
		{
			visibleRect = ComponentUtils.getVisibleBounds(target as DisplayObject);
		}
		
		/**
		 * @private
		 * Initialize effect <code>showTarget</code> property 
		 * depending on the type of the event triggering this effect.
		 */
		override public function initEffect(event:Event):void
		{
			super.initEffect(event);

			// if showTarget is not explicitly set assign default value dependent on event type
			if (!_showExplicitlySet)
			{
				switch (event.type)
				{	
					case FlexEvent.CREATION_COMPLETE:
					case FlexEvent.SHOW:
					case Event.ADDED:
					{
						showTarget = true;
						break;
					}
				
					case FlexEvent.HIDE:
					case Event.REMOVED:
					{
						showTarget = false;
						break;
					}
				}
			}
		}

		/**
		 * @private
		 * Start playing the effect.
		 */
        override public function play():void {
            super.play();
            
            initVisibleRect();
            
            // backup scrollRect value
            scrollRect = target.scrollRect;
            
            // move component so that 0,0 point of the component is the upperleft corner of visibleRect
            // then when we set scrollRect to visibleRect component is back in its original position
            target.x += visibleRect.x;
            target.y += visibleRect.y
            
            // We are tweenning two values: one from 0 to visibleRect.width, 
            // the other from 0 to visibleRect.height
            tween = createTween(this, [0, 0], [visibleRect.width, visibleRect.height], duration);
            
            // Call to this function is needed to prevent filckering at effect start
            // I have no idea why this function is mx_internal
            mx_internal::applyTweenStartValues();
        }

  		/**
		 * @private
		 * Called on effect end.
		 * Restore <code>scrollRect</code> oryginal value.
		 */
        override public function onTweenEnd(val:Object):void {
            super.onTweenEnd(val);
            
            // restore components coordinates
            target.x -= visibleRect.x;
            target.y -= visibleRect.y
            
            // restore scrollRect oryginal value
            target.scrollRect = scrollRect;
        }
	}
}