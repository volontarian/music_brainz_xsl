<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="resource">
    <xsl:param name="parent"/>
    <xsl:variable name="resource_name">
      <xsl:choose>
        <xsl:when test="./../@name = 'def_nonmb-track'">nonmb-track</xsl:when>
        <xsl:otherwise><xsl:value-of select="./@name"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$resource_name}">
      <xsl:call-template name="attributes"><xsl:with-param name="parent" select="$parent"/></xsl:call-template>
      <xsl:call-template name="elements"><xsl:with-param name="parent" select="$parent"/></xsl:call-template>
      <xsl:call-template name="refs"><xsl:with-param name="parent" select="$parent"/></xsl:call-template>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>