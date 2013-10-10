<?php
/******************************************************************************
 Copyright (c) 2005 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : phpTest runner
 File       : phptestrunner.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description:
******************************************************************************/
require_once( dirname( __FILE__ ) . "/../Singleton.php" );

class testSingleton_A extends Singleton
{
	var $value;
}

class testSingleton_B extends testSingleton_A
{
}


/**
 * this some simple class , which used as static instabce
 *
 */
class testSingleton_someFrontend extends Singleton
{
	var $data="default";
	
	function method( $arg )
	{
		echo "method=$arg";
	}
	
	function getData()
	{
		return $this->data;
	}
	
}
class testSingleton_someProxy  
{
	function method()
	{
		$factory = new testSingleton_someFrontend();
		$instance= $factory->getInstance();
		
		$args = func_get_args();
		return call_user_func_array(array( $instance, "method"), $args);
	}
}

class testSingleton extends phpTest_TestSuite
{

	function test_getInstance()
	{
		$proto = new testSingleton_A();
		
		$a = &$proto->getInstance();
		$a->value = 5;

		$b = &$proto->getInstance();
		TS_ASSERT_EQUALS( 5, $b->value );

		TS_ASSERT_EQUALS( "testSingleton_A", get_class( $a ) );
		TS_ASSERT_EQUALS( "testSingleton_A", get_class( $b ) );
		
	}

	function test_setInstance()
	{
		$proto = new testSingleton_A();

		
		$a = new testSingleton_B();
		$a->value = 10;
		
		$g = &$proto->setInstance( $a );
		TS_ASSERT_EQUALS( 10, $g->value );
		
		$b = &$proto->getInstance();
		TS_ASSERT_EQUALS( 10, $b->value );
		
		
		$b = &$proto->getInstance();
		$b->value = 7;
		TS_ASSERT_EQUALS( 7, $a->value );

		$c = &$proto->getInstance();
		TS_ASSERT_EQUALS( 7, $c->value );

		TS_ASSERT_EQUALS( "testSingleton_B", get_class( $a ) );
		TS_ASSERT_EQUALS( "testSingleton_B", get_class( $b ) );
		TS_ASSERT_EQUALS( "testSingleton_B", get_class( $c ) );
		
	}
	
	function testProxy_frontend()
	{
		ob_start();
		testSingleton_someFrontend::method( "msg");
		$str = ob_get_clean();
		
		TS_ASSERT_EQUALS( "method=msg", $str);
	}

	function testProxy_singleton()
	{
		$instance= new testSingleton_someFrontend();
		$code = $instance->createFrontend("testSingleton_newFrontEnd");
		
		ob_start();
		testSingleton_newFrontEnd::method( "msg");
		$str = ob_get_clean();
		TS_ASSERT_EQUALS( "method=msg", $str);

		
		$instance->data = "some data";
		
		//instance not setted
		TS_ASSERT_EQUALS( "default", testSingleton_newFrontEnd::getData());
		
		//instance setted
		$instance->setInstance($instance);
		TS_ASSERT_EQUALS( "some data", testSingleton_newFrontEnd::getData());
		
	}
}

?>