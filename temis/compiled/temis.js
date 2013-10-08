/** Some XML Document cross-browser stuff
	(c) 2008 Alexei V. Vasilyev. All Rights Reserved.
 */

window.document.__haveDomCopying = 2;
window.document.haveDomCopying = function()
{
	if ( this.__haveDomCopying != 2 ) return this.__haveDomCopying == 1;
	var testval  = "attribute-test";
	var value = this.body.className;
	this.body.setAttribute("class", testval);
	var isHave = this.body.className == testval;
	this.body.className = value;

	__haveDomCopying = isHave;
	return isHave;
}

window.document.__haveRuntimeScriptLoading = 2;

window.document.haveRuntimeScriptLoading = function()
{
	if ( this.__haveRuntimeScriptLoading != 2 ) return this.__haveRuntimeScriptLoading == 1;
	
	var s = this.createElement("script");
	var c = this.createTextNode("window.document.__haveRuntimeScriptLoading=1;");
	try {
		s.appendChild(c);
		var body = this.getElementsByTagName("body")[0];
		body.appendChild( s );
	}
	catch (e){
		this.__haveRuntimeScriptLoading = 0; //IE
	}

	if( this.__haveRuntimeScriptLoading == 2 ) {
		this.__haveRuntimeScriptLoading = 0;
	}
	var isHave = this.__haveRuntimeScriptLoading == 1;
	return isHave;
}
	

window.document.importNode = function( sourceNode, deep )
{
	
	if ( !sourceNode ) return;
 	if ( sourceNode.nodeType == 3) { //catch textnode
 		return this.createTextNode( sourceNode.data );
 	}
	var target = this.createElement( sourceNode.tagName );

	if ( sourceNode.attributes ){
		for( var n=0; n < sourceNode.attributes.length; ++n ) {
			var at = sourceNode.attributes[n];
			target.setAttribute( at.nodeName, at.nodeValue);
		}
	}
	
	for( var n=0; n <sourceNode.childNodes.length; ++n ) {
		var child =  this.importNode( sourceNode.childNodes[n], deep );
		if ( child ) target.appendChild(child );
	}
	return target;
}

window.document.isNonClosedTag = function( name )
{
	var htmlTags = [ "INPUT", "BR", "HR" ];
	name = name.toUpperCase(name);
	for( i in htmlTags ) {
		if ( name == htmlTags[i] ) return true;
	}
	return false;
}
	
window.document.nodeToHTML = function( el  )
{
	if ( !el ) return "";
	if ( el.nodeType == 3) { //catch textnode
 		return el.nodeValue;
 	}
	
	var str ="<" + el.nodeName + " ";
	if ( el.attributes ){
		for( var n=0; n < el.attributes.length; ++n ) {
			var at = el.attributes[n];
			var s = at.nodeName + "=\"" + at.nodeValue  + "\" ";
			str += s;
		}
	}
	str +=">";
	for( var n=0; n <el.childNodes.length; ++n ) {
		var child=  el.childNodes[n];
		str += this.nodeToHTML( child);
	}
	if ( !document.isNonClosedTag( el.nodeName ) ) {
		str += "</" + el.nodeName + ">";
	}
	return str;
}

