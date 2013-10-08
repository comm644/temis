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
require_once( dirname( __FILE__ ) . "/../../modules/phptest/phptest.php" );

//$PHPTEST_VERBOSE=true;

// test suites define

// end test suites define

//require_once(dirname( __FILE__ ) . "/../config.php" );

$argc = $_SERVER['argc'];
$argv = $_SERVER['argv'];
if ( $argc > 1 ) {
	for( $i=1;  $i <$argc; $i++ ) {
		print( "Loading {$argv[$i]}...\n" );
		require_once( $argv[$i] );
	}
	phpTest::run();
}
else {
	phpTest::run(true);
}

?>