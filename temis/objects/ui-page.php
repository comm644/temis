<?php
/*

   Copyright (c) 2008 Alexey V. Vasilyev

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

*/
?><?php
require_once( dirname( __FILE__ ) . "/ui-control.php" );



/** data container to store protected and private fields
 * which must be from XML page presntation.
 */
class uiPage_protected extends uiControl
{
	/**
	 * temis command
	 *
	 * @var TemisAction
	 */
	var $_command = null;

	/** store delayed command
	 * @param TemisAction
	 */
	function _temis_command( $command )
	{
		$this->_command = $command;
	}

	/** execute delayed command
	 */
	function _temis_commandExecute()
	{
		if ( $this->_command == null ) return;
		
		$command = $this->_command;
		$this->_command = null; //do need save this data
		$command->execute();
	}
}

/**
 * Base class for all Your pages.
 *
 * You must inherit your page controller from this class.
 */
class uiPage extends uiPage_protected
{
	var $url;
	var $previousUrl;

	//sign about post back action
	var $isPostBack = false;

	/**
	 * Page contrucutor. Do not override contructor!!
	 * for page initializing use construct()
	 *
	 * @access private
	 */
	function uiPage()
	{
		$this->isPostBack = Temis::isPostBack();
		$this->construct();
	}

	/** method should be called only when page has created
	 *
	 * @param string $currentURI  page current URI
	 * @param string|null $previousURI  page previous URI if exists
	 * @access private
	 */
	function _temis_setLocation( $currentURI, $previousURI = null)
	{
		$this->url = $currentURI;
		if ( $previousURI != null && $previousURI != "" ) {
			$this->previousUrl = $previousURI;
		}
	}
	
	/**
	 * Process page strategy.
	 *
	 * @access private
	 */
	function _temis_process() 
	{
		$actionkey = "__action";
		
		$this->isPostBack = Temis::isPostBack();
		$this->_temis_onLoad();

		//some user defined preporcessing input arguments.
		//you can verify access rights in this method.
		$this->onPreLoad();

		if ( $this->_command == null ) {

			//stadard page processing. load data.
			$this->onLoad(new Sender( "page", $this), $this->__name);

			//dispatch user event (onclick, or another postback)
			$this->_temis_dispatchEvent();

			//finalize user work.
			$this->onPostLoad();
		}

		//dispatch temis command. redirect, reload, etc.
		$this->_temis_commandExecute();
	}

	/**
	 * Dispatch event.
	 * 
	 * @access private
	 */
	function _temis_dispatchEvent()
	{
		$actionkey = "__action";
		$valuekey  = "__value";
		
		if ( !array_key_exists($actionkey,  $_POST ) ){
			return;
		}
		if ( $_POST[ $actionkey ] == '') {
			return;
		}

		$obj = array();
		parse_str( $_POST[ $actionkey ], $obj );

		if ( count( $obj ) != 3 ) {
			trigger_error( "TEMIS Error: invalid event: '{$_POST[ $actionkey ]}'", E_USER_ERROR );
			return;
		}

		$_POST[ $actionkey ] = $obj;

		$member = $obj["receiver"];
		$event  = $obj["event"];
		$index  = $obj["index"];

		$path = $member;
		$parts = explode("--", $member );

		array_shift( $parts ); //remove 'page' or 'ajax'

		$sender=implode(":", $parts);
		$obj = $this;
		while( count( $parts )  ) {
			$member = array_shift($parts);
			if ( !array_key_exists( $member, $obj ) ) {
				print_r( $this );
				trigger_error( "TEMIS Error: member=\"$member\" is not found, path=$path\n",E_USER_ERROR );
				return;
			}
			$obj = $obj->{$member};
		}

		$value = $index;
		if ( array_key_exists($valuekey,  $_POST ) and $_POST[ $valuekey ] != ''){
			$value= $_POST[$valuekey];
		}

		if ( !is_null($obj) ) {
			$obj->$event->dispatch( new Sender( $sender, $this ), $value, $this );
		}
	}

