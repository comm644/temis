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
                version="1.0">

  <xsl:template name="str-replace">
    <xsl:param name="search"/>
    <xsl:param name="replace"/>
    <xsl:param name="subject"/>
      
    <xsl:choose>
      <xsl:when test="contains($subject,$search)">
        <xsl:value-of select="substring-before($subject,$search)"/>
        <xsl:copy-of select="$replace"/>
        <xsl:call-template name="str-replace">
          <xsl:with-param name="search" select="$search"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="subject" select="substring-after($subject,$search)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$subject"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="str-remove">
    <xsl:param name="search"/>
    <xsl:param name="subject"/>

    <xsl:call-template name="str-replace">
      <xsl:with-param name="search" select="$search"/>
      <xsl:with-param name="subject" select="."/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
