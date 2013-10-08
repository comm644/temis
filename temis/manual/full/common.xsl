<?xml version="1.0" encoding="utf-8"?>
<!-- 

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

-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  exclude-result-prefixes="ui gen xsl"
  version="1.0">
  
  <xsl:output method="html"/>

  <xsl:template name="insert-head">
    <head>
      <link rel="stylesheet" type="text/css" href="../demo.css"/>
    </head>
  </xsl:template>

  <xsl:template name="insert-header">
    <a href="../">Back</a>
    <hr/>
  </xsl:template>

  
  <xsl:template name="insert-footer">
    <hr/>
    <h1>Diagnostics</h1>
    <h2>HTML code</h2>

    <script>
      function showHTML()
      {
      var html = document.getElementById( 'html');
      html.innerText = "";
      var content = document.nodeToString( document.documentElement, '' );
      var textNode = document.createTextNode( content );
      html.replaceChild( textNode, html.firstChild);
      }

    </script>
    <input type="button" onclick="showHTML();return true;" value="Show html"/>
      
    <pre id="html">
      HTML 
    </pre>

    <h2>PHP Code </h2>
    <xsl:value-of disable-output-escaping="yes" select="code"/>
    

    
    <h2>Page object</h2>
    <ui:button id="btnSubmit" ui:caption="Post values"/>
    <pre>
      <xsl:value-of select="content"/>
    </pre>
    <script language="javascript" src="../../js/toc.js"/>
    <script>insertTOC();</script>
  </xsl:template>
  
</xsl:stylesheet>
