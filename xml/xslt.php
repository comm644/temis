<?php
if (  version_compare( PHP_VERSION, "5.0.0" ) == +1) {
	require_once( dirname( __FILE__ ) . "/xslt_php5.php" );
}
else {
	require_once( dirname( __FILE__ ) . "/xslt_php4_dom.php" );
	require_once( dirname( __FILE__ ) . "/xslt_php4_xsl.php" );
}


?>