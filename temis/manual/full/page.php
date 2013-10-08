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
require_once( dirname( __FILE__ ) . "/../../temis.php");
require_once( dirname(__FILE__ ) . "/../../objects/ui-widgets.php" );
require_once( dirname(__FILE__ ) . "/diagnostics.php" );

class pageTests  extends uiPage
{
	var $disableSaving = true;
	
	function construct()
	{
		$this->pages = array();
		$this->btnReset= new uiButton();
		$this->btnReset->onclick->AddHandler( "onreset" );
	}

	function onLoad()
	{
		$this->pages = array();
		
		$handle = opendir( dirname( __FILE__ ) );
		$files = array();
		while (false !== ($file = readdir($handle))) {
			if ( !is_dir( $file ) ) continue;
			if ( strpos( $file, '.' ) === 0) continue;
			$files[] = $file;
		}
		closedir( $handle );

		sort( $files );
		foreach( $files as $file ) {
			$this->pages[$file] = $file  . "/page.php";
		}

	}

	function onreset()
	{
		foreach( array_keys( $_SESSION ) as $key ) {
			unset( $_SESSION[ $key ] );
		}
	}

	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}
}

temis::runpage(  "pageTests" );

?>