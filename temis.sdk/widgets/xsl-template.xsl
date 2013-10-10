<temis:stylesheet
    xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd" xmlns:Xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    version="1.0">


  <temis:template match="temis:template[@match='/']">
    <xsl:template match="/root/page">
      <xsl:param name="temis-widget" select="/root/page"/>
      <xsl:param name="ui-page" select="/root/page"/>
      <xsl:param name="ui-index" select="/root/@index"/>
      <temis:apply-templates select="*"/>
    </xsl:template>
  </temis:template>

  <temis:template match="temis:template">
    <temis:copy>
      <temis:apply-templates select="." mode="temis-copy-attributes"/>
      <xsl:param name="temis-widget"/>
      <xsl:param name="ui-page"/>
      <temis:apply-templates select="*"/>
    </temis:copy>
  </temis:template>

  <temis:template match="temis:apply-templates|temis:call-template">
    <temis:copy>
      <temis:apply-templates select="." mode="temis-copy-attributes"/>
      <temis:apply-templates select="*"/>
      <xsl:with-param name="temis-widget" select="$temis-widget"/>
      <xsl:with-param name="ui-page" select="$ui-page"/>
    </temis:copy>
  </temis:template>

</temis:stylesheet>