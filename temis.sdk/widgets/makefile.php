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
?>
<?php

require_once( dirname( __FILE__ ) . "/../phpmake/make.php" );
require_once( dirname( __FILE__ ) . "/../xitec/xitec.php" );
define( "WIDRESULT", dirname(__FILE__) ."/../../temis/compiled/widget.xsl");

class all extends task
{
	function isphony() { return true; }
	function deps() { return new widgets(); }
}

class widgets extends task
{
	function target() { return WIDRESULT; }
	function deps()   { return utils::getfiles( dirname(__FILE__) ."/*.xsl" ); }
	function execute($target, $deps)
	{	
		$dir = dirname( $target->target() );
		if ( !file_exists( $dir ) ) mkdir( $dir );
		$xitec = Xitec::getInstance();
		$xitec->compile( dirname( __FILE__ ) . "/widget.xsl", $target->target());
	}
}

class clean extends task
{
	function isphony() { return true; }
	function execute($target, $deps)
	{
		unlink( WIDRESULT );
	}
}


make::main("all");
  
?>