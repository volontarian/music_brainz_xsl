<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="ref">
    <xsl:variable name="ref_name" select="./@name"/>
    <xsl:choose>
      <xsl:when test="$ref_name = 'def_incomplete-date'">
        <type><name>IncompleteDate</name></type>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="ref_child_tag_name" select="name(/grammar/define[@name=$ref_name][1]/*[1])"/>
        <xsl:if test="$ref_child_tag_name = 'data' or $ref_child_tag_name = 'choice'">
          <xsl:apply-templates select="/grammar/define[@name=$ref_name][1]/*[1]" />
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
