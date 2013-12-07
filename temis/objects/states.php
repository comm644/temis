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
/******************************************************************************
 Copyright (c) 2007 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : State Save/Load strategies
 File       : states.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/


/** inerface for state manager
  */
class StateManager
{
	/**
	 * Storage page 
	 *
	 * @param uiPage $page
	 * @abstract
	 */
	function store(&$page){}
	
	/**
	 * Restore page with specified pageclass
	 *
	 * @param uiPage $pageclass
	 * @return uiPage
	 * @abstract
	 */
	function restore($pageclass){ return null;}
	
	/**
	 * Reset page in state storage
	 *
	 * @param uiPage $page
	 * @abstract
	 */
	function cleanup(&$page){}
}



/** do not need save anything
 */
class PageState_none extends StateManager
{
	function store(&$page){}
	function restore($pageclass){}
	function cleanup(&$page){}
}


class PageState_session extends StateManager
{
	function store(&$page)
	{
		$pageclass = get_class( $page );
		session::set( PageState::getName( $pageclass ), $page );
	}
	function restore($pageclass)
	{
		return session::get( PageState::getName( $pageclass ) );
	}

	function cleanup(&$page)
	{
		$pageclass = get_class( $page );
		session::del(  PageState::getName( $pageclass ) );
	}
}



class PageState_cookie extends StateManager
{
	function store(&$page)
	{
		//todo: need describe cookie expired time
	}
	function restore($pageclass)
	{
		return cookie::get( PageState::getName( $pageclass ) );
	}

	function cleanup(&$page)
	{
		$pageclass = get_class( $page );
		cookie::del(  PageState::getName( $pageclass ) );
	}
}



class PageState_view  extends StateManager
{
	function store(&$page)
	{
		$viewkey = "__viewstate";
		$page->viewstate = null;
		$page->viewstate = base64_encode( gzcompress( serialize( $page ) ) );
	}
	function restore($pageclass)
	{
		$viewkey = "__viewstate";
		if(  Temis::isPostBack() && array_key_exists( $viewkey, $_POST )) {
			if ( !$_POST[ $viewkey ] ) return null;
			$page = unserialize( gzuncompress( base64_decode( $_POST[ $viewkey ] ) ) );
			return $page;
		}
		return null;
	}
	function cleanup(&$page)
	{
		$page->viewstate = null;
	}
}
?>