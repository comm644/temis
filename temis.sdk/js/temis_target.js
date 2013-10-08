/** class for AJAX targeting
 */
function Target( widgetId, widgetIndex, windowId )
{
    if ( widgetIndex == null ) widgetIndex ='';
    if ( windowId == undefined || windowId == '' ) windowId = "_self"; //set current

    this.windowId = windowId;
    this.id    = widgetId;
    this.index = widgetIndex;

    /** combine elementId
     */
    this.getElementId = function()
		{
			if ( this.index != '' ) {
				return this.id + "-" +  this.index;
			}
			return this.id;
		}
    
    
    /** returns target element
     */
    this.getElement = function()
	{
	    var win;
	    if ( this.windowId != null && this.windowId !='' ) {
			win = '';
	    }
	    //else
		{
			win = window;
	    }
	    var e = window.document.getElementById( this.getElementId() );
	    if ( !e ) alert( "TEMIS AJAX Error: Element '" + this.getElementId()  +"' in window '"+ this.windowId + "' not found. Check syntax!" );
	    return e;
	}

    /** return values as string
     */
    this.toString = function()
		{
			return "[windowId="+this.windowId+ ",id="+this.id+",index="+this.index +"]";
		}

	/** return true if AJAX required
	 */
	this.isAjaxRequired = function()
		{
			return this.id !=null && this.id !='';
		}
}
