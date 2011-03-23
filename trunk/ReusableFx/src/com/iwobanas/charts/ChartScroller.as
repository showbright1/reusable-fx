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
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.charts.chartClasses.CartesianChart;
	import mx.charts.chartClasses.IAxis;
	import mx.charts.chartClasses.IAxisRenderer;
	import mx.charts.chartClasses.Series;
	import mx.events.FlexEvent;

	/**
	 * Dispatched when the user scrolls or zooms the chart.
	 * 
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Dispatched specified time after user finished zooming or scrolling the chart.
	 * This event can be used to initiate retrieve data from server because 
	 * it is not dispatched as frequently as <code>change</code> event.
	 * 
	 * @eventType mx.events.FlexEvent.VALUE_COMMIT
	 */
	[Event(name="valueCommit", type="mx.events.FlexEvent")]
	
	/**
	 * The ChartScroller class adds scrolling and zooming functionality to CartesianChart.
	 * 
	 * <p>To scroll the chart user have to drag data series or axis renderer and move mouse.
	 * To zoom data (change scale) user should use mouse wheel over series or axis renderer.
	 * If <code>chartMouseEnabled</code> is set user can drag or use mouse wheel 
	 * over any part of the chart.</p>
	 * 
	 * <p>Both scrolling and zooming are done by modifying <code>minimum</code> 
	 * and <code>maximum</code> properties of chart axes. 
	 * Currently LinearAxis and DateTimeAxis are supported.</p>
	 * 
	 */
	public class ChartScroller extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function ChartScroller()
		{
			super();
			
			commitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, commitTimerCompleteHandler);
			
			addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		/**
		 * Chart which content should be scrolled/zoomed.
		 */
		public function get chart():CartesianChart
		{
			return _chart;
		}
		/**
		 * @private
		 */
		public function set chart(value:CartesianChart):void
		{
			if (_chart)
			{
				_chart.removeEventListener(MouseEvent.MOUSE_DOWN, chartMouseDownHandler);
				_chart.removeEventListener(MouseEvent.MOUSE_WHEEL, chartMouseWheelHandler);
			}
			_chart = value;
			if (_chart)
			{
				_chart.addEventListener(MouseEvent.MOUSE_DOWN, chartMouseDownHandler);
				_chart.addEventListener(MouseEvent.MOUSE_WHEEL, chartMouseWheelHandler);
			}
		}
		/**
		 * @private
		 * Storage variable for <code>chart<chart> property.
		 */
		private var _chart:CartesianChart;
		
		
		[Bindable]
		/**
		 * Specifies whether chart should be scrolled horizontally.
		 */
		public var horizontalScrollEnabled:Boolean = true;
		
		
		[Bindable]
		/**
		 * Specifies whether chart should be scrolled vertically.
		 */
		public var verticalScrollEnabled:Boolean = false;
		
		
		[Bindable]
		/**
		 * Specifies whether chart should be zoomed along horizontal axis when mouse wheel is supn.
		 */
		public var horizontalZoomEnabled:Boolean = true;
		
		
		[Bindable]
		/**
		 * Specifies whether chart should be zoomed along vertical axis when mouse wheel is supn.
		 */
		public var verticalZoomEnabled:Boolean = false;
		
		
		[Bindable]
		/**
		 * Speed of zooming the chart.
		 * 
		 * If <code>zoomSpeed</code> is negative zooming in/out occurs when spinning mouse wheel in different direction.
		 */
		public var zoomSpeed:Number = 1;
		
		
		[Bindable]
		/**
		 * If <code>true</code> whole area of the char can be dragged to scroll the chart along default axes 
		 * and spinning mouse wheel over any part of the char causes zooming along default axes.
		 * If <code>false</code> only data series and axes support scrolling/zooming.
		 */
		public var chartMouseEnabled:Boolean = true;
		
		[Bindable]
		[Inspectable(format="Time", type="Number", defaultValue="1000")]
		/**
		 * Time after which valueCommit event is dispatched when users stops scrolling/zooming the chart.
		 * If no scrolling/zooming occurs within <code>valueCommitDeley</code> 
		 * we assume that user finished his/her action and dispatch commitValue event.
		 */
		public function get valueCommitDeley():Number
		{
			return commitTimer.delay;
		}
		/**
		 * @private
		 */
		public function set valueCommitDeley(value:Number):void
		{
			commitTimer.delay = value;
		}
		
		/**
		 * Chart data series used to transform mouse position to data coordinates.
		 * This property is set by initialization methods when users start zooming/scrolling the chart.
		 * 
		 * Although zooming/scrolling affects all series using modified axis 
		 * one series is used for coordinates transformation.
		 */
		protected var series:Series;
		
		/**
		 * Currently zoomed/scrolled horizontal axis.
		 */
		protected var hAxis:IAxis;
		
		/**
		 * Currently zoomed/scrolled vertical axis.
		 */
		protected var vAxis:IAxis;
		
		/**
		 * Point in data coordinates at which scrolling (drag) is started.
		 */
		protected var dragStartDataPoint:Point;
		
		/**
		 * Indicate if user is dragging the chart.
		 */
		 protected var isDragging:Boolean = false;
		
		/**
		 * Timer responsible for deleying valueCommit event.
		 */
		protected var commitTimer:Timer = new Timer(1000, 1);
		
		
		/**
		 * Initialize zooming/scrolling based on mouse event.
		 * 
		 * This method assigns values to <code>series</code>, <code>hAxis</code> 
		 * and <code>vAxis</code> based on passed mouse event.
		 */
		protected function initializeForMouseEvent(event:MouseEvent):void
		{
			if (event.target is Series)
			{
				initializeForSeries(event.target as Series);
			}
			else if (event.target is IAxisRenderer)
			{
				initializeForAxisRenderer(event.target as IAxisRenderer);
			}
			else if (chartMouseEnabled)
			{
				initializeForChartAxes();
			}
			else
			{
				series = null;
				hAxis = null;
				vAxis = null;
			}
		}
		
		/**
		 * Initialize zooming/scrolling for a given series.
		 * 
		 * This method assigns values to <code>series</code>, <code>hAxis</code> 
		 * and <code>vAxis</code> based on passed series.
		 */
		protected function initializeForSeries(s:Series):void
		{
			hAxis = s.getAxis('h');
			vAxis = s.getAxis('v');
			series = s;
		}
		
		/**
		 * Initialize zooming/scrolling for a given axis renderer.
		 * 
		 * This method assigns values to <code>series</code>, <code>hAxis</code> 
		 * and <code>vAxis</code> based on passed axis renderer.
		 */
		protected function initializeForAxisRenderer(renderer:IAxisRenderer):void
		{
			if (renderer.horizontal)
			{
				vAxis = null;
				hAxis = renderer.axis;
			}
			else
			{
				vAxis = renderer.axis;
				hAxis = null;
			}
			series = getSeriesForAxes(hAxis, vAxis);
		}
		
		/**
		 * Initialize zooming/scrolling for a default axes of the chart.
		 * 
		 * This method assigns values to <code>series</code>, <code>hAxis</code> 
		 * and <code>vAxis</code> based on <code>horizontalAxis</code> 
		 * and <code>verticalAxis</code> chart properties.
		 */
		protected function initializeForChartAxes():void
		{
			hAxis = chart.horizontalAxis;
			vAxis = chart.verticalAxis;
			series = getSeriesForAxes(hAxis, vAxis);
		}
		
		/**
		 * Indicate if ChartScroller is initialized i.e. has series and at least one axis set.
		 */
		protected function get isInitialized():Boolean
		{
			return (series && (hAxis || vAxis));
		}
		
		/**
		 * Get chart data series which is using specified horizontal and vertical axis.
		 * If passed axis is <code>null</code> it is ignored i.e. returned series can use any axis for this direction.
		 * 
		 * @param hAxis horizontal axis
		 * @param vAxis vertical axis
		 * @return chart series using passed horizontal and vertical axes
		 */
		protected function getSeriesForAxes(hAxis:IAxis, vAxis:IAxis):Series
		{
			for each (var s:Object in chart.series)
			{
				if (s is Series )
				{
					if ((!hAxis || (hAxis == s.getAxis('h'))) && (!vAxis || (vAxis == s.getAxis('v'))))
					{
						return s as Series;
					}
				}
			}
			return null;
		}
		
		/**
		 * Convert point in global (stage) coordinates to data coordinates.
		 * @param point point in global (stage) coordinates
		 * @return point in data coordinates 
		 */
		protected function globalToData(point:Point):Point
		{
			var dataPoint:Point;
			var dataArray:Array;
			if (series && point)
			{
				dataArray = series.localToData(series.globalToLocal(point));
				dataPoint = new Point(dataArray[0], dataArray[1]);
			}
			return dataPoint;
		}
		
		/**
		 * Scroll chart content by specified horizontal and vertical distance.
		 * Scrolling is done by modifying axis minimum and maximum values.
		 * <p>Note that call to this function takes effect only if ChartScroller 
		 * is initialized (i.e. <code>series</code> and at least one of <code>hAxis</code> 
		 * and <code>vAxis</code> are set) and scrolling is enabled
		 * (horizontalScrollEnabled/verticalScrollEnabled properties are set).</p>
		 * 
		 * @param dx distance to scroll horizontally in data coordinates
		 * @param dy distance to scroll vertically in data coordinates
		 */
		protected function scrollChart(dx:Number, dy:Number):void
		{
			var changed:Boolean = false;
			
			if (hAxis && horizontalScrollEnabled)
			{
				NumericAxisHelper.setMin(hAxis, NumericAxisHelper.getMin(hAxis) + dx);
				NumericAxisHelper.setMax(hAxis, NumericAxisHelper.getMax(hAxis) + dx);
				changed = true;
			}
			if (vAxis && verticalScrollEnabled)
			{
				NumericAxisHelper.setMin(vAxis, NumericAxisHelper.getMin(vAxis) + dy);
				NumericAxisHelper.setMax(vAxis, NumericAxisHelper.getMax(vAxis) + dy);
				changed = true;
			}
			
			if (changed)
			{
				processChange();
			}
		}
		
		/**
		 * Zoom chart content relative to a given point in data coordinates.
		 * <p>Note that call to this function takes effect only if ChartScroller 
		 * is initialized (i.e. <code>series</code> and at least one of <code>hAxis</code> 
		 * and <code>vAxis</code> are set) and zooming is enabled
		 * (horizontalZoomEnabled/verticalZoomEnabled properties are set).</p>
		 * 
		 * @param ralativeTo point in data coordinates
		 * @param zoom indicate how much the content should be zoomed, 
		 * if this value is greater than 1 content is zoomed in otherways content is zoomed out.
		 */
		protected function zoomChart(ralativeTo:Point, zoom:Number):void
		{
			var dMin:Number; // distance from minimum to relativeTo point in given dimension
			var dMax:Number; // distance from maximum to relativeTo point in given dimension
			var changed:Boolean = false;
				
			if (hAxis && horizontalZoomEnabled)
			{
				dMin = ralativeTo.x - NumericAxisHelper.getMin(hAxis);
				dMax = NumericAxisHelper.getMax(hAxis) - ralativeTo.x;
				
				NumericAxisHelper.setMin(hAxis, ralativeTo.x - dMin/zoom);
				NumericAxisHelper.setMax(hAxis, ralativeTo.x + dMax/zoom);
				changed = true;
			}
			if (vAxis && verticalZoomEnabled)
			{
				dMin = ralativeTo.y - NumericAxisHelper.getMin(vAxis);
				dMax = NumericAxisHelper.getMax(vAxis) - ralativeTo.y;
				
				NumericAxisHelper.setMin(vAxis, ralativeTo.y - dMin/zoom);
				NumericAxisHelper.setMax(vAxis, ralativeTo.y + dMax/zoom);
				changed = true;
			}
			
			if (changed)
			{
				processChange();
			}
		}
		
		/**
		 * Dispatch change event and restart commitTimer.
		 * This function should be called after modifying axis minimum/maximum.
		 */
		protected function processChange():void
		{
			dispatchEvent(new Event(Event.CHANGE));
			commitTimer.reset();
			commitTimer.start();
		}
		
		/**
		 * End chart scrolling using mouse by romoving mouse event listeners.
		 */
		protected function endDrag():void
		{
			chart.systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			chart.systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			isDragging = false;
		}
		
		/**
		 * Mouse down on the chart event hadler. 
		 * Initialize scrolling using mouse.
		 */
		protected function chartMouseDownHandler(event:MouseEvent):void
		{
			initializeForMouseEvent(event);
			
			if (isInitialized)
			{
				dragStartDataPoint = globalToData(new Point(event.stageX, event.stageY));
				isDragging = true;
				
				chart.systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				chart.systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		/**
		 * Mouse move event handler.
		 * 
		 * Calculate distance in chart data coordinates between the current mouse position 
		 * and drag start position and scroll (move) chart by this distance.
		 * 
		 * This event listener is registered on mouse down and unregistered 
		 * on mouse up or deactivate.
		 */
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			var currDataPoint:Point = globalToData(new Point(event.stageX, event.stageY));
			var dx:Number = dragStartDataPoint.x - currDataPoint.x;
			var dy:Number = dragStartDataPoint.y - currDataPoint.y;
			
			scrollChart(dx, dy);
		}
		
		/**
		 * Mouse up event handler.
		 * Stop scrolling the chart.
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			endDrag();
		}
		
		/**
		 * Deactivate event handler.
		 * Stop scrolling the chart.
		 */
		protected function deactivateHandler(event:Event):void
		{
			endDrag();
		}
		
		/**
		 * Mouse wheel over chart event handler.
		 * Initialize ChartScroller if needed and zoom chart depending on event.delta
		 */
		protected function chartMouseWheelHandler(event:MouseEvent):void
		{
			if (!isDragging) // if user is dragging the chart it should be already initialized
			{
				initializeForMouseEvent(event);
			}
			
			if (isInitialized)
			{
				var relativeTo:Point = globalToData(new Point(event.stageX, event.stageY));
				var zoom:Number = 1 / (1 - (event.delta / 100 * zoomSpeed));
				zoom = Math.max(zoom, 0.5);
				zoom = Math.min(zoom, 2);
				zoomChart(relativeTo, zoom);
			}
		}
		
		/**
		 * Commit timer complete event handler.
		 * Dispatch <code>valueCommit</code> event.
		 */
		protected function commitTimerCompleteHandler(event:TimerEvent):void
		{
			dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
		
	}
}