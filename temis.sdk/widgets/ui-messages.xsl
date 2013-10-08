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
  xmlns:gen="gen.dtd"
  xmlns:ui="ui.dtd"
                version="1.0">

  <xsl:template match="ui:msg|ui:message" >
    <xsl:apply-templates mode="ui:message" select="@id"/>
  </xsl:template>

  <xsl:template name="ui:msg" >
    <xsl:param name="id"/>
    <xsl:apply-templates mode="ui:message" select="$id"/>
  </xsl:template>
  <xsl:template name="ui:message">
    <xsl:param name="id"/>
    <xsl:apply-templates mode="ui:message" select="$id"/>
  </xsl:template>
  
  <xsl:template match="@*|text()" mode="ui:message">
    <xsl:param name="id" select="."/>
    <xsl:variable name="file" select="//ui:messages/@href"/>
    <xsl:variable name="section" select="//ui:messages/@section"/>

    <xsl:variable name="clean-id"><xsl:apply-templates select="$id" mode="gen:strip-braces"/></xsl:variable>
    <xsl:variable name="document" select="document( $file )"/>
    
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="string( $section ) = ''">
          <xsl:value-of select="$document//*[name() = $clean-id]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$document//*[name() = $section]/*[name() = $clean-id]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$text != ''"><xsl:value-of select="$text"/></xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains($id, '{')">
            <xsl:element name="xsl:value-of">
              <xsl:attribute name="select">
                <xsl:value-of select="$clean-id"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$clean-id"/></xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ui:messages">
  </xsl:template>
  
</xsl:stylesheet>
