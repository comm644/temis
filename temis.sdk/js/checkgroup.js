/* Class for support groupping checkboxes
   (c) 2008 Alexei V. Vasilyev. All Rights Reserved.
*/

function checkgroup()
{
	//class
	function groupInfo()
	{
		this.itemOf = "";
		this.handlerOf = "";
	}

	//class
	function group ()
	{
		this.handlers = new Array();
		this.items = new Array();
	};

	//private static method
	function defineInfo( element )
	{
		if ( element.groupInfo == undefined ) {
			element.groupInfo = new groupInfo();
		}
	}

	this.groups= new Array();


	/** return created or exist group by groupID
	 */
	this.createGroup = function( groupId )
		{
			if ( this.groups[ groupId ] == undefined ) {
				this.groups[ groupId ] = new group();
			}
			return this.groups[ groupId ];
		}

	/** return exists group by groupID or undefined
	 */
	this.getGroup = function( groupId )
		{
			if ( this.groups[ groupId ] == undefined ) return undefined;
			return this.groups[ groupId ];
		}


	/** register checkbox in group

	@param element   event sender
	@param groupId   group ID
	*/
	this.registerMember = function( elementId, groupId )
		{
			var element = document.getElementById( elementId );
			var group = this.createGroup( groupId );
			group.items[ element.id ] = element;
			defineInfo( element );
			element.groupInfo.itemOf = groupId;
		}

	/** register handler in group

	@param element   event sender
	@param groupId   group ID
	*/
	this.registerRoot = function( elementId, groupId )
		{
			var element = document.getElementById( elementId );
			var group = this.createGroup( groupId );
			group.handlers.push( element );
			defineInfo( element );
			element.groupInfo.handlerOf = groupId;
		}


	/** onchange handler for group handler
		@param element   event sender
		@param groupId   group ID
	*/
	this.clickRoot = function ( element )
		{
			if ( element.groupInfo.handlerOf == "" ) return;

			var group = this.getGroup( element.groupInfo.handlerOf );
			if ( group == undefined ) return true;

			for( key in group.items ){
				var e = group.items[key];
				e.checked = element.checked;
				this.clickRoot( e );
			}
			return true;
		}

	/** onchange handler for child

	@param element   event sender
	@param groupId   group ID
	*/
	this.clickMember = function ( element )
		{
			if ( element.groupInfo.itemOf == "" ) return;

			var group = this.getGroup( element.groupInfo.itemOf );
			if ( group == undefined ) return true;

			for( key in group.handlers ){
				var e = group.handlers[key];
				e.checked &= element.checked;
				this.clickMember( e );
			}
			return true;
		}

}


var _checkgroup = new checkgroup();





