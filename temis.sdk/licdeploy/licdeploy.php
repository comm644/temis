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


if (!function_exists('fnmatch')) {
	function fnmatch($pattern, $string) {
		return @preg_match('/^' . strtr(addcslashes($pattern, '\\.+^$(){}=!<>|'), array('*' => '.*', '?' => '.?')) . '$/i', $string);
	}
}

/** class for deployment licence policy to all files
 */
class LicenseDeploy
{

	function LicenseDeploy( $pathToNotice )
	{
		if ( !file_exists( $pathToNotice ) ) {
			trigger_error( "file $pathToNotice not found", E_USER_ERROR );
			return;
		}
		$this->license = file_get_contents( $pathToNotice  );
		
	}
	

	/** this function for adding or updating licence text in specified file
	 
	@param licenceText     licence text
	@param file            file name
	@return   false on success
	*/
	function licdeploy( $licenceText, $file )
	{
		$resultFile = $file;
		
		$content = file_get_contents( $file );
		if ( fnmatch( "*.php", $file) ) {
			preg_match_all( "/(<\?.+?Copyright \(c\).+?WITHOUT WARRANTIES.+?\?>)?(.*)/s",  $content,$parts ); 
			$content = "<?php\r\n/*\n" . $licenceText . "\r\n*/\n?>" . $parts[2][0];
		}
		else if ( fnmatch( "*.xsl",$file ) ) {
			$license = "\r\n<!-- \n" . $licenceText . "\r\n-->";
			preg_match_all( "/(<\?xml.+?\?>)(\r?\n+<\!--.+?WITHOUT WARRANTIES.+?-->)?(.*)/s",  $content,$parts );
			$content = $parts[1][0] . $license . $parts[3][0];
		}
		else {
			return true;
		}
	
		file_put_contents( $resultFile, $content );
		return false;
	}

	function isSupported( $file )
	{
		$supported = array( "*.php", "*.xsl" );

		if ( realpath( $file ) == __FILE__ ) return false; //protect self
		foreach( $supported as $key ) {
			if ( !fnmatch( $key, $file) ) continue;
			return true;
		}
		return false;
	}

	function processFiles( $dir, $level=0 )
	{
		
		if (!is_dir($dir)) return true;
		if ( !($dh = opendir($dir)) ) return true;

	
		while (($file = readdir($dh)) !== false) {
			if ( strpos( $file, "." ) === 0 ) continue; //skip system files
			if ( $file == "redist" ) continue; //skip redistributable files

			$fullname = realpath( $dir . "/" . $file );
			
			if ( is_dir( $fullname ) ) {
				$this->processFiles( $dir ."/" . $file, $level+1 );
				continue;
			}
			if (!$this->isSupported( $fullname ) ) continue;
			
			
			$this->message( "[$level] Processing $fullname.." );
			if ( $this->licdeploy( $this->license, $fullname ) ) {
				$this->message( "FAILED\n" );
			}
			else {
				$this->message( "OK\n" );
			}
		}
		closedir($dh);
	}

	function message( $msg )
	{
		echo $msg;
	}


	function main( $argc, $argv )
	{
		if ( $argc < 2 || $argv[1] == "--help" ) { $this->usage($argv[0]);  return 1; }

		$this->processFiles( $argv[1] );
	}

	function usage($selfname)
	{
		$selfname = basename( $selfname );
		echo "License Deploy: utility for easy license deployment to source files\n"
			."Usage:\n"
			."php $selfname  [--help] <start_directory>\n"
			;
		
	}
}



define( "NOTICE", dirname( __FILE__ ) . "/../../temis/NOTICE" );


//licdeploy( $license, $_SERVER["argv"][1]);

$dep = new LicenseDeploy( NOTICE );
$dep->main( $_SERVER["argc"], $_SERVER["argv"] );


?>