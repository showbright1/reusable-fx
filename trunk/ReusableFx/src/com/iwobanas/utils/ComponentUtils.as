package com.iwobanas.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * The ComponentUtils class is an all-static class with methods for working with visual components.
	 * You do not create instances of ComponentUtils; instead you simply call static methods such as the ComponentUtils.getVisibleBounds() method. 
	 */
	public class ComponentUtils
	{
		
		/**
		 *  Returns a rectangle that describes the visible region of the component, including any dropshadows or filters.
		 *  This method is copied from Flex 3 MaskEffectInstance implemetation.
		 *  @param target the component to be described
		 */
		public static function getVisibleBounds(target:DisplayObject):Rectangle
		{	
			var bitmap:BitmapData = new BitmapData(target.width + 200, target.height + 200, true, 0x00000000);
			var m:Matrix = new Matrix();
			m.translate(100, 100);
			bitmap.draw(target, m);
			var actualBounds:Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			actualBounds.x = actualBounds.x - 100;
			actualBounds.y = actualBounds.y - 100;
	
			bitmap.dispose();
			
			if (actualBounds.width < target.width)
			{
				actualBounds.width = target.width;
				actualBounds.x = 0;
			}
			if (actualBounds.height < target.height)
			{
				actualBounds.height = target.height;
				actualBounds.y = 0;
			}
			
			return actualBounds;
		}
	}
}