<?php
require_once( dirname( __FILE__ ). "/../settings/config.php" );
require_once( dirname( __FILE__ ). "/../objects/DepsBuilder.php" );

class testTemplateBuilder extends phpTest_TestSuite
{
	function setUp()
	{
		if ( !file_exists( 'data' ) ) mkdir( 'data' );
		if ( file_exists( 'data/target.cxsl.deps' ) ) 
			unlink( 'data/target.cxsl.deps');

		$time = time();
		touch( 'data/dep1.xsl', $time, $time);
		touch( 'data/dep2.xsl', $time, $time);
		file_put_contents( 'data/source.xsl', '<?xml version="1.0" encoding="utf-8" ?><root/>' );
		touch( 'data/source.xsl', $time, $time);
		touch( 'data/target.cxsl', $time, $time);
	}
	
	function test_PublicUsage()
	{
		$deps = new DepsBuilder();

		$target = 'data/target.cxsl';
		$source = 'data/source.xsl';

		//no target file
		TS_ASSERT_EQUALS( false, $deps->isnewest( "data/nofile", $source ) );
		
		//without deps - failed
		TS_ASSERT_EQUALS( false, $deps->isnewest( $target, $source ) );

		//make deps
		$deps->mkdeps( $target, $source );

		//with deps - newest
		TS_ASSERT_EQUALS( true, $deps->isnewest( $target, $source) );

		//change deps time
		touch( 'data/dep2.xsl', time()+12);

		//deps changed
		TS_ASSERT_EQUALS( false, $deps->isnewest( $target, $source ) );
	}

	
	function test_primary_source_changed()
	{
		$deps = new DepsBuilder();

		$target = 'data/target.cxsl';
		$source = 'data/source.xsl';

		//no target file - need build
		TS_ASSERT_EQUALS( true, $deps->isnewest( "data/nofile", $source ) );
		
		//without deps - need build
		TS_ASSERT_EQUALS( true, $deps->isnewest( $target, $source ) );

		//make deps
		$deps->mkdeps( $target, $source );

		//with deps - newest
		TS_ASSERT_EQUALS( true, $deps->isnewest( $target, $source) );

		//change deps time
		touch( $source, time()+12);

		//deps changed
		TS_ASSERT_EQUALS( true, $deps->isnewest( $target, $source ) );
	}
}
?>