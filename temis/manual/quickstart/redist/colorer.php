<?php
/*
		######################## ######################## ######################## ########################
		#                                                                                                 #
		#            HTML and XHTML color highlight code (atributes, values, tags and comments)           #
		#                                                                                                 #
		#                                           VERSION 1.1                                           #
		#                                                                                                 #
		#                                       (c) ROMAN OŽANA 2005                                      #
		#                                                                                                 #
		#                                           CZECH REPUBLIC                                        #
		#                                                                                                 #
		#                         IF YOU WANT USE THIS CODE PLEASE CONNECT AUTHOR, Thank You              #
		#                                                                                                 #
		#                              roman.ozana@sendme.cz, www.nabito.net                              #
		#                                                                                                 #
		#                                        ICQ ( 99950132 )                                         #
		#                                                                                                 #
		#                                                        it was written in www.crimsoneditor.com  #
		######################## ######################## ######################## ########################
(c) 2008 Alexey V .Vasilyev.
     Changed logic for working with multiline tags
		
		
1.	use this stylesheet to highlight HTML code
		
		<style>
			.code
			{
				text-align:left;
				font-size:9px;
				font-family: 'Fixedsys', 'courier new', courier, fixed;s
			}

			.code span.text
			{
				color:#000000;
			}
			
			.code span.comment
			{
				color:#008000;
			}
			
			.code span.tag
			{
				color:#0000BB;
			}
			
			.code span.attribute
			{
				color:#DD0000;
			}
			
			.code span.value
			{
				color:#800080;	
			}
			
			.code span.comment span
			{
				color:#008000;
			}
			</style>
			
2.	to use this class

			<?php
				
				include("./source.php"); //name of file
				
				$htmlfile = join ("", file ("./test.htm")); //load HTML file
				
				$sc = new sourcecode; //create new instance of sourcecode (class)
				
				echo "<p class=\"code\">".$sc->html($htmlfile)."</p>"; //print result
				
			?>

*/
	class sourcecode
	{
		function html($str)
		{
			$str = preg_replace("/(<!--)(.+?)(-->)/", "(%comment_b%)\\2(%comment_e%)", $str);  // Replace COMMENTs
			
			$tag_array = preg_split("/(<.+?>)/", $str, -1, PREG_SPLIT_DELIM_CAPTURE);  // Breake by TAGs to array
			$res = "";

			while (list($ar_counter,$ar_value) = each($tag_array)) // walk array
			{
				//        <TAG ATTRIBUTE="VALUE" />
				//replace <(%tag_b%)TAG(%span_e%) (%attribute_b%)ATTRIBUTE(%span_e%)=(%velue_b%)"VALUE"(%span_e%) />
				$re=array("/(<+)([\/]?)(.+?)(>| [^>]*>)/", "/(\s+\S+)(\s*=\s*)([\"']?)([^\"'>]+)([\"' \n\?>]?)/");
				$replacement=array( "\\1\\2(%tag_b%)\\3(%span_e%)\\4", " (%attribute_b%)\\1(%span_e%)\\2(%value_b%)\\3\\4\\5(%span_e%)");
				$ar_value=preg_replace($re,$replacement,$ar_value); 
				
				$ar_value=htmlspecialchars($ar_value);
						
				$ar_value=str_replace(" ", "&nbsp;", $ar_value);
				$ar_value=str_replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;", $ar_value);
				$ar_value=nl2br($ar_value);
				
				// replace signs (%something%) to span HTML TAGs
				$ar_value=str_replace("(%tag_b%)", "<span class=\"tag\">", $ar_value);
				$ar_value=str_replace("(%value_b%)", "<span class=\"value\">", $ar_value);
				$ar_value=str_replace("(%attribute_b%)", "<span class=\"attribute\">", $ar_value);
				$ar_value=str_replace("(%span_e%)", "</span>", $ar_value);

				// replace signs (%something%) to span HTML TAGs
				$ar_value=str_replace("(%comment_b%)", "<span class=\"comment\">&lt;!--", $ar_value);
				$ar_value=str_replace("(%comment_e%)", "--&gt;</span>", $ar_value);

				$res.=$ar_value;
			}
			return "<span class=\"text\">$res</span>"; // return RESULT close in tags SPAN
		}
	}
?>