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
     
     File input control 
     ========

     Description:

     File Input 
     
       
     Element name:
       
       ui:file

     Attributes:   

       @id             - object ID
       @value          - value of textbox button, xpath available ({source})
       @onchange       - override standard action on change
       @ui:caption     - file input button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

     another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen"
  version="1.0">

  <!-- UI button generator -->
  <xsl:template name="ui:file" match="ui:file">
    <xsl:param name="node" select="."/>

    <xsl:param name="/widget/id">
      <xsl:apply-templates select="." mode="gen:object-id">
        <xsl:with-param name="context">event</xsl:with-param>
      </xsl:apply-templates>
    </xsl:param>

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

    <xsl:apply-templates select="/widget/." mode="gen:test-visibility">
      <xsl:with-param name="content">

            <input id="{/widget/$control-id}" name="{/widget/$control-name}" type="file" >
              <xsl:apply-templates select="/widget/." mode="gen:copy-attributes"/>
              
              <xsl:apply-templates select="/widget/." mode="gen:add-handler">
                <xsl:with-param name="/widget/event">onchange</xsl:with-param>
              </xsl:apply-templates>

              <xsl:apply-templates select="." mode="insert-variable-for-value-of"/>
              <xsl:attribute name="/object/value"><xsl:value-of select="/object/$value"/></xsl:attribute>
            </input>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
