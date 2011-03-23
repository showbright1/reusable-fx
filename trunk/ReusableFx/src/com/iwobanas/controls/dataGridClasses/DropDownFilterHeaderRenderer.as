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
package com.iwobanas.controls.dataGridClasses
{
	import com.iwobanas.controls.dataGridClasses.filterEditors.DropDownFilterEditor;
	import com.iwobanas.controls.dataGridClasses.filterEditors.IColumnFilterEditor;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ScrollPolicy;

	/**
	 * The name of a CSS style declaration for controlling 
	 * the appearance of the filter button when filter is not active.
	 */
	[Style(name="filterButtonStyleName", type="String", inherit="no")]
	
	/**
	 * The name of a CSS style declaration for controlling 
	 * the appearance of the filter button when filter is active.
	 */
	[Style(name="filterButtonActiveStyleName", type="String", inherit="no")]
	
	/**
	 * The DropDownFilterHeaderRenderer class defines the header renderer for MDataGridColumn.
	 * 
	 * The DropDownFilterHeaderRenderer consists of the label displaying header text 
	 * and the button opening filter editor as a dropdown just below this renderer.
	 */
	public class DropDownFilterHeaderRenderer extends HBox implements IListItemRenderer
	{
		/**
		 * Constructor.
		 */
		public function DropDownFilterHeaderRenderer()
		{
			super();

			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			percentHeight = 100;
		}
		
		/**
		 * Label component displaying header text.
		 */
		public var headerLabel:Label;
		
		/**
		 * Button opening the filter editor.
		 * 
		 * The <code>styleName</code> of this button is changed when filter becomes active/inactive.
		 */
		public var filterButton:Button;
		
		/**
		 * MDataGrid column related to this header renderer.
		 */
		public var column:MDataGridColumn;
		
		/**
		 * @private
		 * Create instance of filter editor and display it as a popup (dropdown)
		 * just below this header renderer.
		 */
		protected function showFilterDropDown():void
		{
			if (column && column.filterEditor)
			{
				var editor:IColumnFilterEditor = column.filterEditor.newInstance() as IColumnFilterEditor;
				var dropDown:DropDownFilterEditor = new DropDownFilterEditor(editor);
				
				var bottomLeftPos:Point = localToGlobal(new Point(0,height)); // bottom left corner of this renderer
				var headerUpperLeftPos:Point = parent.localToGlobal(new Point(0,0));
				var headerUpperRightPos:Point = parent.localToGlobal(new Point(parent.width,0));
				
				dropDown.x = bottomLeftPos.x;
				dropDown.y = bottomLeftPos.y + 2; //TODO: remove harcoded value (probably it can be read from some style)
				
				dropDown.startEdit(column);
				
				if (dropDown.x + dropDown.width > headerUpperRightPos.x) // now width of editor is known so its position can be adjusted
				{
					dropDown.x = Math.max(headerUpperLeftPos.x, headerUpperRightPos.x - dropDown.width);
				}
			}
		}
		
		/**
		 * @private
		 * Override data setter to update column value.
		 */
		[Bindable("dataChange")]
		override public function set data(value:Object):void
		{
			column = value as MDataGridColumn;
			super.data = value;
			invalidateProperties();	
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!headerLabel)
			{
				createHeaderLabel();
				addChild(headerLabel);
			}
			
			if (!filterButton)
			{
				createFilterButton();
				addChild(filterButton);
			}
		}
		
		/**
		 * @private
		 * Update headerLabel and filterButton properties.
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (column)
			{
				headerLabel.text = column.headerText;

				if (column.filter && column.filter.isActive)
				{
					filterButton.toolTip = "Data are filtered";
					filterButton.styleName = getStyle('filterButtonActiveStyleName');
				}
				else
				{
					filterButton.toolTip = "Filter data";
					filterButton.styleName = getStyle('filterButtonStyleName');
				}
			}
		}
		
		/**
		 * @private
		 * Create headerLabel component.
		 * This function may be overridden to assign different property values to headerLabel component.
		 */
		protected function createHeaderLabel():void
		{
			headerLabel = new Label();
			headerLabel.minWidth = 0;
			headerLabel.percentWidth = 100;
		}
		
		/**
		 * @private
		 * Create filterButton component.
		 * This function may be overridden to assign different property values to filterButton component.
		 */
		protected function createFilterButton():void
		{
			filterButton = new LinkButton();
			filterButton.addEventListener(MouseEvent.CLICK, filterButtonClickHandler);
			
			filterButton.addEventListener(MouseEvent.MOUSE_OVER, stopPropagationHandler);
			filterButton.addEventListener(MouseEvent.MOUSE_DOWN, stopPropagationHandler);
		}
		
		/**
		 * @private
		 * Event handler stopping event propagation.
		 * It is used to prevent DataGridHeadre from catching mouse events 
		 * when they are already handled by filterButton.
		 */
		protected function stopPropagationHandler(event:Event):void
		{
			event.stopPropagation();
		}
		
		/**
		 * @private
		 * Filter button mouse click event handler.
		 * Open filter editor it is not already open, close it otherwise.
		 */
		protected function filterButtonClickHandler(event:MouseEvent):void
		{
			if (column)
			{
				if (column.filterEditorInstance)
				{
					column.filterEditorInstance.endEdit();
				}
				else
				{
					showFilterDropDown();
				}
			}
		}
	}
}