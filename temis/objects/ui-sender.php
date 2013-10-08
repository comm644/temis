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

class Sender
{
	var $sender = null;
	var $object = null;

	function Sender( $sender, &$obj ) {
		$this->sender = $sender;
		$this->object = &$obj;
	}
	function ForwardFrom( $sender )
	{
		//print( "<br>push: " . get_class( $sender ) ."<br>" );
		
		//array_push( $this->stack, $this->sender );
		$this->sender .= ":$sender";
		return( $this );
	}
	function Root()
	{
		return( $this->sender );
	}
}

?>