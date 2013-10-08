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
  xmlns:macro="macros.dtd"
  version="1.0">

  <xsl:output method="xml"/>

  <xsl:template match="macro:insert">
    <xsl:variable  name="name" select="@name"/>
    <xsl:variable  name="file">
      <xsl:choose>
        <xsl:when test="count(@file)=0">macros.xsl</xsl:when>
        <xsl:otherwise><xsl:value-of select="@file"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="document($file)//xsl:template[@name=$name]/*" mode="widget"/>
  </xsl:template>

  <xsl:template match="macro:as-object">
    <xsl:apply-templates select="*" mode="gen"/>
  </xsl:template>

  <xsl:template match="macro:as-widget">
    <xsl:apply-templates select="*" mode="widget"/>
  </xsl:template>

</xsl:stylesheet>
