function temis( formName )
{
	this.submitted = false;

    this.doEvent = function(sender,event,receiver,index, target, targetIndex, targetWindow) 
    {
      _temis.sendMessage(sender, _temis.createEvent(event, receiver,index), _temis.createTarget(target, targetIndex, targetWindow) );
    }
    
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

