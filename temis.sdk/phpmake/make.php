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
?>
<?php


if (!function_exists('fnmatch')) {
	function fnmatch($pattern, $string) {
		return @preg_match('/^' . strtr(addcslashes($pattern, '\\.+^$(){}=!<>|'), array('*' => '.*', '?' => '.?')) . '$/i', $string);
	}
}

class task
{
	var $target="";
	function task( $target="" ) { $this->target = $target; }
	function target() {return $this->target; }
	function deps(){ return array(); }
	function execute( $target, $deps ){}
	function isphony() { return false; }
}
define( "CLASS_task", get_Class( new task() ));

class utils
{
	static function getfiles( $mask )
	{
		$dirname = dirname( $mask );
		$basename = basename( $mask );

		$handle = opendir( $dirname );
		if (!$handle) return array();

		$result = array();
		while (false !== ($file = readdir($handle))) {
			if ( !fnmatch( $basename, $file ) ) continue;
			$result[] = realpath( $dirname . "/" . $file );
		}
		closedir($handle);
		return $result;
	}
}

class make
{
	var $level = 0;
	var $isdebug = true;
	
	function make()
	{
		clearstatcache();
	}
	
	function build( $basetime, $target )
	{
		$str = $this->file( $target );
		$this->debug ( "+++ [{$this->level}] build: $str\n" );
		$this->level++;

		$isphony  = $this->isphony($target);
		$isexists = $this->exists($target);
		$deps     = $this->deps( $target );
		$time     = $this->time( $target);
		
		$changed = false;
		if ( $this->havedeps( $target ) ) {
			foreach( $deps as $dep ) {
				$changed |= $this->build( $time, $dep );
			}
		}
		
		if ( !$isphony ) {
			$changed |= !$isexists;

			if ( $isexists && $basetime != 0) {
				$changed |= $time > $basetime;
			}
		}
		
		if ( $changed || $isphony) {
			$this->runtask( $target, $deps);
		}

		$this->level--;
		$this->debug( "--- [{$this->level}] build: $str changed={$changed}\n" );
		return $changed;
	}

	function file( $target )    { return is_object( $target ) ? $target->target() : $target; }
	function havedeps( $target ){ return is_object( $target ) ? count( $target->deps() ) != 0 : false; }
	function deps( $target )
	{
		if ( !is_object( $target ) ) return array();
		$deps = $target->deps();
		if ( !is_array( $deps ) ) $deps = array( $deps );
		return $deps;
	}
	function time( $target )    { return $this->exists( $target ) ? filemtime( $this->file( $target ) ) : 0;}
	function exists( $target )  { return file_exists( $this->file( $target ) );}
	function runtask( $target, $deps ) { if ( is_object( $target ) ) $target->execute( $target, $deps );	}
	function isphony( $target ) { return is_object( $target ) ? $target->isphony() : false;}
	

	function usage()
	{
		$tasks = $this->tasks();
		echo "Availalble next targets:\n\t" . implode( "\n\t", array_keys( $tasks ) ) ."\n";
	}
	function tasks()
	{
		$tasks = array();

		foreach( get_declared_classes() as $cls ) {

			if ( get_parent_Class( $cls ) != CLASS_task ) continue;
			$obj = new $cls( $cls );
			$tasks[$obj->target()] = $obj;
		}
		return( $tasks );
	}
	
	function run( $targets, $isdebug=false )
	{
		$this->isdebug = $isdebug;
		if ( !is_array( $targets ) ) $targets  = array( $targets );
		
		$rc = false;
		$tasks = $this->tasks();
		foreach( $targets as $target ) {
			$rc |= $this->build( 0, $tasks[$target] );
		}
		
		if ( $rc == false ) {
			echo "Nothing to do\n";
		}
		else {
			echo "up to date\n";
		}
	}

	function debug( $str )
	{
		if ( $this->isdebug ) echo $str;
	}


	static function main($default="all")
	{
		$make = new make();
			
		$argc = $_SERVER["argc"];
		$argv = $_SERVER["argv"];
		
		if ( $argc == 0 ) {
			$make->run($default);
		}
		else if ( $argc == 1 ) {
			$make->run($default);
		}
		else {
			if ( in_array( "--help", $argv ) ) return $make->usage();
			
			for( $i=1; $i<$argc; $i++) {
				$make->run( $argv[$i] );
			}
		}
	}
}

?>