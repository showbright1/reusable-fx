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
Portions created by the Initial Developer are Copyright (C) 
the Initial Developer. All Rights Reserved.

Contributor(s):
*/
package com.iwobanas.charts
{
	import mx.charts.DateTimeAxis;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.IAxis;
	import mx.charts.chartClasses.NumericAxis;
	
	/**
	 * The NumericAxisHelper class is an all-static class with methods for working with NumericAxis subclasses.
	 * Currently NumericAxisHelper supports setting/getting numeric minimum/maximum on LinearAxis and DateTimeAxis.
	 */
	public class NumericAxisHelper
	{
		/**
		 * Get minimum value for a given axis.
		 */
		public static function getMin(axis:IAxis):Number
		{
			if (axis is LinearAxis)
			{
				return LinearAxis(axis).minimum;
			}
			else if (axis is DateTimeAxis)
			{
				return DateTimeAxis(axis).minimum.time;
			}
			return NaN;
		}
		
		/**
		 * Get maxiumu value for a given axis.
		 */
		public static function getMax(axis:IAxis):Number
		{
			if (axis is LinearAxis)
			{
				return LinearAxis(axis).maximum;
			}
			else if (axis is DateTimeAxis)
			{
				return DateTimeAxis(axis).maximum.time;
			}
			return NaN;
		}
		
		/**
		 * Set minimum value for a given axis.
		 */
		public static function setMin(axis:IAxis, value:Number):void
		{
			if (axis is LinearAxis)
			{
				LinearAxis(axis).minimum = value;
			}
			else if (axis is DateTimeAxis)
			{
				DateTimeAxis(axis).minimum = new Date(value);
			}
		}
		
		/**
		 * Set maximum value for a given axis.
		 */
		public static function setMax(axis:IAxis, value:Number):void
		{
			if (axis is LinearAxis)
			{
				LinearAxis(axis).maximum = value;
			}
			else if (axis is DateTimeAxis)
			{
				DateTimeAxis(axis).maximum = new Date(value);
			}
		}
	}
}