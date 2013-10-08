<?php
require_once( dirname( __FILE__ ). "/lib/WizardRunner.php" );
require_once( dirname( __FILE__ ). "/setup.class.php" );


session_start();
require_once( dirname( __FILE__ ). "/pages.php" );

$page = new WizardRunner( dirname(__FILE__)."/template.html" );
$page->run(  $wizard );

session_write_close();
?>
