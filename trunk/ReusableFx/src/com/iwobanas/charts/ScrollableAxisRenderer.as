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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.charts.AxisRenderer;
	import mx.charts.DateTimeAxis;
	import mx.charts.LinearAxis;

	/**
	 * The ScrollableAxisRenderer class enables scrolling and zooming the chart (depreciated).
	 * 
	 * <p><strong>This class is depreciated! Use ChartScroller component instead.</strong></p>
	 * 
	 * <p>Scrolling is done by dragging the axis with mouse and moving.
	 * Zooming is done by moving mouse wheel over the axis.
	 * Both scrolling and zooming is done by setting <code>minimum</code> 
	 * and <code>maximum</code> properties of corresponding axis.</p> 
	 * 
	 * <p>ScrollableAxisRenderer is compatible with LinearAxis  and DateTimeAxis.</p>
	 * 
	 * @see com.iwobanas.charts.ChartScroller
	 */
	public class ScrollableAxisRenderer extends AxisRenderer
	{
		/**
		 * Constructor.
		 */
		public function ScrollableAxisRenderer()
		{
			super();
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		/**
		 * Relative speed of zooming with mouse wheel.
		 * 
		 * <p>Increasing <code>zoomSpeed</code> will lead to more dynamic zooming 
		 * i.e. the same move to mouse wheel will cause bigger change to the chart.
		 * Decreasing will give opposite effect.</p>
		 * 
		 * @default 1
		 */
		public var zoomSpeed:Number = 1;

		/**
		 * @private
		 * Mouse position recorded at dragging start or at last mouse move event.
		 * Value is stored in local coordinates.
		 */
		protected var previusMousePos:Point;
		
		/**
		 * @private
		 * Mouse down event handler.
		 * Starts dragging the axis.
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			previusMousePos = new Point(event.localX, event.localY);
			
			systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * @private
		 * Mouse move event handler.
		 * Updates axis minimum/maximum values basing on mouse movement.
		 * 
		 * NOTE: This event handler is added to <code>systemManager</code> 
		 * on mouse down and removed on mouse up or deactivate events.
		 */
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			var mousePos:Point = globalToLocal(new Point(event.stageX, event.stageY));
			
			var delta:Number;
			
			if (horizontal)
			{
				delta = getDataRange() * (previusMousePos.x - mousePos.x) / (width - gutters.left - gutters.right);
			}
			else
			{
				// Vertical axis renderer is rotated 90; that is why width and not height is used. 
				// -1 is needed because minimum is at the bottom.
				delta = -1 * getDataRange() * (previusMousePos.x - mousePos.x) / (width - gutters.top - gutters.bottom);
			}
			
			setMinimum(getMinimum() + delta);
			setMaximum(getMaximum() + delta);
			
			previusMousePos = mousePos;
		}
		
		/**
		 * @private
		 * Mouse up even handler.
		 * End dragging.
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			endDrag();
		}
		
		/**
		 * @private
		 * Deactivate event handler.
		 * If application looses focus dragging should be finished.
		 */
		protected function deactivateHandler(event:Event):void
		{
			endDrag();
		}
		
		/**
		 * @private
		 * Mouse wheel event handler.
		 * Update axis minimum/maximum to zoom in/out data.
		 */
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			var rel:Number = getRelativePos(new Point(event.localX, event.localY));
			var range:Number = getDataRange();
			var speed:Number = zoomSpeed / 100; // divide by 100 to keep the value of zoomSpeed in reasonable range
			
			var delta:Number = getDataRange() * event.delta * speed;
			if (delta > range / 2) // prevent from zooming in to fast
			{
				delta = range / 2;
			}
			
			setMinimum(getMinimum() + rel * delta);
			setMaximum(getMaximum() - (1 - rel) * delta);
			
			// stop event propagation to prevent page from being scrolled
			event.stopPropagation();
			
			// this should be delayed to reset cache when one is finished with zooming
			clearCachedMinMax();
		}
		
		/**
		 * Maps the given point in local coordinates to the position along the axis,
		 * with 0 representing the minimum bound of the axis, and 1 the maximum
		 * 
		 * If the point exceeds bounds of the axis returned value may be greater than 1 or less than 0.
		 * 
		 * @param localPos point to be mapped in local coordinates
		 * @return position along the axis
		 */
		protected function getRelativePos(localPos:Point):Number
		{
			if (horizontal)
			{
				return (localPos.x - gutters.left) / (width - gutters.left - gutters.right);
			}
			else
			{
				return (width - localPos.x - gutters.bottom) / (width - gutters.top - gutters.bottom);
			}
		}
		
		/**
		 * End axis dragging.
		 */
		protected function endDrag():void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			clearCachedMinMax();
		}
		
		/**
		 * @private
		 * Cached minimum value passed to the axis.
		 * 
		 * This is needed to allow smooth scrolling of DateTimeAxis which rounds minimum/maximum values.
		 * We need to know exact, not rounded values set during previous mouse move.
		 */
		protected var cachedMin:Number;
		
		/**
		 * @private
		 * Cached maximum value passed to the axis.
		 * 
		 * This is needed to allow smooth scrolling of DateTimeAxis which rounds minimum/maximum values.
		 * We need to know exact, not rounded values set during previous mouse move.
		 */
		protected var cachedMax:Number;
		
		/**
		 * @private
		 * Get axis minimum value or cached minimum value if present.
		 */
		protected function getMinimum():Number
		{
			if (!isNaN(cachedMin))
			{
				return cachedMin;
			}
			else if (axis is DateTimeAxis)
			{
				return DateTimeAxis(axis).minimum.time;
			}
			else if (axis is LinearAxis)
			{
				return LinearAxis(axis).minimum;
			}
			return NaN;
		}
		
		/**
		 * @private
		 * Set axis minimum value and cache it.
		 */
		protected function setMinimum(value:Number):void
		{
			cachedMin = value;
			if (axis is DateTimeAxis)
			{
				DateTimeAxis(axis).minimum = new Date(value);
			}
			else if (axis is LinearAxis)
			{
				LinearAxis(axis).minimum = value;
			}
		}
		
		/**
		 * @private
		 * Get axis maximum value or cached maximum value if present.
		 */
		protected function getMaximum():Number
		{
			if (!isNaN(cachedMax))
			{
				return cachedMax;
			}
			else if (axis is DateTimeAxis)
			{
				return DateTimeAxis(axis).maximum.time;
			}
			else if (axis is LinearAxis)
			{
				return LinearAxis(axis).maximum;
			}
			return NaN;
		}
		
		/**
		 * @private
		 * Set axis maximum value and cache it.
		 */
		protected function setMaximum(value:Number):void
		{
			cachedMax = value;
			if (axis is DateTimeAxis)
			{
				DateTimeAxis(axis).maximum = new Date(value);
			}
			else if (axis is LinearAxis)
			{
				LinearAxis(axis).maximum = value;
			}
		}
		
		/**
		 * @private
		 * Cler cached axis minimum and maximum values.
		 * Cached values shold be cleared while not scrolling/zooming.
		 */
		protected function clearCachedMinMax():void
		{
			cachedMin = NaN;
			cachedMax = NaN;
		}
		
		/**
		 * @private
		 * Get difference between axis minimum and maximum.
		 */
		protected function getDataRange():Number
		{
			return getMaximum() - getMinimum();
		}
		
	}
}
