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
  version="1.0">


  <xsl:template match="*" mode="gen:object-id">
    <xsl:param name="id" select="@id"/>
    <xsl:param name="inline">no</xsl:param>
    <xsl:param name="context">id</xsl:param>

    <xsl:variable name="page-address">
      <xsl:choose>
        <xsl:when test="$address != $realaddress">
          <xsl:choose>
            <xsl:when test="starts-with($realaddress,'/root/')">
              <xsl:value-of select="substring-after($realaddress,'/root/')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        
        <xsl:when test="starts-with($address,'/root/')">
          <xsl:value-of select="substring-after($address,'/root/')"/>
        </xsl:when>
        <xsl:when test="starts-with($address,'/ajax/')">
          <xsl:value-of select="substring-after($address,'/ajax/')"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="full-address">
      <xsl:value-of select="$page-address"/>
      <xsl:if test="$id != ''">
        <xsl:text/>/<xsl:value-of select="$id"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="str-replace">
      <xsl:with-param name="search">/</xsl:with-param>
      <xsl:with-param name="replace">--</xsl:with-param>
      <xsl:with-param name="subject" select="$full-address"/>
    </xsl:call-template>
    <!--
    <xsl:value-of select="translate( $full-address, '/', '-' )"/>
    -->
 
    <xsl:apply-templates select="." mode="gen:index">
      <xsl:with-param name="inline" select="$inline"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
 
  </xsl:template>

  <!-- standard use cases -->

  <!-- ID for usgin in Event -->
  <xsl:template match="*" mode="gen:sender-id">
    <xsl:apply-templates select="." mode="gen:object-id">
      <xsl:with-param name="context">event</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- object ID for using in element ID -->
  <xsl:template match="*" mode="gen:control-id">
    <xsl:apply-templates select="." mode="gen:object-id">
      <xsl:with-param name="inline">yes</xsl:with-param>
      <xsl:with-param name="context">id</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- object ID for using in element NAME -->
  <xsl:template match="*" mode="gen:control-name">
    <xsl:apply-templates select="." mode="gen:object-id">
      <xsl:with-param name="inline">yes</xsl:with-param>
      <xsl:with-param name="context">name</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
</xsl:stylesheet>
