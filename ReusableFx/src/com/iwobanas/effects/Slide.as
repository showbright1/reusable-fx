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
package com.iwobanas.effects
{
	import com.iwobanas.effects.effectClasses.SlideInstance;
	
	import mx.effects.IEffectInstance;
	import mx.effects.TweenEffect;
	
	/**
	 * Slede class is a base class for slide effects in different directions.
	 * It contains most of slide effects logic, inheriting classes 
	 * overrides constructor only to change instance class. 
	 */
	public class Slide extends TweenEffect
	{
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 */
		public function Slide(target:Object=null)
		{
			super(target);
			
			instanceClass = SlideInstance;
		}
		
		private static var AFFECTED_PROPERTIES:Array = ["scrollRect", "x", "y"];
		
		/**
		 * @private
		 * This effect affects <code>scrollRect</code> property to animate slide 
		 * and <code>x,y</code> properties to initialize effect when drop shadow or other filter is enabled.
		 */
		override public function getAffectedProperties():Array
		{
			return AFFECTED_PROPERTIES;
		}
		
		protected var _showTarget:Boolean = true;
		protected var _showExplicitlySet:Boolean;
		
		/**
		 * Specifies that the target component is becoming visible, 
     	 * <code>true</code>, or invisible, <code>false</code>.
     	 * 
     	 * If used as <code>showEffect, addedEffect or creationCompleteEffect</code>  
		 * and <code>showTarget</code> is not set default value of <code>true</code>) 
		 * is applied.
		 * 
		 * If used as <code> hideEffect or removedEffect </code> 
		 * and <code>showTarget</code> is not set default value of <code>false</code>) 
		 * is applied.
     	 * 
     	 * @default true
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
	     * Initialize effect instance
	     */
		override protected function initInstance(instance:IEffectInstance):void
		{
			super.initInstance(instance);
			
			if (_showExplicitlySet)
			{
				SlideInstance(instance).showTarget = showTarget;
			}
		}
	}
}