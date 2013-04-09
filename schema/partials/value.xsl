<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="value">
    <xsl:choose>
      <xsl:when test="name(.) = 'text'"><type><name>String</name></type></xsl:when>
      <xsl:when test="name(.) = 'data' or name(.) = 'ref' or name(.) = 'choice'">
        <xsl:apply-templates select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error">
          <xsl:with-param name="message">Not implemented #3.</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
