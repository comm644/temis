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
	this.execute = function(id, event, target, onready)
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
                    if ( onready != undefined ) {
                        onready();
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


