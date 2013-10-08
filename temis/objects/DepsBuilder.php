<?php

define( "DEPS_COMPILER", dirname( __FILE__ ) . "/mkdeps.xsl" );
require_once( dirname( __FILE__ ) . "/../../xml/xslt.php" );

class DepsBuilder
{
	function getProcessor()
	{
		$class = TEMIS_XSLT_ENGINE;
		return new $class();
	}

	function throwError( $msg )
	{
		trigger_error("TEMIS Error: " . $msg, E_USER_ERROR);
		exit;
	}

	function getDepsFile( $target )
	{
		return "{$target}.deps";
	}
			

	function mkdeps( $target, $source )
	{
		$outfile = $this->getDepsFile($target);
		
		if ( !file_exists( DEPS_COMPILER ) ) $this->throwError( "can't find coompiler file $uiGenerator");
		
		$proc = $this->getProcessor();
		$proc->openXSLT( DEPS_COMPILER );

		$sourceXml = $proc->loadxml( $source );
		if ( $sourceXml == null ) $this->throwError( "can't load source XML $templateName");

		$result = $proc->transform( $sourceXml );
		if ( !$result )  $this->throwError( "XSLT error");


		if( file_exists( $outfile ) ) unlink( $outfile );
		$text = $proc->getHTML( $result );

		$text = preg_replace('/[\w.]+\/\.\.\//', '', $text);

		file_put_contents( $outfile,$text );


	}


	/**  Check that destination file is newest. 

	  @return  bool false if :
  	  \li  destination does not exists
	  \li  source is newest then destination
	  \li  any dependence is newes then destination file
	 */
	function isnewest( $target, $source )
	{
		if ( !file_exists( $target ) ) return false;
		
		$basedir = dirname( $source );
		$targetTime = filemtime( $target );
		
		$depsFile = $this->getDepsFile( $target );

		if ( !file_exists( $depsFile ) ) return false;
		
		if ( $targetTime < filemtime( $source ) ) return false;
		include( $depsFile );

		$here = $basedir;
		$paths = array( $basedir => $basedir);

		foreach( $deps as $dep ) {
                    if ( !$dep ) {
                        continue;
                    }

					$filename = $basedir . "/" .$dep;

                    //echo sprintf( "%d < %d = %d:  %s < %s\n", $targetTime, filemtime( $basedir ."/". $dep ), $targetTime < filemtime( $basedir ."/". $dep ), $target, $basedir ."/". $dep );
					if ( $targetTime < filemtime( $filename ) ) return false;
		}
		return true;
	}
}

?>