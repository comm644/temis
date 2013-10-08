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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gen="gen.dtd"
  version="1.0">


  <!-- strip { } -->
  <xsl:template match="@*|node()|text()" mode="gen:strip-braces">
    <xsl:variable name="text" select="."/>
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( substring-after( $text, '{'), '}')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@*|node()|text()" mode="gen:replace-braces" name="gen:replace-braces">
    <xsl:param name="text" select="."/>
    
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( $text, '{')"/>

        <xsl:variable name="after" select="substring-after( $text, '{')"/>
        <xsl:element name="xsl:value-of">
          <xsl:attribute name="select">
            <xsl:value-of select="substring-before( $after, '}')"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:call-template name="gen:replace-braces">
          <xsl:with-param name="text" select="substring-after( $text, '}')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
