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
     
     Text box 
     ========

     Description:

     Text box 
     
       
     Element name:
       
       ui:textbox

     Attributes:   

       @id             - object ID
       @value          - value of textbox button, xpath available ({source})
       @onchange       - override standard action on change
       @ui:caption     - textbox button caption, XPath available
       @ui:target      - action target, by default - page
       @ui:visibility  = (yes)|(no)|(test)  - item visibility sign
       @ui:index       - item index if need for multiplicity (for-each)
       @rows           - number of rows for multiline textbox
       @cols           - number of columns for multiline textbox
       @ui:mode        - (text)|(password)|(multiline)  - textbox mode , (text) by default

     another HTML attrbutes is available
       
     Inner text:
     
       is not used

     -->
<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd" xmlns:Xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    version="1.0">

  <temis:include href="xsl-copier.xsl"/>
  <temis:include href="gen-index.xsl"/>

  <temis:output indent="yes"/>
  <temis:template match="ui:page">
    ---------------
  </temis:template>

  <!-- UI textbox generator -->
  <temis:template match="ui:textbox[@ui:visibility='no']"/>
  <temis:template name="ui:textbox" match="ui:textbox">
    <!--
    1. check hardcoded  visibility
    2. create node
    3. copy HTML attributes to node
    4. call temis runtime

    path:  page/widget/element
    -->
    <temis:variable name="mode">
      <temis:choose>
        <temis:when test="count(@ui:mode ) = 0">text</temis:when>
        <temis:when test="@ui:mode = 'text'">text</temis:when>
        <temis:when test="@ui:mode = 'multiline'">multiline</temis:when>
        <temis:when test="@ui:mode = 'password'">password</temis:when>
        <temis:otherwise>
          <temis:message terminate="yes">
            <temis:text/>Error: Invalid @ui:mode for <temis:copy-of select="."/>
          </temis:message>
        </temis:otherwise>
      </temis:choose>
    </temis:variable>

    <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>


    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <temis:choose>
        <temis:when test="$mode = 'multiline'">
          <textarea
              id  ="{{$temis-object/__name}}{$index-id}"
              name="{{$temis-object/__name}}{$index-name}">

            <temis:apply-templates select="." mode="ui-textbox-content"/>

            <temis:choose>
              <temis:when test="count(@value) = 0">
                <xsl:value-of select="$temis-object/text{$index}"/>
              </temis:when>
              <temis:otherwise>
                <temis:apply-templates select="@value" mode="gen-index-valueof"/>
              </temis:otherwise>
            </temis:choose>
          </textarea>
        </temis:when>
        <temis:otherwise>
          <input type="{$mode}"
                 id  ="{{$temis-object/__name}}{$index-id}"
                 name="{{$temis-object/__name}}{$index-name}">

            <temis:apply-templates select="." mode="ui-textbox-content"/>

            <temis:if test="count(@value) = 0">
              <xsl:attribute name="value">
                <xsl:value-of select="$temis-object/text{$index}"/>
              </xsl:attribute>
            </temis:if>

          </input>
        </temis:otherwise>
      </temis:choose>
    </xsl:if>
  </temis:template>


  <temis:template match="*" mode="ui-textbox-content">
    <temis:apply-templates select="." mode="temis-copy-attributes"/>
    <temis:apply-templates select="." mode="temis-add-handler">
      <temis:with-param name="event">onchange</temis:with-param>
    </temis:apply-templates>
  </temis:template>

</temis:stylesheet>
