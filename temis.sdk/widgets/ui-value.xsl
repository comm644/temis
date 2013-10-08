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
     
     Create value field linked with server value
     ============================================

     Description:

     Value 
     
       
     Element name:
       
       ui:value

     Attributes:   

       @id             - object ID
       @value          - value of field, xpath available ({source})
       @ui:index       - item index if need for multiplicity (for-each)

       another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  exclude-result-prefixes="ui gen"
  version="1.0">

  <!-- UI input text generator -->
  <xsl:template match="ui:value">
    <xsl:param name="/widget/control-id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">id</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>
    
    <xsl:param name="/widget/control-name">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="inline">yes</xsl:with-param>
        <xsl:with-param name="context">name</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>
    
    <input id="{/widget/$control-id}" name="{/widget/$control-name}" type="hidden"  >
      <xsl:variable name="/object/value">
        <xsl:choose>
          <xsl:when test="count(/widget/@value) = 0">
            <xsl:value-of select="/object/value"/>
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
      </xsl:variable>

      <xsl:attribute name="/object/value"><xsl:value-of select="/object/$value"/></xsl:attribute>
    </input>
  </xsl:template>
  

</xsl:stylesheet>
