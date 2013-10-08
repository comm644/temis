<?php

require_once( dirname( __FILE__ ) . "/../objects/PhpVersionValidator.php" );


class MockValidator extends Temis_PhpVersionValidator
{
	var $configured;
	var $current;

	function MockValidator( $configured, $current )
	{
		$this->configured = $configured;
		$this->current = $current;
	}
	
	function getConfiguredVersion() { return $this->configured; }
	function getCurrentVersion() { return $this->current; }
	function isConfiguredForPhp5()
	{
		return $this->isPhp5( $this->configured );
	}

	
}

class testVersionValidator extends phpTest_TestSuite
{
	function test_php5_nonchanged()
	{
		$validator = new MockValidator( "5.0.1", "5.0.1" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

	function test_php5_upgrade()
	{
		$validator = new MockValidator( "5.0.1", "5.0.2" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

	function test_php5_downgrade()
	{
		$validator = new MockValidator( "5.0.1", "5.0.0" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

	function test_php5_downgrade_to_php4()
	{
		$validator = new MockValidator( "5.0.1", "4.8.10" );

		TS_ASSERT_EQUALS( false, $validator->isValid() );
	}

	function test_php4_upgrade_to_php5()
	{
		$validator = new MockValidator( "4.8.10", "5.0.1" );

		TS_ASSERT_EQUALS( false, $validator->isValid() );
	}


	function test_php4_nonchanged()
	{
		$validator = new MockValidator( "4.8.1", "4.8.1" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

	function test_php4_upgrade()
	{
		$validator = new MockValidator( "4.8.9", "4.8.10" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

	function test_php4_downgrade()
	{
		$validator = new MockValidator( "4.8.10", "4.8.9" );

		TS_ASSERT_EQUALS( true, $validator->isValid() );
	}

}

?>