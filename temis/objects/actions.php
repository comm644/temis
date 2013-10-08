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


/**
 * Interface class for Temis actions.
 */
class TemisAction
{
	/**
	 * Method incapsulates one action after page loading.
	 * 
	 * Method must be redefined.
	 * @abstract
	 */
	function execute()
	{
		
	}
}

class TemisAction_Redirect extends TemisAction
{
	var $page;
	var $destURI;

	function TemisAction_Redirect( &$srcPage, $destURI )
	{
		$this->page = &$srcPage;
		$this->destURI = $destURI;
	}
	
	function execute()
	{
		PageState::close( $this->page );
		Application::saveState();

		Temis::_redirect( $this->destURI );
	}
}


class TemisAction_Reload extends TemisAction
{
	var $page;
	
	function TemisAction_Reload(&$page)
	{
		$this->page = &$page;
	}
	function execute()
	{
		PageState::save( $this->page );
		Application::saveState();
		Temis::_redirect( $this->page->url );
	}
}

/** close popup window
 */
class TemisAction_Close extends TemisAction
{
	var $page;
	
	function TemisAction_Close( &$page )
	{
		$this->page = &$page;
	}
	
	function execute()
	{
		PageState::close( $this->page );
		Application::saveState();

		echo '<html><body><script lang="javascript">window.close();</script></body></html>';
		exit;
	}
}

?>