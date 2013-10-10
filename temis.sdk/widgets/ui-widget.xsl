<temis:stylesheet version="1.0" xmlns:temis="http://www.w3.org/1999/XSL/Transform"
    xmlns:ui="ui.dtd"
    xmlns:xsl="content://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="ui"
    >

  <temis:template match="ui:widget">
    <xsl:template match="*[@class='{@class}']" mode="temis-insert-widget">
      <xsl:param name="temis-widget" select="."/>

      <temis:apply-templates select="*"/>
    </xsl:template>
  </temis:template>

  <temis:template match="ui:insert-widget">
    <xsl:apply-templates select="$temis-widget/{@id}" mode="temis-insert-widget">

    </xsl:apply-templates>
  </temis:template>
</temis:stylesheet>