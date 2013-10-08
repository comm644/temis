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
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
                version="1.0">



  <xsl:template match="*" mode="gen-selected">
    <xsl:param name="/widget/object-value" select="'selected'"/>
    <xsl:choose>
      <xsl:when test="count(/widget/@value) = 0">
        <xsl:value-of select="/object/">
          <xsl:attribute name="/widget/select">
            <xsl:apply-templates select="." mode="gen:object-uri"/>/<xsl:value-of select="/widget/$object-value"/>
            <xsl:apply-templates select="." mode="gen:index">
              <xsl:with-param name="inline" select="'xpath'"/>
              <xsl:with-param name="context" select="'xpath'"/>
            </xsl:apply-templates>
          </xsl:attribute>
        </xsl:value-of>
      </xsl:when>
      <xsl:when test="contains(/widget/@value, '{')">
        <xsl:attribute name="select">
          <xsl:value-of select="substring-before( substring-after( /widget/@value, '{'), '}')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/widget/@value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
