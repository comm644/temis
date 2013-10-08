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

class SetupException extends Exception
{
}

/** class provides helper
 for creating setup checking scripts for executing from command line
 and under web server environment

 Main rule: if condition will be failed then installation should be stopped.
 
 */
class Setup
{
	var $_isFailed = false;
	var $_isServerMode = false;

	var $showOnError = false;
	
	function Setup()
	{
		$this->_isServerMode = array_key_exists( "HTTP_HOST", $_SERVER );
	}
	
	
	function showOnError( $sign )
	{
		$this->showOnError = $sign;
	}

	/** return true if last assert() was failed
	 */
	function isFailed()
	{
		return $this->_isFailed;
	}
	function isServerMode()
	{
		return $this->_isServerMode;
	}


	/** environment independen end-of-line
	 */
	function endl()
	{
		return( $this->isServerMode() ? "<br>\n" : "\n" );
	}
	function indent()
	{
		return( $this->isServerMode() ? "<span style='padding-left:50pt;'>&nbsp;</span>" : "\t" );
	}
	function show( $msg )
	{
		if ( $this->isServerMode() ) {
			print "<span class='setup'>$msg</span>";
		}
		else {
			print $msg;
		}
		flush();
	}

	/** environment independen bold font
	 */
	function bold( $msg )
	{
		if ( $this->isServerMode() ) {
			return "<strong>" .$msg."</strong>";
		}
		return $msg;
	}

        /**
         * Show description why assetion failed.
         * 
         * @param string $msg
         */
        function describe( $msg )
        {
		if ( $this->isServerMode() ) {
			return "<em>" .$msg."</em>";
		}
		return $msg;
        }

	/** print message befor testing
	 */
	function start( $msg ){
		$this->_firstLine = true;

		if ( $this->showOnError) {
			ob_start();
		}

		$this->show( $msg . "..." );
		
		if ( $this->showOnError) {
			$this->startmsg = ob_get_clean();
		}
		
	}

	/** print message about Success hould be called after end of operation
	 */
	function ok()
	{
		$this->show( "OK" . $this->endl() );
	}

	/** print message about checking fails
	 */
	function failed() {
		$this->_isFailed = true;
		$this->show( $this->bold("FAILED") . $this->endl() );
	}

	function message( $msg )
	{
		$this->show( $msg  . $this->endl());
	}
	
	/** performs condition assert, print message and stop script execution if failed
	 */
	function assert( $cond, $msg )
	{
		$this->_isFailed |= ($cond != true);
		
		if ( $cond ) {
			return;
		}
		$this->failed();
		$this->triggerError( $msg );
	}

	/** signal about error
	 */
	function triggerError( $msg )
	{
		$this->message( $this->indent() .$msg );
		
		$this->_firstLine = false;

		throw new SetupException( $msg );
		//trigger_error( "Setup error", E_USER_ERROR ); exit;
	}

	/** service method
	 returns real path without using filesystem
	 */
	function get_realpath( $path )
	{
		$result = array();
		$pathA = preg_split('/[\/\\\]/', $path);
		//$pathA = explode('/', $path);
		if (!$pathA[0])
			$result[] = '';
		foreach ($pathA AS $key => $dir) {
			if ($dir == '..') {
				if (end($result) == '..') {
					$result[] = '..';
				} elseif (!array_pop($result)) {
					$result[] = '..';
				}
			} elseif ($dir && $dir != '.') {
				$result[] = $dir;
			}
		}
		if (!end($pathA)) 
			$result[] = '';

		$res = implode('/', $result);
		return $res;;
	}
}

/** class for processing some checkes before setup
 */
class Checking extends Setup
{
	function assert( $cond, $msg)
	{
		$this->_isFailed |= ($cond != true);
		
		if ( $cond ) {
			if ( !$this->showOnError) {
				$this->ok();
			}
			return;
		}
		if ( $this->showOnError) {
			echo $this->startmsg;
		}
		$this->failed();
                $this->message( $this->indent() . $this->describe($msg). (($this->showOnError) ? $this->endl() : '') );
	}
	
	
	/** if $cond is true print OK or message,  without FAILEd because it's DETECTING
	 */
	function detect( $cond )
	{
		if ( $cond ) {
			$this->ok();
			return;
		}
		$this->message( $this->bold( "not detected" ) );
	}
	function triggerError( $msg )
	{
		$this->message( $msg );
	}

	function file_contains( $filename, $expectedContent )
	{
		if ( !file_exists( $filename ) ) return false;
		if ( !is_readable( $filename ) ) return false;
		$content = file_get_contents($filename);
		return strstr( $content, $expectedContent ) !== FALSE;
	}

	function ouput_contains( $cmd, $expectedContent )
	{
		$content="";
		$fd = popen($cmd,"r");
		while (!feof($fd)) $content .= fgets($fd, 4096);
		fclose($fd);
		return strstr( $content, $expectedContent ) !== FALSE;
	}

	function writable_access( $path )
	{
		if ( is_writable( $path) ) return true;
		if ( !file_exists( $path ) && is_writable( dirname( $path ) ) ) return true;
		return false;
	}
	
}
?>