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
$TEMIS_SAVE_COMPILED_TEMPLATE=true;

class Diag
{
	function dump( $var )
	{
		ob_start();
		print_r($var);
		$content = ob_get_contents();
		ob_clean();
		return $content;
	}
	
	function update( $page )
	{
		$page->content="*skipped*";
		$page->code = "*skipped*";

		$content = Diag::dump( $this );
		$code    = highlight_file ( TemisTemplate::getCodeFile() , true);

		$page->content = $content;
		$page->code = $code;
	}
}

?>