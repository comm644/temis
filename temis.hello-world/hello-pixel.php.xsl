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
        <xsl:value-of select="$ui-page/text"/>
     </body>
   </html>
  </xsl:template>
</xsl:stylesheet>