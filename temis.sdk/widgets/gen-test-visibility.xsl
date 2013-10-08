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
     
     template provide incapsulating visibility check
     
     -->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  version="1.0">

  <xsl:template match="*" mode="gen:test-visibility">
    <xsl:param name="content"/>
    
    <xsl:variable name="code">
      <xsl:if test="/object/visible = '1'">
        <xsl:call-template name="/widget/gen:newline"/>
        <xsl:copy-of select="/widget/$content"/>
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
      <!-- optimization for item -->
      <xsl:when test="@ui:visibility = '1' or @ui:visibility = 'yes' ">
        <xsl:copy-of select="$content"/>
      </xsl:when>

      <xsl:when test="@ui:visibility = '0' or @ui:visibility = 'no' ">
      </xsl:when>

      <xsl:when test="@ui:visibility = 'test'">
        <xsl:copy-of select="$code"/>
      </xsl:when>

      <xsl:when test="$enable-test-visibility='yes'">
        <xsl:copy-of select="$code"/>
      </xsl:when>

      <xsl:when test="$enable-test-visibility='test'">
        <xsl:choose>
          <xsl:when test="/object///ui:options/$enable-test-visibility = 'yes'">
            <xsl:copy-of select="$code"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$content"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- invalid value -->
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
