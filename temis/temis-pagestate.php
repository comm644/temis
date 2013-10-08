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
require_once( dirname( __FILE__ ) . "/php4.php" );

/** Class manages load, create, save, delete page and page state
 */
class PageState 
{
	static function getName( $pageclass )
	{
		global $TEMIS_PAGE;
		$uri = md5( PageLocation::getURI() );
		return( $TEMIS_PAGE . $pageclass . "_" . $uri );
	}


	static function load( $pageclass )
	{
		$code = "return $pageclass::getStateManager();"; //call static member for some class without creating object
		$manager = eval( $code );
		$page = $manager->restore($pageclass);
		
		if ( $page == null ) {
			$page = new $pageclass();
			$page->_temis_setLocation( PageLocation::getURI(),  PageLocation::getPreviousURI() );
			$page->_temis_initControls();
		}
		return( $page );
	}

	static function save( $page )
	{
		$manager = $page->getStateManager();
		$page = $manager->store($page);
		
	}

	static function close( $page )
	{
		if ( !$page ) {
			Diagnostics::error( "TEMIS Error: page is not defined" );
		}
		$manager = $page->getStateManager();
		$manager->cleanup($page);
	}


	/**
	 * Store page state in PHP session
	 *
	 * @static
	 * @return StateManager
	 */
	static function inSession(){return new PageState_session();}
	
	/**
	 * Store page state in cookies
	 *
	 * @static
	 * @return StateManager
	 */
	static function inCookies(){return new PageState_cookies();}
	
	/**
	 * Store page state in view
	 *
	 * @static
	 * @return StateManager
	 */
	static function inView(){return new PageState_view();}
	
	/**
	 * define PageState = none
	 *
	 * @static
	 * @return StateManager manager
	 */
	static function none(){return new PageState_none();}
}


?>