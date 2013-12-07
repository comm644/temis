<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd" xmlns:Xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    version="1.0">


<temis:template match="temis:stylesheet">

  <temis:copy>
      <temis:apply-templates select="@*"/>
      <xsl:variable name="temis-widget" select="/root/page"/>
      <xsl:variable name="ui-page" select="/root/page"/>
      <temis:apply-templates select="node()|text()|*"/>

      <xsl:template match="*" mode="temis-set-id">
        <xsl:param name="ui-index"/>
        <xsl:choose>
          <xsl:when test="$ui-index != ''">
            <xsl:attribute name="id">
              <xsl:value-of select="@__name"/>
              <xsl:value-of select="$ui-index"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="@__name"/>
              <xsl:value-of select="$ui-index"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="id">
              <xsl:value-of select="@__name"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="@__name"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:template>

      <xsl:template match="*" mode="temis-set-name">
        <xsl:attribute name="name">
          <xsl:value-of select="@__name"/>
        </xsl:attribute>
      </xsl:template>
      <xsl:template match="*" mode="temis-set-value">
        <xsl:attribute name="value">
          <xsl:value-of select="value"/>
        </xsl:attribute>
      </xsl:template>


      <xsl:template match="*" mode="temis-add-handler">
        <xsl:param name="index"/>
        <xsl:param name="target"/>
        <xsl:param name="target-index"/>
        <xsl:param name="target-window"/>

        <xsl:if test="@handled != '0' != 0 and ../@autoPostBack = '1'">
          <xsl:attribute name="{{name()}}">
            <temis:text/>_temis.doEvent(this,<temis:text/>
            <temis:text/>'<xsl:value-of select="name()"/>', <temis:text/>
            <temis:text/>'<xsl:value-of select="../@__name"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$index"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$target"/>', <temis:text/>
            <temis:text/>'<xsl:value-of select="$target-index"/>',<temis:text/>
            <temis:text/>'<xsl:value-of select="$target-window"/>');<temis:text/>
          </xsl:attribute>
        </xsl:if>
      </xsl:template>

    </temis:copy>
  </temis:template>

</temis:stylesheet>