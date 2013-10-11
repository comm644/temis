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
<temis:stylesheet
  xmlns:temis="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
  xmlns:ui="ui.dtd"
  exclude-result-prefixes="ui"
  version="1.0">


  <!-- XSL copier -->



  <!-- process includes -->
  <temis:template match="temis:include">
    <temis:variable name="doc" select="document( current()/@href )"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:include' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:variable' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:template' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'ui:panel' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'ui:widget' ]"/>
  </temis:template>

  <!-- process body  -->
  <temis:template match="body">
    <temis:copy>
      <temis:apply-templates select="@*"/>
      <temis:choose>
        <temis:when test="count( @ui:manual-control ) = 0 or @manual-control = 'no'">
          <form onsubmit="return _temis.submit();" name="_main" method="POST" enctype="multipart/form-data" accept-charset="UTF-8">
            <temis:call-template name="ui:sys-script"/>
            <temis:call-template name="ui:sys-values"/>
            <temis:apply-templates select="node()"/>
          </form>
        </temis:when>
        <temis:when test="@ui:manual-control = 'yes'">
          <temis:apply-templates select="node()"/>
        </temis:when>
      </temis:choose>
    </temis:copy>
  </temis:template>

  <!-- /XSL copier -->


  <!-- insert user-side script -->
  <temis:template match="ui:sys-script" name="ui:sys-script">
    <script language="javascript" src="{$JSDIR}/temis.js"/>
  </temis:template>


  <!-- insert user-side values  -->
  <temis:template match="ui:sys-values" name="ui:sys-values">
    <input type="hidden" name="__postback" value="0"/>
    <input type="hidden" name="__action" value=""/>
    <input type="hidden" name="__value" value=""/>
    <input type="hidden" name="__viewstate">
      <xsl:attribute name="value"><xsl:value-of select="viewstate"/></xsl:attribute>
    </input>
    <input type="hidden" name="__selfurl" >
      <xsl:attribute name="value"><temis:value-of select="url"/></xsl:attribute>
    </input>
  </temis:template>

</temis:stylesheet>
