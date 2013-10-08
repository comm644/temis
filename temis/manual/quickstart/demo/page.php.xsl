<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:ui="ui.dtd"
  exclude-result-prefixes = "ui" >

  <xsl:output method="html"/>

  <xsl:preserve-space  elements = "pre" />
  
  <xsl:template match="/">
    <html>
      <head>
        <link rel="stylesheet" type="text/css" href="page.css"/>
      </head>
     <body bgcolor="#FFFFFF" >
       <!-- insert page url here -->
       <div class="center">
         URL: <xsl:value-of select="//page/url" />
       <br/>
       <hr/>
       
       <!-- insert here ui: controls -->
       <!-- see in samples-controls/page1.php.xsl -->
       
       Please enter text: <ui:textbox id="tbText"/><br/>
       Your entered text: <span class="entered"><xsl:value-of select="text"/></span><br/>
       <ui:button id="btnOK" type="submit"/>
       </div>
     </body>
   </html>
  </xsl:template>
</xsl:stylesheet>