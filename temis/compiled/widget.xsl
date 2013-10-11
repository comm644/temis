<?xml version="1.0" standalone="no"?>
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ui="ui.dtd" xmlns:gen="gen.dtd" xmlns:xitec="xitec.dtd" exclude-result-prefixes="ui gen xsl xitec" version="1.0">
  <!--
  xmlns="http://www.w3.org/TR/html4/strict.dtd"
       -->

  <temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="readable">yes</temis:variable><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="enable-test-visibility">yes</temis:variable><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="enable-test-object-exists">yes</temis:variable><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="enable-test-disabled">no</temis:variable><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="enable-name-as-caption">no</temis:variable><temis:output xmlns:temis="http://www.w3.org/1999/XSL/Transform" method="xml" standalone="yes" encoding="utf-8" cdata-section-elements="script"/><xsl:include href="../settings/config.xsl"/><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="JSDIR">
    <temis:value-of select="$TEMIS_ROOT"/><temis:text>/compiled</temis:text>
  </temis:variable>
  

  <xsl:template name="str-replace">
    <xsl:param name="search"/>
    <xsl:param name="replace"/>
    <xsl:param name="subject"/>
      
    <xsl:choose>
      <xsl:when test="contains($subject,$search)">
        <xsl:value-of select="substring-before($subject,$search)"/>
        <xsl:copy-of select="$replace"/>
        <xsl:call-template name="str-replace">
          <xsl:with-param name="search" select="$search"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="subject" select="substring-after($subject,$search)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$subject"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template name="str-remove">
    <xsl:param name="search"/>
    <xsl:param name="subject"/>

    <xsl:call-template name="str-replace">
      <xsl:with-param name="search" select="$search"/>
      <xsl:with-param name="subject" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- helpers -->
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index">
    <temis:param name="index" select="@ui:index"/>
    <temis:param name="inline"/>
    <temis:param name="context">name</temis:param>

    <temis:if test="$index!=''">
      
      <temis:variable name="code">
        <temis:choose>
          <temis:when test="$inline='yes'">
            <temis:value-of select="$index"/>
          </temis:when>

          <temis:when test="$inline = 'xpath' and starts-with( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
          </temis:when>

          <temis:when test="$inline='xpath' and contains( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <temis:text>concat('</temis:text>
            <temis:value-of select="substring-before( $index, '{')"/>
            <temis:text>',</temis:text>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
            <temis:text>)</temis:text>
          </temis:when>
          <temis:when test="$inline='xpath'">
            <temis:value-of select="$index"/>
          </temis:when>
          <temis:otherwise>
            <temis:value-of select="$index"/>
            <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="{substring-before( substring-after(  $index, '{{'), '}}')}"/>

          </temis:otherwise>
        </temis:choose>
      </temis:variable>

      <temis:choose>
        <temis:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <temis:text>--</temis:text><temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <temis:text>[</temis:text><temis:copy-of select="$code"/> <temis:text>]</temis:text>
        </temis:when>
        <temis:when test="$context='noindex'"/>
        <temis:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='xpath' and contains( $index, '{')">
          <temis:text/>/*[ @index = <temis:copy-of select="$code"/>]<temis:text/>
        </temis:when>
        <temis:when test="$context='xpath' ">
          <temis:text/>/*[ @index = '<temis:copy-of select="$code"/>']<temis:text/>
        </temis:when>
        <temis:when test="$context='code' ">
          <temis:copy-of select="$code"/>
        </temis:when>
      </temis:choose>
    </temis:if>
    
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-name">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>[<temis:value-of select="@ui:index"/>]<temis:text/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-id">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>-<temis:value-of select="@ui:index"/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-xpath">
    <temis:apply-templates select="." mode="gen-index">
      <temis:with-param name="inline" select="'xpath'"/>
      <temis:with-param name="context" select="'xpath'"/>
    </temis:apply-templates>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*|@*|text()" mode="gen-index-valueof">
    <temis:param name="index" select="."/>
    <temis:choose>
      <temis:when test="contains($index,'{')">
        <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform">
          <temis:attribute name="select">
            <temis:value-of select="substring-before( substring-after(  $index, '{' ), '}')"/>
          </temis:attribute>
        </xsl:value-of>
      </temis:when>
      <temis:otherwise>
        <temis:value-of select="$index"/>
      </temis:otherwise>
    </temis:choose>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index">
    <temis:param name="index" select="@ui:index"/>
    <temis:param name="inline"/>
    <temis:param name="context">name</temis:param>

    <temis:if test="$index!=''">
      
      <temis:variable name="code">
        <temis:choose>
          <temis:when test="$inline='yes'">
            <temis:value-of select="$index"/>
          </temis:when>

          <temis:when test="$inline = 'xpath' and starts-with( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
          </temis:when>

          <temis:when test="$inline='xpath' and contains( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <temis:text>concat('</temis:text>
            <temis:value-of select="substring-before( $index, '{')"/>
            <temis:text>',</temis:text>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
            <temis:text>)</temis:text>
          </temis:when>
          <temis:when test="$inline='xpath'">
            <temis:value-of select="$index"/>
          </temis:when>
          <temis:otherwise>
            <temis:value-of select="$index"/>
            <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="{substring-before( substring-after(  $index, '{{'), '}}')}"/>

          </temis:otherwise>
        </temis:choose>
      </temis:variable>

      <temis:choose>
        <temis:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <temis:text>--</temis:text><temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <temis:text>[</temis:text><temis:copy-of select="$code"/> <temis:text>]</temis:text>
        </temis:when>
        <temis:when test="$context='noindex'"/>
        <temis:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='xpath' and contains( $index, '{')">
          <temis:text/>/*[ @index = <temis:copy-of select="$code"/>]<temis:text/>
        </temis:when>
        <temis:when test="$context='xpath' ">
          <temis:text/>/*[ @index = '<temis:copy-of select="$code"/>']<temis:text/>
        </temis:when>
        <temis:when test="$context='code' ">
          <temis:copy-of select="$code"/>
        </temis:when>
      </temis:choose>
    </temis:if>
    
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-name">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>[<temis:value-of select="@ui:index"/>]<temis:text/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-id">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>-<temis:value-of select="@ui:index"/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-xpath">
    <temis:apply-templates select="." mode="gen-index">
      <temis:with-param name="inline" select="'xpath'"/>
      <temis:with-param name="context" select="'xpath'"/>
    </temis:apply-templates>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*|@*|text()" mode="gen-index-valueof">
    <temis:param name="index" select="."/>
    <temis:choose>
      <temis:when test="contains($index,'{')">
        <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform">
          <temis:attribute name="select">
            <temis:value-of select="substring-before( substring-after(  $index, '{' ), '}')"/>
          </temis:attribute>
        </xsl:value-of>
      </temis:when>
      <temis:otherwise>
        <temis:value-of select="$index"/>
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="text()|@*|*" mode="insert-event-param">
    <temis:param name="name"/>
    <xsl:with-param xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="{$name}"><temis:apply-templates mode="gen-index-valueof" select="."/></xsl:with-param>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-add-handler">
    <temis:param name="event"/>

    <temis:text>
    </temis:text>

    <temis:if test="count( @*[ name() = $event ] ) = 0">
      <xsl:apply-templates xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="$temis-object/{$event}" mode="temis-add-handler">
        <temis:apply-templates mode="insert-event-param" select="@ui:index"><temis:with-param name="name" select="'index'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target"><temis:with-param name="name" select="'target'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target-index"><temis:with-param name="name" select="'target-index'"/></temis:apply-templates>
        <temis:apply-templates mode="insert-event-param" select="@ui:target-window"><temis:with-param name="name" select="'target-window'"/></temis:apply-templates>
      </xsl:apply-templates>
    </temis:if>
  </temis:template>
  <xsl:template match="@*|node()|text()" mode="gen:strip-braces">
    <xsl:variable name="text" select="."/>
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( substring-after( $text, '{'), '}')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="@*|node()|text()" mode="gen:replace-braces" name="gen:replace-braces">
    <xsl:param name="text" select="."/>
    
    <xsl:choose>
      <xsl:when test="contains( $text, '{')">
        <xsl:value-of select="substring-before( $text, '{')"/>

        <xsl:variable name="after" select="substring-after( $text, '{')"/>
        <xsl:element name="xsl:value-of">
          <xsl:attribute name="select">
            <xsl:value-of select="substring-before( $after, '}')"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:call-template name="gen:replace-braces">
          <xsl:with-param name="text" select="substring-after( $text, '}')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- base tempplates -->
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="@*|node()">
    <temis:copy>
      <temis:apply-templates select="@*"/>
      <temis:apply-templates select="node()"/>
    </temis:copy>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="/">
    <temis:copy>
      <temis:apply-templates select="@*"/>
      <temis:apply-templates select="node()"/>
    </temis:copy>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-copy-attributes">
    <!-- copy attributes  -->
    <temis:for-each select="@*[not(contains(name(),'ui:') or name() = 'id')]">
      <temis:attribute name="{name()}">
        <temis:value-of select="."/>
      </temis:attribute>
    </temis:for-each>

    <temis:apply-templates select="." mode="temis-check-disable"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-check-disable">

    <temis:choose>
      <temis:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </temis:when>
      <temis:when test="$enable-test-disabled='yes'">
          <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="{{$temis-object}}/disabled = '1'">
            <xsl:attribute name="disabled">1</xsl:attribute>
          </xsl:if>
      </temis:when>
      <temis:otherwise>
        <!-- nothing todo -->
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="@ui:tooltip">
    <temis:attribute name="title">
      <temis:apply-templates mode="ui:message" select="."/>
    </temis:attribute>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="temis:stylesheet">

  <temis:copy>
      <temis:apply-templates select="@*"/>
      <temis:apply-templates select="node()"/>

      <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="*" mode="temis-set-id">
        <xsl:param name="ui-index"/>
        <xsl:choose>
          <xsl:when test="$ui-index != ''">
            <xsl:attribute name="id">
              <xsl:value-of select="__name"/>
              <xsl:value-of select="$ui-index"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="__name"/>
              <xsl:value-of select="$ui-index"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="id">
              <xsl:value-of select="__name"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="__name"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:template>

      <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="*" mode="temis-set-name">
        <xsl:attribute name="name">
          <xsl:value-of select="__name"/>
        </xsl:attribute>
      </xsl:template>
      <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="*" mode="temis-set-value">
        <xsl:attribute name="value">
          <xsl:value-of select="value"/>
        </xsl:attribute>
      </xsl:template>


      <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="*" mode="temis-add-handler">
        <xsl:param name="index"/>
        <xsl:param name="target"/>
        <xsl:param name="target-index"/>
        <xsl:param name="target-window"/>

        <xsl:if test="count( handlers/* ) != 0 and ../autoPostBack = '1'">
          <xsl:attribute name="{{name()}}">
            <temis:text/>_temis.doEvent(this,<temis:text/>
            <temis:text/>'<xsl:value-of select="name()"/>', <temis:text/>
            <temis:text/>'<xsl:value-of select="../__name"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$index"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$target"/>', <temis:text/>
            <temis:text/>'<xsl:value-of select="$target-index"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$target-window"/>');<temis:text/>
          </xsl:attribute>
        </xsl:if>
      </xsl:template>

    </temis:copy>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="temis:template[@match='/']">
    <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="/root/page">
      <xsl:param name="temis-widget" select="/root/page"/>
      <xsl:param name="ui-page" select="/root/page"/>
      <xsl:param name="ui-index" select="/root/@index"/>
      <temis:apply-templates select="*"/>
    </xsl:template>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="temis:template">
    <temis:copy>
      <temis:apply-templates select="." mode="temis-copy-attributes"/>
      <xsl:param xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="temis-widget"/>
      <xsl:param xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="ui-page"/>
      <temis:apply-templates select="*"/>
    </temis:copy>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="temis:apply-templates|temis:call-template">
    <temis:copy>
      <temis:apply-templates select="." mode="temis-copy-attributes"/>
      <temis:apply-templates select="*"/>
      <xsl:with-param xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="temis-widget" select="$temis-widget"/>
      <xsl:with-param xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="ui-page" select="$ui-page"/>
    </temis:copy>
  </temis:template>


  <!-- widgets -->
  
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="temis:include">
    <temis:variable name="doc" select="document( current()/@href )"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:include' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:variable' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'xsl:template' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'ui:panel' ]"/>
    <temis:apply-templates select="$doc/temis:stylesheet/*[ name() = 'ui:widget' ]"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="body">
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
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:sys-script" name="ui:sys-script">
    <script language="javascript" src="{$JSDIR}/temis.js"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:sys-values" name="ui:sys-values">
    <input type="hidden" name="__postback" value="0"/>
    <input type="hidden" name="__action" value=""/>
    <input type="hidden" name="__value" value=""/>
    <input type="hidden" name="__viewstate">
      <xsl:attribute xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="value"><xsl:value-of select="viewstate"/></xsl:attribute>
    </input>
    <input type="hidden" name="__selfurl">
      <xsl:attribute xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="value"><temis:value-of select="url"/></xsl:attribute>
    </input>
  </temis:template>

  <!-- block templates -->
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:widget">
    <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="*[@class='{@class}']" mode="temis-insert-widget">
      <xsl:param name="temis-widget" select="."/>

      <temis:apply-templates select="*"/>
    </xsl:template>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:insert-widget">
    <xsl:apply-templates xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="$temis-widget/{@id}" mode="temis-insert-widget">

    </xsl:apply-templates>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index">
    <temis:param name="index" select="@ui:index"/>
    <temis:param name="inline"/>
    <temis:param name="context">name</temis:param>

    <temis:if test="$index!=''">
      
      <temis:variable name="code">
        <temis:choose>
          <temis:when test="$inline='yes'">
            <temis:value-of select="$index"/>
          </temis:when>

          <temis:when test="$inline = 'xpath' and starts-with( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
          </temis:when>

          <temis:when test="$inline='xpath' and contains( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <temis:text>concat('</temis:text>
            <temis:value-of select="substring-before( $index, '{')"/>
            <temis:text>',</temis:text>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
            <temis:text>)</temis:text>
          </temis:when>
          <temis:when test="$inline='xpath'">
            <temis:value-of select="$index"/>
          </temis:when>
          <temis:otherwise>
            <temis:value-of select="$index"/>
            <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="{substring-before( substring-after(  $index, '{{'), '}}')}"/>

          </temis:otherwise>
        </temis:choose>
      </temis:variable>

      <temis:choose>
        <temis:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <temis:text>--</temis:text><temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <temis:text>[</temis:text><temis:copy-of select="$code"/> <temis:text>]</temis:text>
        </temis:when>
        <temis:when test="$context='noindex'"/>
        <temis:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='xpath' and contains( $index, '{')">
          <temis:text/>/*[ @index = <temis:copy-of select="$code"/>]<temis:text/>
        </temis:when>
        <temis:when test="$context='xpath' ">
          <temis:text/>/*[ @index = '<temis:copy-of select="$code"/>']<temis:text/>
        </temis:when>
        <temis:when test="$context='code' ">
          <temis:copy-of select="$code"/>
        </temis:when>
      </temis:choose>
    </temis:if>
    
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-name">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>[<temis:value-of select="@ui:index"/>]<temis:text/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-id">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>-<temis:value-of select="@ui:index"/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-xpath">
    <temis:apply-templates select="." mode="gen-index">
      <temis:with-param name="inline" select="'xpath'"/>
      <temis:with-param name="context" select="'xpath'"/>
    </temis:apply-templates>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*|@*|text()" mode="gen-index-valueof">
    <temis:param name="index" select="."/>
    <temis:choose>
      <temis:when test="contains($index,'{')">
        <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform">
          <temis:attribute name="select">
            <temis:value-of select="substring-before( substring-after(  $index, '{' ), '}')"/>
          </temis:attribute>
        </xsl:value-of>
      </temis:when>
      <temis:otherwise>
        <temis:value-of select="$index"/>
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-copy-attributes">
    <!-- copy attributes  -->
    <temis:for-each select="@*[not(contains(name(),'ui:') or name() = 'id')]">
      <temis:attribute name="{name()}">
        <temis:value-of select="."/>
      </temis:attribute>
    </temis:for-each>

    <temis:apply-templates select="." mode="temis-check-disable"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-check-disable">

    <temis:choose>
      <temis:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </temis:when>
      <temis:when test="$enable-test-disabled='yes'">
          <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="{{$temis-object}}/disabled = '1'">
            <xsl:attribute name="disabled">1</xsl:attribute>
          </xsl:if>
      </temis:when>
      <temis:otherwise>
        <!-- nothing todo -->
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="@ui:tooltip">
    <temis:attribute name="title">
      <temis:apply-templates mode="ui:message" select="."/>
    </temis:attribute>
  </temis:template><temis:variable xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ajax-address" select="'/ajax'"/><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:panel">
    <xsl:template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" match="/ajax/{@id}" name="temis__generated_{@id}">
      <xsl:param name="temis-widget" select="/ajax/{@id}"/>
      <xsl:param name="ui-page" select="$temis-widget"/>
      <xsl:param name="ui-index" select="/ajax/@index"/>

      <xsl:variable name="index">
        <xsl:if test="$ui-index != ''">-<xsl:value-of select="$ui-index"/></xsl:if>
      </xsl:variable>

      <div id="{@id}{{$index}}">
        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="*|text()"/>
      </div>
    </xsl:template>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:insert-panel">
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
      <xsl:call-template xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="temis__generated_{@id}">
        <xsl:with-param name="temis-widget" select="$temis-widget"/>
        <xsl:with-param name="ui-index"><temis:apply-templates select="@ui:index" mode="gen-index-valueof"/></xsl:with-param>
      </xsl:call-template>
  </temis:template>

  <!-- elements -->
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-copy-attributes">
    <!-- copy attributes  -->
    <temis:for-each select="@*[not(contains(name(),'ui:') or name() = 'id')]">
      <temis:attribute name="{name()}">
        <temis:value-of select="."/>
      </temis:attribute>
    </temis:for-each>

    <temis:apply-templates select="." mode="temis-check-disable"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="temis-check-disable">

    <temis:choose>
      <temis:when test="@disabled='1' or @disabled='yes' ">
        <!-- nothing todo -->
      </temis:when>
      <temis:when test="$enable-test-disabled='yes'">
          <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="{{$temis-object}}/disabled = '1'">
            <xsl:attribute name="disabled">1</xsl:attribute>
          </xsl:if>
      </temis:when>
      <temis:otherwise>
        <!-- nothing todo -->
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="@ui:tooltip">
    <temis:attribute name="title">
      <temis:apply-templates mode="ui:message" select="."/>
    </temis:attribute>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index">
    <temis:param name="index" select="@ui:index"/>
    <temis:param name="inline"/>
    <temis:param name="context">name</temis:param>

    <temis:if test="$index!=''">
      
      <temis:variable name="code">
        <temis:choose>
          <temis:when test="$inline='yes'">
            <temis:value-of select="$index"/>
          </temis:when>

          <temis:when test="$inline = 'xpath' and starts-with( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
          </temis:when>

          <temis:when test="$inline='xpath' and contains( $index, '{')">
            <temis:variable name="codeline" select="substring-before( substring-after( $index, '{'), '}')"/>
            
            <temis:text>concat('</temis:text>
            <temis:value-of select="substring-before( $index, '{')"/>
            <temis:text>',</temis:text>
            <temis:if test="not(starts-with($codeline,'$') or contains($codeline, '('))">
              <temis:text>current()/</temis:text>
            </temis:if>
            <temis:value-of select="$codeline"/>
            <temis:text>)</temis:text>
          </temis:when>
          <temis:when test="$inline='xpath'">
            <temis:value-of select="$index"/>
          </temis:when>
          <temis:otherwise>
            <temis:value-of select="$index"/>
            <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="{substring-before( substring-after(  $index, '{{'), '}}')}"/>

          </temis:otherwise>
        </temis:choose>
      </temis:variable>

      <temis:choose>
        <temis:when test="$context='id'">
          <!--  <input id="id$id"/> -->
          <temis:text>--</temis:text><temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='name'">
          <!--  <input name="id[index]"/> -->
          <temis:text>[</temis:text><temis:copy-of select="$code"/> <temis:text>]</temis:text>
        </temis:when>
        <temis:when test="$context='noindex'"/>
        <temis:when test="$context='event'">
          <!--
               js:  cation="event:" + id + ":" + event;

               event:object$object$object:onclick       - without index
               event:object$object$object-index:onclick - with index
               -->
          <temis:copy-of select="$code"/>
        </temis:when>
        <temis:when test="$context='xpath' and contains( $index, '{')">
          <temis:text/>/*[ @index = <temis:copy-of select="$code"/>]<temis:text/>
        </temis:when>
        <temis:when test="$context='xpath' ">
          <temis:text/>/*[ @index = '<temis:copy-of select="$code"/>']<temis:text/>
        </temis:when>
        <temis:when test="$context='code' ">
          <temis:copy-of select="$code"/>
        </temis:when>
      </temis:choose>
    </temis:if>
    
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-name">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>[<temis:value-of select="@ui:index"/>]<temis:text/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-id">
    <temis:if test="count(@ui:index) != 0">
      <temis:text/>-<temis:value-of select="@ui:index"/>
    </temis:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="gen-index-xpath">
    <temis:apply-templates select="." mode="gen-index">
      <temis:with-param name="inline" select="'xpath'"/>
      <temis:with-param name="context" select="'xpath'"/>
    </temis:apply-templates>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*|@*|text()" mode="gen-index-valueof">
    <temis:param name="index" select="."/>
    <temis:choose>
      <temis:when test="contains($index,'{')">
        <xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform">
          <temis:attribute name="select">
            <temis:value-of select="substring-before( substring-after(  $index, '{' ), '}')"/>
          </temis:attribute>
        </xsl:value-of>
      </temis:when>
      <temis:otherwise>
        <temis:value-of select="$index"/>
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:output xmlns:temis="http://www.w3.org/1999/XSL/Transform" indent="yes"/><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:page">
    ---------------
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:textbox[@ui:visibility='no']"/><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:textbox" match="ui:textbox">
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


    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <temis:choose>
        <temis:when test="$mode = 'multiline'">
          <textarea id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

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
          <input type="{$mode}" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

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
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="ui-textbox-content">
    <temis:apply-templates select="." mode="temis-copy-attributes"/>
    <temis:apply-templates select="." mode="temis-add-handler">
      <temis:with-param name="event">onchange</temis:with-param>
    </temis:apply-templates>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:button">
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>

    <temis:variable name="type">
      <temis:choose>
        <temis:when test="count(@type) = 0">button</temis:when>
        <temis:otherwise>submit</temis:otherwise>
      </temis:choose>
    </temis:variable>

    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
          <input type="{$type}" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

            <temis:apply-templates select="." mode="temis-copy-attributes"/>
            <temis:apply-templates select="." mode="temis-add-handler">
              <temis:with-param name="event">onclick</temis:with-param>
            </temis:apply-templates>

              <temis:apply-templates select="." mode="ui-button-caption"/>

            <!-- insert user code here  -->
            <temis:apply-templates select="*"/>

          </input>
    </xsl:if>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="*" mode="ui-button-caption">

    <temis:choose>
      <temis:when test="count( @value ) != 0">
        <!-- already inserted by copier -->
      </temis:when>

      <temis:when test="count( @ui:caption ) !=0">
        <xsl:attribute xmlns:xsl="content://www.w3.org/1999/XSL/Transform" name="value">
          <temis:apply-templates mode="ui:message" select="@ui:caption"/>
        </xsl:attribute>
      </temis:when>

      <temis:otherwise>
        <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
        <!-- use program defined text -->
        <xsl:choose xmlns:xsl="content://www.w3.org/1999/XSL/Transform">
          <xsl:when test="$temis-object/text{$index} != ''">
            <xsl:attribute name="value">
              <xsl:value-of select="$temis-object/text{$index}"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="value">
              <xsl:value-of select="$temis-object/__name"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </temis:otherwise>
    </temis:choose>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:value">
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>

    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="1 = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="hidden" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>

        <xsl:attribute name="value"><xsl:value-of select="value"/></xsl:attribute>
        <!-- insert user code here  -->
        <temis:apply-templates select="*"/>
      </input>
    </xsl:if>

  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="text()|@*|*" mode="gen-select-attr">
    <temis:param name="text" select="."/>

    <temis:attribute name="select">
      <temis:value-of select="substring-before( substring-after( $text, '{'), '}')"/>
    </temis:attribute>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:dropdownlist">

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


    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>

      <select id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

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
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:file" match="ui:file">

    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>

    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="file" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

        <temis:apply-templates select="." mode="temis-copy-attributes"/>
        <temis:apply-templates select="." mode="temis-add-handler">
          <temis:with-param name="event">onchange</temis:with-param>
        </temis:apply-templates>

        <!-- insert user code here  -->
        <temis:apply-templates select="*"/>

      </input>
    </xsl:if>


  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:checkbox" match="ui:checkbox">
    <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>



    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="checkbox" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

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
        <label id="{{$temis-object/__name}}{$index-id}-label" for="{{$temis-object/__name}}{$index-id}" style="{@ui:caption-style}" class="{@ui:caption-class}">

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
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:radio" match="ui:radio">
    <temis:variable name="index"><temis:apply-templates select="." mode="gen-index-xpath"/></temis:variable>
    <temis:variable name="index-id"><temis:apply-templates select="." mode="gen-index-id"/>-<temis:value-of select="@value"/></temis:variable>
    <temis:variable name="index-name"><temis:apply-templates select="." mode="gen-index-name"/></temis:variable>



    <xsl:if xmlns:xsl="content://www.w3.org/1999/XSL/Transform" test="count($temis-widget/{@id}) = 0 or $temis-widget/{@id}/visible = 1">
      <xsl:variable name="temis-object" select="$temis-widget/{@id}"/>
      <input type="radio" id="{{$temis-object/__name}}{$index-id}" name="{{$temis-object/__name}}{$index-name}">

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
        <label id="{{$temis-object/__name}}{$index-id}-label" for="{{$temis-object/__name}}{$index-id}" style="{@ui:caption-style}" class="{@ui:caption-class}">

          <temis:apply-templates mode="ui:message" select="@ui:caption"/>
        </label>
      </temis:if>

    </xsl:if>
  </temis:template>
  

  <!-- Helper controls -->  
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:nbsp">
    <temis:text disable-output-escaping="yes">&amp;#160;</temis:text>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:space">
    <temis:text disable-output-escaping="yes">&amp;#160;</temis:text>
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:msg|ui:message">
    <temis:apply-templates mode="ui:message" select="@id"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:msg">
    <temis:param name="id"/>
    <temis:apply-templates mode="ui:message" select="$id"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" name="ui:message">
    <temis:param name="id"/>
    <temis:apply-templates mode="ui:message" select="$id"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="@*|text()" mode="ui:message">
    <temis:param name="id" select="."/>
    <temis:variable name="file" select="//ui:messages/@href"/>
    <temis:variable name="section" select="//ui:messages/@section"/>

    <temis:variable name="clean-id"><temis:apply-templates select="$id" mode="gen:strip-braces"/></temis:variable>
    <temis:variable name="document" select="document( $file )"/>

    <temis:variable name="text">
      <temis:choose>
        <temis:when test="string( $section ) = ''">
          <temis:value-of select="$document//*[name() = $clean-id]"/>
        </temis:when>
        <temis:otherwise>
          <temis:value-of select="$document//*[name() = $section]/*[name() = $clean-id]"/>
        </temis:otherwise>
      </temis:choose>
    </temis:variable>

    <temis:choose>
      <temis:when test="$text != ''"><temis:value-of select="$text"/></temis:when>
      <temis:otherwise>
        <temis:choose>
          <temis:when test="contains($id, '{')"><xsl:value-of xmlns:xsl="content://www.w3.org/1999/XSL/Transform" select="{$clean-id}"/></temis:when>
          <temis:otherwise><temis:value-of select="$clean-id"/></temis:otherwise>
        </temis:choose>
      </temis:otherwise>
    </temis:choose>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:messages">
  </temis:template>
  <temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:visible[@ui:visibility = 'no']"/><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:visible[@ui:visibility = 'yes']">
    <temis:apply-templates select="*|text()"/>
  </temis:template><temis:template xmlns:temis="http://www.w3.org/1999/XSL/Transform" match="ui:visible[@ui:visibility = 'test' or count(@ui:visibility) = 0]">
      <!-- insert user code here  -->
      <temis:apply-templates select="*|text()"/>
  </temis:template>

  
</xsl:stylesheet>
