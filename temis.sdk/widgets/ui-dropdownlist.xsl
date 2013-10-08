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
  
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen xitec"
  version="1.0">

  <xsl:template match="ui:dropdownlist">
    <xsl:param name="/widget/id"><xsl:apply-templates select="." mode="gen:sender-id"/></xsl:param>
    <xsl:param name="/widget/control-id"><xsl:apply-templates select="." mode="gen:control-id"/></xsl:param>
    <xsl:param name="/widget/control-name"><xsl:apply-templates select="." mode="gen:control-name"/></xsl:param>
    
    <xsl:if test="count(/widget/@ui:items) != 0 and count(/widget/@ui:item-index) =0">
      TEMIS XSL Error: Element ID=
      <xsl:value-of select="/widget/@id"/>
      does not contains @ui:item-index attribute
      <br/>
    </xsl:if>
    <xsl:if test="count(/widget/@ui:items) != 0 and count(/widget/@ui:item-value) =0">
      TEMIS XSL Error: Element ID=
      <xsl:value-of select="/widget/@id"/>
      does not contains @ui:item-value attribute
      <br/>
    </xsl:if>

    <xsl:apply-templates select="/widget/." mode="gen:test-visibility">
      <xsl:with-param name="content">
    
        <select id="{/widget/$control-id}" name="{/widget/$control-name}">
          <!-- copy attributes  -->
          <xsl:apply-templates select="." mode="gen:copy-attributes"/>
          
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="/widget/event">onclick</xsl:with-param>
          </xsl:apply-templates>
          <xsl:apply-templates select="/widget/." mode="gen:add-handler">
            <xsl:with-param name="context" select="'event'"/>
            <xsl:with-param name="/widget/event">onchange</xsl:with-param>
          </xsl:apply-templates>

          <xsl:variable name="/object/selected">
            <xsl:apply-templates select="/widget/." mode="gen-selected"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="count(/widget/@ui:items) != 0">
              <xsl:if test="count(/widget/@ui:item-index) !=0 and count(/widget/@ui:item-value) !=0">
                <!-- extern items -->
                <xsl:variable name="/object/items">
                  <xsl:attribute name="/widget/select">
                    <xsl:value-of select="substring-before( substring-after( /widget/@ui:items, '{'), '}')"/>
                  </xsl:attribute>
                </xsl:variable>
                <xsl:for-each select="/object/$items">
                  <xsl:variable name="/object/itemid">
                    <xsl:attribute name="/widget/select">
                      <xsl:value-of select="substring-before( substring-after( /widget/@ui:item-index, '{'), '}')"/>
                    </xsl:attribute>
                  </xsl:variable>
                  <xsl:variable name="/object/itemvalue">
                    <xsl:attribute name="/widget/select">
                      <xsl:value-of select="substring-before( substring-after( /widget/@ui:item-value, '{'), '}')"/>
                    </xsl:attribute>
                  </xsl:variable>
                  
                  <option>
                    <xsl:attribute name="/object/value">
                      <xsl:value-of select="/object/$itemid"/>
                    </xsl:attribute>
                    <xsl:if test="/object/$selected = $itemid">
                      <xsl:attribute name="/object/selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="/object/$itemvalue"/>
                  </option>
                  
                </xsl:for-each>

              </xsl:if>
            </xsl:when>
            <xsl:when test="count(/widget/child::option) = 0 and count(/widget/child::*) = 0">
              <!-- server items -->

              <xsl:for-each select="/object/items/*">
                <option value="{current()/@index}">
                  <xsl:if test="/object/$selected = current()/@index">
                    <xsl:attribute name="/object/selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="current()/text()"/>
                </option>
              </xsl:for-each>
              
            </xsl:when>
            <xsl:when test="count(/widget/child::option) = 0 and count(/widget/child::*) != 0">
              <!-- server items -->
              <xsl:copy-of select="*"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- predefined items -->
              <xsl:for-each select="/widget/option">
                <option>
                  <xsl:copy-of select="@*"/>
                  <xsl:if test="/object/">
                    <xsl:attribute name="/widget/test">$selected = '<xsl:value-of select="/widget/@value"/>'</xsl:attribute>
                    <xsl:attribute name="/object/selected">selected</xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="node()"/>
                </option>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          
          
        </select>

      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