window.document.nodeToString = function( el, prefix )
{
	if ( !el ) return "";
	if ( el.nodeType == 3) { //catch textnode
 		return prefix + el.nodeValue + "\n";
 	}
	if ( prefix == null ) prefix = "";
	
	var str = prefix + "<" + el.nodeName + " ";
	if ( el.attributes ){
		for( var n=0; n < el.attributes.length; ++n ) {
			var at = el.attributes[n];
			if ( at.nodeValue == null ) continue;
			if ( at.nodeValue == "" ) continue;
			if ( at.nodeValue == "inherit" ) continue;
			var s = at.nodeName + "=\"" + at.nodeValue  + "\" ";
			str += s;
		}
	}
	str +=">\n";
	for( var n=0; n <el.childNodes.length; ++n ) {
		var child=  el.childNodes[n];
		str += this.nodeToString( child, prefix + " " );
	}
	str += prefix + "</" + el.nodeName + ">\n";
	return str;
}

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
function temis( formName )
{
	this.submitted = false;

	this.createEvent = function( event, receiver, index )
		{
			return new Event( event, receiver, index );
		}
	this.createTarget = function( widgetId, widgetIndex, windowId )
		{
			return new Target( widgetId, widgetIndex, windowId );
		}
	
	
	/*
	  User side event dispatcher
	  
	  var event = new temis_event();
	  event.addAction( "alert( 'got event' );" );
	  event.dispatch();
	*/

	this.event = function()
	{
		this.actions = Array();

		
		this.addAction = function( code )
			{
				this.actions.push( code );
			}

		this.dispatch  = function()
			{
				for (var i=0; i < this.actions.length; i++) {
					eval( this.actions[i] );
				}
			}
	}
	
	//data
	this.formName = formName;

	//events
	this.onSubmit = new this.event();

	//methods
	this.submit  = function()
		{
			this.onSubmit.dispatch();
			return true;
		}
	
	this.getForm = function()
		{
			var forms = document.getElementsByTagName("form");
			for( var idx in forms ) {
			   if ( forms[idx].getAttribute("name") == this.formName ) {
			       return forms[idx];
			   }
			}
			return undefined;
		}
	
	this.setValue = function( name, value )
		{
			var e = this.getForm().elements[ name ];
			if ( !e ) alert( "TEMIS Error: Element '" + name +"' not found. Check syntax!" );
			e.value = value;
		}

	this.postBack = function( event )
		{
			this.setDefaultAction( event );
			this.submit(); //fire event
			this.submitted = true;
			this.getForm().onsubmit=null;
			this.getForm().submit();
		}
	

	this.postBackValue = function( name, value )
		{
			this.setValue( name, value );
			this.postBack( name, 'onclick' );
		}


	this.setDefaultAction = function( event )
		{
			this.setValue( "__postback", 1 );
			this.setValue( "__action", this.getQueryString(event) );
		}
	

	/** returns forms values for simulating postback acton via AJAX
	 */
	this.getFormValues = function( event )
		{
			var params = new Array();
			var form = this.getForm();
			for (i =0; i < form.elements.length; ++i){
				var el = form.elements[i];
				if ( el.tagName == "INPUT" ) {
					if ( el.type == 'hidden' || el.type == 'text' ) {
						params[el.name] = el.value;
					}
					else if ( el.type == 'checkbox' ) {
						if ( el.checked ) params[el.name] = 1;
					}
					else if ( el.type == 'radio' ) {
						if ( el.checked ) params[el.name] = el.value;
					}
				}
				else if ( el.tagName == "TEXTAREA" ) {
					params[el.name] = el.value;
				}
				else if ( el.tagName == 'SELECT' ) {	
					params[ el.name ] = el.getElementsByTagName('OPTION')[el.selectedIndex].getAttribute('value');
				}
			}

			params["__postback"] = 1;
			params["__action"]=this.getQueryString(event);
	
			return params;
		}


	/** Click checkbox or radio, called from caption
	    @param widgetId   unique widget ID
	    @return  always true for direct using in 'onclick'
	*/
	this.clickWidget = function( widgetId )
	    {
			var  e = document.getElementById( widgetId );
			if ( !e ) alert( "TEMIS Error: Widget '" + widgetId +"' not found. Check syntax!" );
			e.click(); //process default action on click

			if ( this.submitted ) return;//event delivered
			return true;
	    }


	/** client main code, all call are generated via WIDGETS

	@param target object of Target class (container)
	@param event  object ob Event class (container)
	 */
	this.sendMessage = function( sender, event, target)
		{
			if ( target.isAjaxRequired() ){
				if ( _temis_ajax != null ) {
					_temis_ajax.execute( sender.id, event, target );
				}
				else alert( "TEMIS: Error: AJAX does not found" );
				return;
			}
	
			var form = _temis.getForm();
			form.target= target.windowId;

			this.postBack( event );
		}


	/* encode 'data' into string for query (utf-8)
	   (c) http://xpoint.ru/know-how/JavaScript/YemulyatsiyaOtpravkiFormyiPriPomoschiXMLHttpRequest
	   (c) 2007 Alexei V. Vasilyev
	*/
	this.getQueryString = function(data)
		{
			var query = [];
			if (data instanceof Object) {
				for (var k in data) {
					if ( typeof data[k] == "function" ) continue;
					query.push(encodeURIComponent(k) + "=" + encodeURIComponent(data[k]));
				}
				return query.join('&');
			} else {
				return encodeURIComponent(data);
			}
		}
	
}


