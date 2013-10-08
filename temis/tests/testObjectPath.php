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
require_once( dirname( __FILE__ ) ."/../objects/ObjectPath.php" );

class xtestObjectPath extends phpTest_TestSuite
{
	function testXPath()
	{
		$helper = new temisHelper();
		$obj = $helper->createObject( '/page/holder/item' );

		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj ) );
		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj->holder ) );
		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj->holder->item ) );
	}
	function testNamePath()
	{
		$helper = new temisHelper('$');

		$obj = $helper->createObject( 'page--holder--item');

		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj ) );
		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj->holder ) );
		TS_ASSERT_EQUALS( get_class(new stdclass), get_class($obj->holder->item ) );
	}

	function testGetObject()
	{
		$helper = new temisHelper('$');
		
		$sample = $helper->createObject( 'page--holder--item' );
		$sample->holder->item = 5;

		$obj = $helper->getObject( 'page$holder$item', $sample );
		print_r ($obj);
		TS_ASSERT_EQUALS( 5, $obj );
	}

	function testSetObject()
	{
		$helper = new temisHelper('/');
		
		$holder = $helper->createObject( '/page/holder/item' );

		$value = 5;
		$obj = $helper->setObject( '/page/holder/item', $holder, $value );
		TS_ASSERT_EQUALS( 5, $holder->holder->item );
	}

}
?>