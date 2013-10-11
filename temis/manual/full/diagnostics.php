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
$TEMIS_SAVE_COMPILED_TEMPLATE=true;

function xml_highlight($s)
 {        
     $s = htmlspecialchars($s);
     $s = preg_replace("#&lt;([/]*?)(.*)([\s]*?)&gt;#sU",
         "<font color=\"#0000FF\">&lt;\\1\\2\\3&gt;</font>",$s);
     $s = preg_replace("#&lt;([\?])(.*)([\?])&gt;#sU",
         "<font color=\"#800000\">&lt;\\1\\2\\3&gt;</font>",$s);
     $s = preg_replace("#&lt;([^\s\?/=])(.*)([\[\s/]|&gt;)#iU",
         "&lt;<font color=\"#808000\">\\1\\2</font>\\3",$s);
     $s = preg_replace("#&lt;([/])([^\s]*?)([\s\]]*?)&gt;#iU",
         "&lt;\\1<font color=\"#808000\">\\2</font>\\3&gt;",$s);
     $s = preg_replace("#([^\s]*?)\=(&quot;|')(.*)(&quot;|')#isU",
         "<font color=\"#800080\">\\1</font>=<font color=\"#FF00FF\">\\2\\3\\4</font>",$s);
     $s = preg_replace("#&lt;(.*)(\[)(.*)(\])&gt;#isU",
         "&lt;\\1<font color=\"#800080\">\\2\\3\\4</font>&gt;",$s);
     return $s;
 }
 
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
		$page->template = "*skipped*";

		$content = Diag::dump( $this );
		$code    = highlight_file ( TemisTemplate::getCodeFile() , true);

		$page->content = $content;
		$page->code = $code;
		$page->template = xml_highlight( file_get_contents( $page->getTemplateName()) );
	}
}

?>