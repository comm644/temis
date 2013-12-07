<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ui="ui.dtd"
                version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:processing-instruction name="php">
      <xsl:text>$deps = array(</xsl:text>
      <xsl:apply-templates select="//ui:messages"/>
      <xsl:apply-templates select="//xsl:include">
        <xsl:with-param name="parent">"."</xsl:with-param>
      </xsl:apply-templates>
      <xsl:text>null);?</xsl:text>
    </xsl:processing-instruction>
  </xsl:template>
  
  <!-- process includes -->
<xsl:template match="xsl:include">
  <xsl:param name="parent"/>
  <xsl:variable name="self">
    <xsl:if test="$parent != ''">
      <xsl:text/>dirname(<xsl:value-of select="$parent"/>) . <xsl:text/>
    </xsl:if>
    <xsl:text/>"/<xsl:value-of select="current()/@href"/>"<xsl:text/>
  </xsl:variable>
  <xsl:value-of select="$self"/>,
  <xsl:text>
</xsl:text>
  <xsl:variable name="doc" select="document( current()/@href )"/>
  <xsl:apply-templates select="$doc/xsl:stylesheet/*[ name() = 'xsl:include' ]">
    <xsl:with-param name="parent" select="$self"/>
   </xsl:apply-templates>
</xsl:template>


<xsl:template match="ui:messages">
  <xsl:text/>"<xsl:value-of select="current()/@href"/>",<xsl:text/>
  <xsl:text/>
</xsl:template>

</xsl:stylesheet>
