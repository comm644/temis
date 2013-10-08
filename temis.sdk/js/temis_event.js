
/** class container for Event serverside
 */
function Event( event, receiver, index )
{
	if ( index == undefined ) index = "";
	
	this.event = event;
	this.receiver = receiver;
	this.index = index;

	this.toString = function()
		{
			return "[event="+this.event+",receiver="+this.receiver+",index="+this.index+"]";
		}
}

