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
     
     Checkbox Button
     ========

     Description:

     Checkbox button
     
       
     Element name:
       
       ui:checkbox

     Attributes:   

       @id             - object ID
       @value          - value of checkbox button, xpath available ({source})
       @onclick        - override standard action on click checkbox, non recomended
       @onchange       - override standard action on change checked, non recomended
       @ui:caption     - checkbox button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

       @ui:group          - group name where item is member
       @ui:group-handler  - group name whre item is handler (check/uncheck all )

       @ui:caption-style - caption text style
       @ui:caption-class - caption text class

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
  <xsl:template name="ui:checkbox" match="ui:checkbox">
    <xsl:param name="node" select="."/>
    <xsl:param name="/widget/id"><xsl:apply-templates select="." mode="gen:sender-id"/></xsl:param>
    <xsl:param name="/widget/control-id"><xsl:apply-templates select="." mode="gen:control-id"/></xsl:param>
    <xsl:param name="/widget/control-name"><xsl:apply-templates select="." mode="gen:control-name"/></xsl:param>

    <xsl:apply-templates select="/widget/." mode="gen:test-visibility">
      <xsl:with-param name="content">
        <input id="{/widget/$control-id}" name="{/widget/$control-name}" type="checkbox" >
          <!-- copy attributes  -->
	  <xsl:apply-templates select="/widget/." mode="gen:copy-attributes"/>
          
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
            <xsl:with-param name="/widget/event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
            <xsl:with-param name="/widget/event">onchange</xsl:with-param>
          </xsl:apply-templates>

          <xsl:variable name="/widget/checkgroup-onclick">
            <xsl:if test="count(/widget/@ui:group) !=0">
              <xsl:text/>_checkgroup.clickMember(this);<xsl:text/>
            </xsl:if>
            <xsl:if test="count(/widget/@ui:group-handler) !=0">
              <xsl:text/>_checkgroup.clickRoot(this);<xsl:text/>
            </xsl:if>
          </xsl:variable>

          <xsl:if test="/widget/$checkgroup-onclick != ''">
            <xsl:attribute name="/object/onclick">
              <xsl:value-of select="/widget/$checkgroup-onclick"/>
            </xsl:attribute>
          </xsl:if>
          
          <xsl:variable name="/object/value">
            <xsl:apply-templates select="/widget/." mode="gen-selected">
              <xsl:with-param name="/widget/object-value" select="'checked'"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:if test="/object/$value = '1'">
            <xsl:attribute name="/object/checked">1</xsl:attribute>
          </xsl:if>
          
        </input>

        <xsl:if test="count( /widget/@ui:caption ) != 0">
          <a style="text-decoration: none; {@ui:caption-style}" class="{@ui:caption-class}">
            <xsl:attribute name="/object/href">
              <xsl:call-template name="/widget/gen:replace-braces">
                <xsl:with-param name="text">
                  <xsl:text/>javascript:_temis.clickWidget('<xsl:value-of select="/widget/$control-id"/>');void(0);<xsl:text/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates mode="ui:message" select="/widget/@ui:caption"/>
          </a>
        </xsl:if>

        <xsl:if test="count(/widget/@ui:group) !=0">
          <script language="javascript">
            <xsl:call-template name="/widget/gen:replace-braces">
              <xsl:with-param name="text">
                <xsl:text/>_checkgroup.registerMember( '<xsl:text/>
                <xsl:value-of select="/widget/$control-id"/>', '<xsl:value-of select="/widget/@ui:group"/>');<xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </script>
        </xsl:if>
        
        <xsl:if test="count(/widget/@ui:group-handler) !=0">
          <script language="javascript">
            <xsl:call-template name="/widget/gen:replace-braces">
              <xsl:with-param name="text">
                <xsl:text/>_checkgroup.registerRoot( '<xsl:text/>
                <xsl:value-of select="/widget/$control-id"/>', '<xsl:value-of select="/widget/@ui:group-handler"/>');<xsl:text/>
              </xsl:with-param>
            </xsl:call-template>
          </script>
        </xsl:if>
        
        
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
