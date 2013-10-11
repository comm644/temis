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
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes="ui"
  version="1.0">

  <!-- UI button generator -->
  <temis:template name="ui:checkbox" match="ui:checkbox">
    <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>



    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="checkbox"
             id  ="{{$temis-object/__name}}{$index-id}"
             name="{{$temis-object/__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onclick</temis:with-param>
        </temis:apply-templates>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onchange</temis:with-param>
        </temis:apply-templates>


        <temis:variable name="checkgroup-onclick">
          <temis:if test="count(@ui:group) !=0">
            <temis:text/>_checkgroup.clickMember(this);<temis:text/>
          </temis:if>
          <temis:if test="count(@ui:group-handler) !=0">
            <temis:text/>_checkgroup.clickRoot(this);<temis:text/>
          </temis:if>
        </temis:variable>

        <temis:if test="$checkgroup-onclick != ''">
          <xsl:attribute name="onclick">
            <temis:value-of select="$checkgroup-onclick"/>
          </xsl:attribute>
        </temis:if>

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
        <label id="{{$temis-object/__name}}{$index-id}-label" for="{{$temis-object/__name}}{$index-id}"
               style="{@ui:caption-style}" class="{@ui:caption-class}">

          <temis:apply-templates mode="ui:message" select="@ui:caption"/>
        </label>
      </temis:if>


      <script>
        <xsl:variable name="temis-object-id">
          <xsl:value-of select="$temis-object/__name"/>
          <temis:if test="count(@ui:index) !=0 ">-</temis:if>
          <temis:apply-templates select="@ui:index" mode="gen-index-valueof"/>
        </xsl:variable>

        <temis:if test="count(@ui:group) != 0">
          <temis:text/>_checkgroup.registerMember( '<xsl:value-of select="$temis-object-id"/>',<temis:text/>
          <temis:text/>'<temis:apply-templates select="@ui:group" mode="gen-index-valueof"/>');<temis:text/>
        </temis:if>

        <temis:if test="count(@ui:group-handler) != 0">
          <temis:text/>_checkgroup.registerRoot( '<xsl:value-of select="$temis-object-id"/>', '<temis:text/>
          <temis:text/><temis:apply-templates select="@ui:group-handler" mode="gen-index-valueof"/>');<temis:text/>
        </temis:if>
      </script>
    </xsl:if>
  </temis:template>

</temis:stylesheet>
