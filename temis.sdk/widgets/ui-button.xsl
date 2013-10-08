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
     
     Button
     ========

     Description:

     Simple button
     
       
     Element name:
       
       ui:button

     Attributes:   

       @id             - object ID
       @value          - button caption (not recommended)
       @type           = (submit)|(button)  - type of button
       @onclick        - override standard action, non recomended
       @ui:caption     - button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

       another HTML attrbutes is available
       
     Inner text:

       same as @ui:caption (not recommended)
       
         />
         
     -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gen="gen.dtd"
  xmlns:ui="ui.dtd"
                version="1.0">


  <xsl:template match="ui:button">
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

        <xsl:if test="/widget/@type = 'submit'">
          <script language='JavaScript'>
            <xsl:text>_temis.setDefaultAction( </xsl:text>
            <xsl:apply-templates select="." mode="gen:create-event">
              <xsl:with-param name="event" select="'onclick'"/>
            </xsl:apply-templates>
            <xsl:text>);</xsl:text>
          </script>
        </xsl:if>


        <input id="{/widget/$control-id}"  name="{/widget/$control-name}">
          
          <!-- copy attributes  -->
          <xsl:apply-templates select="." mode="gen:copy-attributes"/>
          
          <xsl:if test="count(/widget/@type) = 0">
            <xsl:attribute name="type">button</xsl:attribute>
          </xsl:if>

          <xsl:apply-templates select="/widget/." mode="gen:test-disabling"/>
          <xsl:apply-templates select="/widget/." mode="button-insert-caption"/>

          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="event">onclick</xsl:with-param>
          </xsl:apply-templates>

          
          <!-- insert user code here  -->
          <xsl:apply-templates select="/widget/*"/>

        </input>
        
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="button-insert-caption">
   
    <xsl:choose>
      <xsl:when test="count( /widget/@value ) !=0">
        <!-- already inserted by copier -->
      </xsl:when>

      <xsl:when test="count( /widget/@ui:caption ) !=0">
        <xsl:attribute name="value">
          <xsl:apply-templates mode="ui:message" select="/widget/@ui:caption"/>
        </xsl:attribute>
      </xsl:when>

      <xsl:otherwise>
        
        <!-- use program defined text -->
        <xsl:choose>
          <xsl:when test="/object/text != ''">
            <xsl:attribute name="value">
              <xsl:value-of select="/object/text"/>
            </xsl:attribute>
          </xsl:when>

          <xsl:if test="/widget/$enable-name-as-caption='yes'">
            <xsl:when test="/object/name != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="/widget/$id"/>::<xsl:value-of select="/object/name"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:if>
        </xsl:choose>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>
