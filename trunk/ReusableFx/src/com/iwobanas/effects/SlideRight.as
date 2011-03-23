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
	import com.iwobanas.effects.effectClasses.SlideRightInstance;
	
	/**
	 * The SlideRight class defines slide right effect.
	 * Depending on <code>showTarget</code> property value 
	 * the target component disappears (when <code>false</code>) 
	 * or appears (when <code>true</code>) by sliding from right to left.
	 */
	public class SlideRight extends Slide
	{
		/**
		 *  Constructor.
		 *
		 *  @param target The Object to animate with this effect.
		 */
		public function SlideRight(target:Object=null)
		{
			super(target);
			
			instanceClass = SlideRightInstance;
		}
	}
}