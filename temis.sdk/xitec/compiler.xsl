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
     Temis.Xitec
     ===============
     
    Xml wIdget Template compiler:  
    
    Compiler uses very simplest way.

    If you have using in XSLT expressions xpath for retriveing WIDGET information
    begins from '/widget/'  (for example:  /widget/@attribute)
    then comiler switches to WIDGET mode and performs copying your
    template code into output template

    If you have using xpath for getting OBJECT information then compiler
    switches to GEN (generation) mode and performs generating instruction
    for creating your code in target template

    If you have using instructions without using address /widget/ or /object/
    then compiler performs transformations according to current mode.
    
    Compiler performs tesing only @test, @select and @name tags of XSLT instructions

    Run:
    xsltproc compiler.xsl readme.xsl

       
     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xitec="xitec.dtd"
  version="1.0">

  
  <xsl:output method="xml"
    encoding="utf-8"
    
    />

  <xsl:include href="str-replace.xsl"/>

  <xsl:variable name="result-readable">yes</xsl:variable>
  <xsl:variable name="gen-readable">no</xsl:variable>
  
  <!-- compile template -->
  
  <xsl:include href="mode-doc.xsl"/>
  <xsl:include href="mode-gen.xsl"/>
  <xsl:include href="mode-widget.xsl"/>

  <xsl:include href="insert-vars.xsl"/>
  <xsl:include href="gen-macro.xsl"/>

  <xsl:template name="newline">
<xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="xitec:switch-mode" >
    <xsl:choose>
      <xsl:when test="@mode='widget'">
        <xsl:apply-templates select="child::node()" mode="widget"/>
      </xsl:when>
      <xsl:when test="@mode='object'">
        <xsl:apply-templates select="child::node()" mode="gen"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          unknown xitec-mode <xsl:value-of select="@mode"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xitec:switch-mode" mode="widget">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:template match="xitec:switch-mode" mode="gen">
    <xsl:apply-templates select="."/>
  </xsl:template>


  <!-- print -->
  <xsl:template match="xitec:print-mode" mode="gen">[xitec:mode=object]</xsl:template>
  <xsl:template match="xitec:print-mode" mode="widget">[xitec:mode=widget]</xsl:template>
  <xsl:template match="xitec:print-mode">[xitec:mode=doc]</xsl:template>

  <xsl:template match="xsl:include">
    <xsl:apply-templates select="document(@href)/xsl:stylesheet/*"/>
  </xsl:template>
  
</xsl:stylesheet>
