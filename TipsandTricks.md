#Tips and sample snippets for resuable-fx


**How to set the backgroundColor of a MDataGrid cell**

The MDataGrid class uses a BoldSearchItemRenderer component to draw the text for a cell.

To change the background color of a cell, in the overrriden method "validateProperties" set :

background=true; //so color will show

Then you can set the actual backgroundColor:

backgroundColor=0x00FF00; //green

You might for example test a value in your dataSource:

if(data["active"]==0) backgroundColor=0x00FF00; //green
