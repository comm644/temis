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
  xmlns:xitec="xitec.dtd"
                version="1.0">

  <xsl:output method="html"/>

  
  <xsl:template match="/">

    Widget Template compiler:  Temis.Xitec
    
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

    <xsl:call-template name="/widget/demo"/>

    <xsl:apply-templates select="/widget/." mode="samples"/>
    <xsl:apply-templates select="/object/." mode="samples"/>

  </xsl:template>


  <xsl:template name="demo">
    <!-- demo -->

    <!-- will be copied -->
    <div id="div1">
      <!-- will be copied -->
      <xsl:if test="/widget/value">
        <!-- will be copied -->
        <xsl:attribute name="style">border: thin solid black;</xsl:attribute>

        <!-- will be copied -->
        <div id="div2">

          <!-- will be generated -->
          <xsl:if test="/object/value">

            <!-- will be generated -->
            <div id="{/object/@id}"/>

            <!-- will be generated -->
            <div id="{@id}"/>
            
            <!-- will be generated -->
            <xsl:attribute name="value">caption</xsl:attribute>
            
            <!-- will be copied -->
            <div id="{/widget/@id}"/>

            <!-- will be copied -->
            <xsl:if test="/widget/value">

              <!-- will be copied -->
              <xsl:attribute name="style">width:200px;</xsl:attribute>
            </xsl:if>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
    <!-- /demo -->
  </xsl:template>

  <xsl:template match="/widget/*" mode="samples">
    
    <!-- How it's works.  Tests here. -->
    
    <!-- widget commands -->
    <!-- should be generated as is but without /widget/ -->
    
    <xsl:include href="incfile.xsl"/>

    <xsl:variable name="var2" select="value"/>
    <xsl:variable name="var1" select="/widget/value"/>

    <xsl:value-of select="value"/>
    <xsl:value-of select="/widget/value"/>

    <xsl:copy-of select="value"/>
    <xsl:copy-of select="/widget/value"/>
    
    <xsl:if test="/widget/value">
      if code
    </xsl:if>

    <xsl:choose>
      <xsl:when test="/widget/value">
        when code
        <element/>
      </xsl:when>
      <xsl:otherwise>
        otherwise code
        <element/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="/"/>
    <xsl:apply-templates select="/widget/value"/>
    <xsl:apply-templates select="/widget/value">
      <xsl:with-param name="/widget/name">
        <!-- should be copied -->
        <element attr="{/widget/attr}"/>
        <!-- should be translated  -->
        <element attr="{/object/attr}"/>
      </xsl:with-param>
    </xsl:apply-templates>

    <xsl:for-each select="value">
      foreach code
      <element/>
    </xsl:for-each>


    <xsl:for-each select="/widget/value">
      foreach code
      <element/>
    </xsl:for-each>

    <xsl:if test="/widget/value">
      <xsl:attribute name="attr">inline attr value</xsl:attribute>
      <xsl:element name="element">inline element value</xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/object/*" mode="samples">
    <!-- result commands -->
    <!-- all xsl commands shoud be converted to instruction for creating these commands-->
    
    <xsl:variable name="var1" select="/object/value"/>

    <xsl:if test="/object/value">
      if code
      <element/>
    </xsl:if>

    <xsl:if test="/object/value">
      if code
      <element>
        <xsl:attribute name="attr">value</xsl:attribute>
      </element>
    </xsl:if>
    
    <xsl:choose>
      <xsl:when test="/object/value">
        when code
        <element/>
      </xsl:when>
      <xsl:otherwise>
        otherwise code
        <element/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="/object/value"/>

    <xsl:for-each select="/object/value">
      foreach code
      <element/>
    </xsl:for-each>

    <xsl:if test="/object/value">
      <xsl:attribute name="attr">result  attr value</xsl:attribute>
      <xsl:element name="element">result element value</xsl:element>
    </xsl:if>
    
    <element>
      <p>will be generated</p>
      <xsl:attribute name="/object/attr">value</xsl:attribute>
    </element>

    <element>
      will be copied
      <xsl:attribute name="/widget/attr">value</xsl:attribute>
    </element>

    <xitec:switch-mode mode="object">
      will be generated
      <xsl:element/>
    </xitec:switch-mode>

    <xitec:print-mode/>
    
    <xitec:switch-mode mode="widget">
      will be copied
      <xsl:element/>
    </xitec:switch-mode>

  </xsl:template>

</xsl:stylesheet>
