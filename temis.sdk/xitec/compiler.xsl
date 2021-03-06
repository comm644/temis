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

     This file contains templates for just copying without processing
     
     -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xitec="xitec.dtd"
                version="1.0">

  <xsl:output method="xml"/>

  <!-- document copier

       performs copying any document
       -->


  <xsl:template match="xsl:include">
    <xsl:apply-templates select="document(@href)/xsl:stylesheet/*"/>
  </xsl:template>

  <xsl:template match="xitec:include">
  	<xsl:element name="xsl:include">
    	<xsl:apply-templates select="@*"/>
  	</xsl:element>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="@*|node()|text()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>
  
</xsl:stylesheet>
