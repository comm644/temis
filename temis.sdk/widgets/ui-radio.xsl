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
     
     Radio Button
     ========

     Description:

     Radio button
     
       
     Element name:
       
       ui:radio

     Attributes:   

       @id             - object ID
       @value          - value of radio button, xpath available ({source})
       @onclick        - override standard action on click radio, non recomended
       @onchange       - override standard action on change checked, non recomended
       @ui:caption     - radio button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)

       @ui:caption-style - caption text style attribute
       @ui:caption-class - caption text class attribute
       @ui:caption-title - caption text title attribute

     another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes="ui"
  version="1.0">

  <!-- UI button generator -->
  <temis:template name="ui:radio" match="ui:radio">
    <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/>-<temis:value-of select="@value"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>



    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/@visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="radio"
             id  ="{{$temis-object/@__name}}{$index-id}"
             name="{{$temis-object/@__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onclick</temis:with-param>
        </temis:apply-templates>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onchange</temis:with-param>
        </temis:apply-templates>

        <temis:choose>
          <temis:when test="contains(@value,'{')">
            <xsl:variable name="checked">
              <temis:apply-templates select="@value" mode="gen-index-valueof"/>
            </xsl:variable>
            <xsl:if test="$checked = '1'">
              <xsl:attribute name="checked">1</xsl:attribute>
            </xsl:if>
          </temis:when>
          <temis:when test="@value = '1'">
            <xsl:attribute name="checked">1</xsl:attribute>
          </temis:when>
          <temis:otherwise>
            <xsl:if test="$temis-object/checked{$index} = '1'">
              <xsl:attribute name="checked">1</xsl:attribute>
            </xsl:if>
          </temis:otherwise>
        </temis:choose>
      </input>

      <temis:if test="count( @ui:caption ) != 0">
        <label id="{{$temis-object/@__name}}{$index-id}-label" for="{{$temis-object/@__name}}{$index-id}"
               style="{@ui:caption-style}" class="{@ui:caption-class}">

          <temis:apply-templates mode="ui:message" select="@ui:caption"/>
        </label>
      </temis:if>

    </xsl:if>
  </temis:template>

</temis:stylesheet>
