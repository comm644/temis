<?php

class Temis_PhpVersionValidator
{
	function getConfiguredVersion() { return TEMIS_CONFIGURED_PHP_VERSION; }
	function getCurrentVersion() { return PHP_VERSION; }
	function isConfiguredForPhp5() { return TEMIS_CONFIGURED_FOR_PHP5; }


	function isPhp5( $version )
	{
		return version_compare($version, "5.0.0" ) >= 0;
	}
	
	function isValid()
	{
		$current = $this->getCurrentVersion();
		
		//test downgrade
		$isChanged = version_compare( $this->getConfiguredVersion(), $current ) != 0;
	
		if ( !$isChanged ) return true;

		//changed
		return ( $this->isPhp5( $current ) == $this->isConfiguredForPhp5() );
	}

	function verify()
	{
		$isValidVersion = $this->isValid();
		
		if ( !$isValidVersion ) {
			trigger_error( "TEMIS Error: Please reinstall Temis Framework. You have installed for PHP " 
				. $this->getConfiguredVersion()
				. " but have used PHP " . $this->getCurrentVersion(), E_USER_ERROR );
			exit;
		}
	}
}
?>