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
	import com.iwobanas.core.ISearchable;
	
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	
	/**
	 *  The BoldSearchItemRenderer class defines a item renderer for search enabled DataGrid.
	 *  The only difference compared to default DataGridItemRenderer is that the BoldSearchItemRenderer
	 *  when used with DataGrid implementing <code>ISearchable</code> highlights searched text by changing font weight to bold.
	 */
	public class BoldSearchItemRenderer extends DataGridItemRenderer
	{
		
		/**
		 * @private
		 */	
		override public function validateProperties():void
		{
			super.validateProperties();
			
			// if owner is searchable and searchExpression si set we highlight all matches of searchExpression
			if (listData && listData.owner is ISearchable)
			{
				var dg:ISearchable = ISearchable(listData.owner);
				if (dg.searchExpression)
				{
					htmlText = listData.label.replace(dg.searchExpression, "<b>$&</b>");
				}
				else
				{
					htmlText = listData.label;
				}
			}
		}
		
	}
}