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
<!--

     This file contains all templates to switching and processing WIDGET instructions
     
     -->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xitec="xitec.dtd"
  version="1.0">

  <xsl:output method="xml"/>

  <!-- switch from DOC to WIDGET -->
  <xsl:template match="*[contains(name(),'xsl:')
                       and ( contains( @test,'/widget/')
                       or contains( @name,'/widget/')
                       or contains( @match,'/widget/')
                       or contains( @select,'/widget/') )]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>

  <xsl:template match="xsl:choose[contains( child::xsl:when/@test,'/widget/')]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>

  <xsl:template match="node()[contains(@*,'/widget/')]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>

  <!-- switch from GEN to WIDGET -->
  <xsl:template mode="gen" match="*[contains(name(),'xsl:')
                       and ( contains( @test,'/widget/')
                       or contains( @name,'/widget/')
                       or contains( @match,'/widget/')
                       or contains( @select,'/widget/') )]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>

  <xsl:template mode="gen" match="xsl:choose[contains( child::xsl:when/@test,'/widget/')]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>
  
  <xsl:template mode="gen" match="node()[
                                  not(contains(name(),'xsl:'))
                                  and contains(@*,'/widget/')]">
    <xsl:apply-templates select="." mode="widget"/>
  </xsl:template>

  <!--  mode widget -->
  <xsl:template match="text()" mode="widget">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:apply-templates select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xsl:text" mode="widget">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>

  
  <xsl:template match="node()" mode="widget">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="widget"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- remove /widget/  substring -->
  <xsl:template match="@*" mode="widget">
    <xsl:attribute name="{name()}">
      <xsl:call-template name="str-replace">
        <xsl:with-param name="search">/widget/</xsl:with-param>
        <xsl:with-param name="replace"/>
        <xsl:with-param name="subject" select="."/>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>

  
</xsl:stylesheet>
