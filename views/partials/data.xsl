<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="data">
    <xsl:choose>
      <xsl:when test="./@type = 'string' or ./@type = 'anyURI'">
        <type>
          <name>String</name>
          <comment><xsl:value-of select="./param[@name='pattern'][1]"/></comment>
        </type>
      </xsl:when>
      <xsl:when test="./@type = 'nonNegativeInteger'"><type><name>Integer</name></type></xsl:when>
      <xsl:when test="./@type = 'float'"><type><name>Float</name></type></xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="error">
          <xsl:with-param name="message">Not implemented: unknown data type.</xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
