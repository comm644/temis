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
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  xmlns:gen="gen.dtd"
  xmlns:xitec="xitec.dtd"
  exclude-result-prefixes="ui gen xitec"
  version="1.0">


  <!-- XSL copier -->



  <!-- process includes -->
  <xsl:template match="xsl:include">
    <xsl:variable name="doc" select="document( current()/@href )"/>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:include' ]"/>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:variable' ]"/>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:template' ]"/>
    <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'ui:panel' ]"/>
  </xsl:template>

  <!-- process body  -->
  <xsl:template match="body">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="count( @ui:manual-control ) = 0 or @manual-control = 'no'">
          <xsl:call-template name="gen:newline"/>
          <form onsubmit="return _temis.submit();" name="_main" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
            <xsl:call-template name="ui:sys-script"/>
            <xsl:call-template name="ui:sys-values"/>
            <xsl:apply-templates select="node()"/>
          </form>
        </xsl:when>
        <xsl:when test="@ui:manual-control = 'yes'">
          <xsl:apply-templates select="node()"/>
        </xsl:when>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- /XSL copier -->


  <!-- insert user-side script -->
  <xsl:template match="ui:sys-script" name="ui:sys-script">
    <script language="javascript" src="{$JSDIR}/temis.js"/>
  </xsl:template>


  <!-- insert user-side values  -->
  <xsl:template match="ui:sys-values" name="ui:sys-values">
    <input type="hidden" name="__postback" value="0"/>
    <input type="hidden" name="__action" value=""/>
    <input type="hidden" name="__value" value=""/>
    <input type="hidden" name="__viewstate">
      <xsl:attribute name="/object/value"><xsl:value-of select="/object/viewstate"/></xsl:attribute>
    </input>
    <input type="hidden" name="__selfurl" >
      <xsl:attribute name="/object/value"><xsl:value-of select="/object/url"/></xsl:attribute>
    </input>
  </xsl:template>

</xsl:stylesheet>
