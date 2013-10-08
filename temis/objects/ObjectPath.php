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
/******************************************************************************
 Copyright (c) 2007 by Alexei V. Vasilyev.  All Rights Reserved.                         
 -----------------------------------------------------------------------------
 Module     : Object Path  (xpath for objects)
 File       : temis-helper.php
 Author     : Alexei V. Vasilyev
 -----------------------------------------------------------------------------
 Description: implements access to object internals via path
******************************************************************************/


  /** ojbect implements paths for accessing in object hierarchy
   */
class ObjectPath
{
	var $separator='/';
	
	function ObjectPath( $separator ='/')
	{
		$this->separator = $separator;
	}

	/** create object hierachy for given path
	 */
	function createObject( $path )
	{
		$leafs = explode($this->separator, $path );
		if ( $leafs[0] == '' ) array_shift( $leafs );
		array_shift( $leafs );
		
		$result = new stdclass;
		$obj = $result;
		foreach( $leafs as $leaf ) {
			$obj->{$leaf} = new stdclass;
			$obj = $obj->{$leaf};
		}
		return $result;
	}

	/** retrieve object from $holder by given path
	 
	@returns  object if exists or null
	 */
	function getObject( $path, &$holder )
	{
		$leafs = explode($this->separator, $path );
		if ( $leafs[0] == '' ) array_shift( $leafs );
		array_shift( $leafs );

		$target = $holder;
		foreach( $leafs as $leaf ) {
			$target = $target->{$leaf};
			if ( $target === null ) return null;
		}
		return $target;
	}

	/** set object $child to node specified by $path in object $holder

	@param path  path to new object
	@param holder  owner object
	@param child   new child object
	 */
	function setObject( $path, &$holder, &$child )
	{
		$leafs = explode($this->separator, $path );
		if ( $leafs[0] == '' ) array_shift( $leafs );
		array_shift( $leafs );
		$childName = array_pop( $leafs );

		$target = $holder;
		foreach( $leafs as $leaf ) {
			if ( $target === null ) { //create new leaf if not exists
				$target = new stdclass;
				$target->{$leaf} = new stdclass;
			}
			$target = $target->{$leaf};
		}
		$target->{$childName} = $child;
		return $target;
	}
}

?>