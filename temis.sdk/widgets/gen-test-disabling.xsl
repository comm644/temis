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
     
     template provide incapsulating disablity check
     
     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  version="1.0">

  <xsl:template match="/widget/*" mode="gen:test-disabling">
    <xsl:variable name="code">
      <xsl:if test="/object/disabled='1'">
        <xsl:attribute name="disabled">1</xsl:attribute>
      </xsl:if>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </xsl:when>
      <xsl:when test="$enable-test-disabled='yes'">
        <xsl:copy-of select="$code"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- nothing todo -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
