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

     UI DropDownList
     =================
     
     Description:

     Drop down list 
       
     Element name:
       
       ui:dropdaowlist

     Attributes:   

       @id             - reference to panel  ID
       @ui:index       - item index if need for multiplicity (for-each)

       @ui:items       - xpath to extenal items
       @ui:item-index  - xpath (relative path) to index (key) of extenal item
       @ui:item-value  - xpath (relative path) to value of externl item

     another HTML attrbutes is available
       
     Inner text:

     HTML Tag <option> is available


    PHP Object:  uiDropDownList

    members:

       items -  indexed array where INDEX peresent KEY
                items = array( 0 => "name1", 1 => "name2" );

       selected - array contains selected indexes
                selected = array( 0 );
       
               
    events:
       onchange
       
       -->
  
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes="ui"
  version="1.0">

  <temis:template match="text()|@*|*" mode="gen-select-attr">
    <temis:param name="text" select="."/>

    <temis:attribute name="select">
      <temis:value-of select="substring-before( substring-after( $text, '{'), '}')"/>
    </temis:attribute>
  </temis:template>

  <temis:template match="ui:dropdownlist">

    <temis:if test="count(@ui:items) != 0 and count(@ui:item-index) =0">
      <temis:text>TEMIS XSL Error: Element ID=</temis:text>
      <temis:value-of select="@id"/>
      <temis:text> does not contains @ui:item-index attribute</temis:text>
      <br/>
    </temis:if>
    <temis:if test="count(@ui:items) != 0 and count(@ui:item-value) =0">
      <temis:text>TEMIS XSL Error: Element ID=</temis:text>
      <temis:value-of select="@id"/>
      <temis:text> does not contains @ui:item-value attribute</temis:text>
      <br/>
    </temis:if>


    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>


    <xsl:if test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/@visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>

      <select
             id  ="{{$temis-object/@__name}}{$index-id}"
             name="{{$temis-object/@__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>

        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onclick</temis:with-param>
        </temis:apply-templates>

        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onchange</temis:with-param>
        </temis:apply-templates>

        <xsl:variable name="selected">
          <temis:choose>
            <temis:when test="count(@value) != 0">
              <temis:apply-templates select="@value" mode="gen-index-valueof"/>
            </temis:when>
            <temis:otherwise>
              <temis:attribute name="select">$temis-object/selected</temis:attribute>
            </temis:otherwise>
          </temis:choose>
        </xsl:variable>


        <temis:choose>
          <temis:when test="count(@ui:items) != 0">
            <temis:if test="count(@ui:item-index) !=0 and count(@ui:item-value) !=0">
              <temis:text>
              </temis:text>
              <!-- extern items -->
              <xsl:variable name="items">
                <temis:if test="count(@ui:items) != 0">
                  <temis:apply-templates select="@ui:items" mode="gen-select-attr"/>
                </temis:if>
              </xsl:variable>

              <xsl:for-each select="$items">

                <xsl:variable name="itemid"><temis:apply-templates select="@ui:item-index" mode="gen-select-attr"/></xsl:variable>
                <xsl:variable name="itemvalue"><temis:apply-templates select="@ui:item-value" mode="gen-select-attr"/></xsl:variable>

                <option value="{{$itemid}}">
                  <xsl:if test="$selected = $itemid">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="$itemvalue"/>
                </option>

              </xsl:for-each>

            </temis:if>
          </temis:when>

          <temis:when test="count(child::option) = 0 and count(child::*) = 0">
            <!-- server items -->

            <xsl:for-each select="$temis-object/items/*">
              <option value="{{current()/@index}}">
                <xsl:if test="$selected = current()/@index">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="current()/text()"/>
              </option>
            </xsl:for-each>

          </temis:when>

          <temis:when test="count(child::option) = 0 and count(child::*) != 0">
            <!-- template code -->
            <temis:copy-of select="*"/>
          </temis:when>

          <temis:otherwise>
            <!-- predefined items -->
            <temis:for-each select="option">
              <temis:copy>
                <temis:copy-of select="@*"/>
                <xsl:if test="$selected = '{@value}'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <temis:apply-templates select="node()"/>
              </temis:copy>
            </temis:for-each>
          </temis:otherwise>
        </temis:choose>
      </select>
    </xsl:if>

  </temis:template>

</temis:stylesheet>