	/** system hidden method, performs loading all values
	 * 
	 * @access private
	 */
	function _temis_onLoad()
	{
		//import all members
		$members = get_object_vars( $this );
		foreach( $members as $name => $value ) {
			if ( !is_object( $this->$name ) ) continue;
			if ( !is_subclass_of( $this->$name, CLASS_uiWidget ) ) continue;
			$this->$name->onLoad( new Sender( "page", $this ), $this->{$name}->__name );
		}
	}

	/** top level method
	 */ 
	function _temis_initControls() //system hidden method
	{
		$this->__name = "page";
		parent::_temis_initControls();
	}

	function initialize()
	{
		$this->_temis_initControls();
	}


	//public methods

	/** redirect to other page
	 *
	 * @param string $url   redirect URL
	 * @access public
	 */
	function redirect( $url )
	{
		$this->_temis_command( new TemisAction_Redirect( $this, $url ) );
	}


	/** Reload page and stay here
	 *
	 * Method generates HTTP Redirect code after page processing
	 *
	 * @access public
	 */
	function reload()
	{
		$this->_temis_command( new TemisAction_Reload( $this ) );
	}

	/** return back to previous page.
	 *
	 * As previous page url uses URL retrieved from HTTP_REFFERER on
	 * page construction.
	 *
	 * Method can be used if request was maked via callPage()
	 *
	 * @access public
	 */
	function back()
	{
		//leave page
		if ( $this->previousUrl != "" ) {
			$this->redirect(  $this->previousUrl );
		}
		else {
			$this->reload();
		}
	}

	/** close popup window/page
	 * @access public
	 */
	function close()
	{
		$this->_temis_command( new TemisAction_Close( $this ) );
	}


	/**
	 * This method called on each page load.
	 * You can detect loading type via isPostBack()
	 *
	 * @virtual
	 *
	 */
	function onLoad( $sender, $selfname )
	{
		//user defined method
	}

	/**
	 * This method wil be called before executng onLoad().
	 * If you call redirect() or reload(), then onLoad() and onPostLoad()
	 * will not be executed.
	 *
	 * You can verify access rights in this method:
	 *
	 * Example:
	 * 
	 * if ( pageNotAllowed ) $this->redirect( '?acess_denied' );
	 *
	 * @virtual
	 *
	 */
	function onPreLoad()
	{
		//user defined method
	}

	/**
	 * This method will be called after onLoad() anyway.
	 * In this methods you can finalize your caches.
	 * 
	 * @virtual
	 *
	 */
	function onPostLoad()
	{
		//user defined method
	}

	/** user defined constructor
	 * 
	 * @abstract
	 */
	function construct()
	{
	}


	/**
	 *  Method indicates whether page was  posted back.
	 *
	 * @access public
	 * @return bool
	 */
	function isPostBack()
	{
		return $this->isPostBack;
	}
	
	/**
	 * This method must returns filename of template.
	 * by default method returns filename <page>.xsl
	 *
	 * @virtual
	 * @return string   full pathname to template
	 */
	function getTemplateName()
	{
		return( temisTemplate::getCodeFile() . ".xsl" );
	}
	
	/**
	 *  this method must returns output format. 
	 * Avaiable values: html, xml, xhtml, pagexml
	 *  \li  pagexml - page serialized as xml
	 * @virtual
	 * @return string
	 */
	function getOutputFormat()
	{
		return "html";
	}

	/** Virtual method should to return  StateManager object in temis-pagestate.php
	 *
	 * @see PageStage for details
	 * @abstract
	 * @return StateManager
	 */
	static function getStateManager()
	{
		return PageState::inSession();
	}

	/** return current Application/Domain context
	 *
	 * @return Application
	 */
	function &getApplication()
	{
		return Application::getInstance();
	}
	
	/**
	 * Create page renderer
	 *
	 * @return temisTemplate  or compatible
	 */
	function createRenderer()
	{
		return new temisTemplate();
	}

	/**
	 * Force load single page control in out-of-band stream.
	 *
	 * This method can be used for reading incoming values before
	 * processing page in normal flow.
	 *
	 * Use case: cache control
	 *
	 */
	function loadSingleControl( $name )
	{
		$this->$name->__name = $name;
		$this->$name->onLoad(new Sender('page', $this), $this->$name->__name );
	}
}

define( "CLASS_uiPage", get_class( new uiPage() ) );
?>