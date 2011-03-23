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
package com.iwobanas.core
{
	/**
	 * The ISearchable interface defines interface for components that can be searched.
	 *  
	 * <p>This interface defines a way of passing searched wildcard to a component and how search result is returned.
	 * Because different component may return found data in different format this interface defines a result
	 * as boolean meaning that something was found <code>true</code> or not <code>false</code>. 
	 * Implementing component have to expose found value using its own interface.</p>
	 */
	public interface ISearchable
	{
		
		/**
		 * Flag indicating if last search ended successfully <code>true</code> or not <code>false</code>.
		 */
		[Bindable("searchResultChanged")]
		function get found():Boolean;
		
		/**
		 * String wildcard used in last search.
		 * <p>This should equal to the string passed to the <code>find()</code> function.</p>
		 */ 
		[Bindable("searchParamsChanged")]
		function get searchString():String;
		
		/**		
		 * String wildcard converted to the regular expression (RegExp).
		 */
		[Bindable("searchParamsChanged")]
		function get searchExpression():RegExp;
		
		/**
		 * Find the given wildcard in the component.
		 * 
		 * <p>Search the component for text wildcard passed <code>wildcard</code> 
		 * and return boolean value determining if something was found. 
		 * The wildcard should interpret <code>"*"</code> character as matching any string
		 * and <code>"?"</code> character as matching any single character.</p>
		 * 
		 * <p>Component may change its state after call to this function so that additional information
		 * about what was found can be accessed</p>
		 * 
		 * @param wildcard text to search for
		 * @param caseInsensitive flag indicating whether search should be case insensitive
		 * @return <code>true</code> if text was fond or <code>false</code> if not
		 */
		function find(wildcard:String, caseInsensitive:Boolean = true):Boolean;
		
		/**
		 * Find next match using parameters specified in last call to <code>found()</code> function.
		 */
		function findNext():Boolean;
		
		/**
		 * Find previous match using parameters specified in last call to <code>found()</code> function.
		 */
		function findPrevious():Boolean;

	}
}