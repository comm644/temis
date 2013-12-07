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
<temis:stylesheet xmlns:temis="http://www.w3.org/1999/XSL/Transform"
                  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
                version="1.0">



  <temis:template match="ui:button">
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>

    <temis:variable name="type">
      <temis:choose>
        <temis:when test="count(@type) = 0">button</temis:when>
        <temis:otherwise>submit</temis:otherwise>
      </temis:choose>
    </temis:variable>

    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/@visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
          <input type="{$type}"
                 id  ="{{$temis-object/@__name}}{$index-id}"
                 name="{{$temis-object/@__name}}{$index-name}">

            <temis:apply-templates select="." mode="temis-copy-attributes"/>
            <temis:apply-templates select="." mode="temis-add-handler">
              <temis:with-param name="event">onclick</temis:with-param>
            </temis:apply-templates>

              <temis:apply-templates select="." mode="ui-button-caption"/>

            <!-- insert user code here  -->
            <temis:apply-templates select="*"/>

          </input>
    </xsl:if>
  </temis:template>

  <temis:template match="*" mode="ui-button-caption">

    <temis:choose>
      <temis:when test="count( @value ) != 0">
        <!-- already inserted by copier -->
      </temis:when>

      <temis:when test="count( @ui:caption ) !=0">
        <xsl:attribute name="value">
          <temis:apply-templates mode="ui:message" select="@ui:caption"/>
        </xsl:attribute>
      </temis:when>

      <temis:otherwise>
        <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
        <!-- use program defined text -->
        <xsl:choose>
          <xsl:when test="$temis-object/text{$index} != ''">
            <xsl:attribute name="value">
              <xsl:value-of select="$temis-object/text{$index}"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="value">
              <xsl:value-of select="$temis-object/@__name"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </temis:otherwise>
    </temis:choose>
  </temis:template>

  
</temis:stylesheet>
