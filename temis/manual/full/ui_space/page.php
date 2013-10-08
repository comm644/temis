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
require_once( dirname( __FILE__ ) . "/../../../temis.php");
require_once( dirname(__FILE__ ) . "/../../../objects/ui-widgets.php" );
require_once( dirname(__FILE__ ) . "/../diagnostics.php" );

class testSpace extends uiPage
{
	function getTemplateName()
	{
		return dirname( __FILE__ ) . "/page.xsl";
	}

	function onLoad()
	{
		Diag::update( $this );
	}
	
}

temis::runpage(  "testSpace" );

?>