var _temis = new temis( '_main' );

// AJAX for TEMIS
// (c) 2007 Alexei V. Vasilyev. All rights reserved.

function temis_ajax()
{

	/** Select HttpRequest
	 */
	this.getHttpRequest = function ()
	    {
			if (window.XMLHttpRequest) // if Mozilla, Safari etc
				return new XMLHttpRequest();
	
			if (window.ActiveXObject){ // if IE
				var msxmls = new Array(
					'Msxml2.XMLHTTP.5.0',
					 'Msxml2.XMLHTTP.4.0',
					 'Msxml2.XMLHTTP.3.0',
					 'Msxml2.XMLHTTP',
					 'Microsoft.XMLHTTP');
		
				for (var i = 0; i < msxmls.length; i++) {
					try {
						return new ActiveXObject(msxmls[i]);
					} catch (e) {}
				}
			}
	
			return null;
	    }


	/** method provides updating TEMIS component
		@param id        sender
		@apram event     sender event
		@param target    result receiver, object of Target
	*/
	this.execute = function(id, event, target)
		{
			var e = target.getElement();
			if ( !e ) {
				alert( "TEMIS AJAX Error: Element '" + target.toString() +"' not found. Check syntax!" );
				return true;
			}

			var req = this.getHttpRequest();
			if ( req == null) {
				alert( "TEMIS AJAX: Can't to fintd HttpRequest");
				return true;
			}

			req.onreadystatechange=function(){
				if ( req.readyState==4 && req.status==200) {
					var e = target.getElement();
					if ( !req.responseXML
						|| !req.responseXML.documentElement
						||	 req.responseXML.documentElement.tagName == "parsererror" 
						) {
						e.innerHTML = "NonXML received:" + req.responseText;
					}
					else  if ( document.haveDomCopying() ) {
						var updatedNode = document.importNode(req.responseXML.documentElement, true );
						if ( !updatedNode ) {
							e.innerHTML = "TEMIS AJAX Error: can't clone node" + req.responseText;
						}
						else {
							e.parentNode.replaceChild(updatedNode, e );
						}
					}
					else {
						var placeHolder = document.createElement("div");
						placeHolder.innerHTML = document.nodeToHTML( req.responseXML.documentElement );
						e.parentNode.replaceChild(placeHolder.firstChild, e );
					}
					
					//exec scripts
					if ( !window.document.haveRuntimeScriptLoading() ){
						_temis_ajax.executeScripts( req.responseXML.documentElement );
					}
				}
			}

			var sender = window.document.getElementById(id);
			var params = _temis.getFormValues(event );
			params["__ajax"]       = target.id; //save ajax caller
			params["__ajax_index"] = target.index; 
			
			var query = _temis.getQueryString( params );

			var parts = window.location.href.split("#");
			var href =parts[0];
	
			req.open('POST', href);
			req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			req.send(query);
		}

	this.executeScripts = function( sourceNode )
		{
			var nodeName = sourceNode.nodeName.toUpperCase();
			if ( nodeName == "SCRIPT" ) {
				var src = sourceNode.getAttribute("src");
				if ( src != "" && src != null) {
					var msg = "TEMIS AJAX Error:"
					+ " Can't load " + src + ".\n"
					+ " The TEMIS framework does not have support for loading refrenced javascripts in AJAX ui:panel.\n Please use external js.include library.";
					alert( msg, "error" );
					return;
				}
				var code = sourceNode.firstChild.nodeValue;
				eval( code);
				return;
			}
			else {
				for( var n=0; n <sourceNode.childNodes.length; ++n ) {
					this.executeScripts( sourceNode.childNodes[n] );
				}
			}
		}
}
	

var _temis_ajax=new temis_ajax();


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





