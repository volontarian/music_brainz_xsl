<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" cdata-section-elements="headline intro body" />
  <xsl:include href="schema/partials/resource.xsl"/>
  <xsl:include href="schema/partials/attributes.xsl"/>
  <xsl:include href="schema/partials/elements.xsl"/>
  <xsl:include href="schema/partials/refs.xsl"/>
  <xsl:include href="schema/partials/choice.xsl"/>
  <xsl:include href="schema/partials/data.xsl"/>
  <xsl:include href="schema/partials/value.xsl"/>
  <xsl:template match="/">
    <xsl:for-each select="./grammar/define">
      <xsl:choose>
        <xsl:when test="./@name = 'def_metadata-element'"/>
        <!-- TODO: consider attribute target-type @def_relation-list -->
        <xsl:when test="./@name = 'def_medium-list' or ./@name = 'def_relation-list' or ./@name = 'def_attribute-list' or ./@name = 'def_list-attributes' or ./@name = 'def_ipi-list'"/>
        <xsl:when test="contains(./@name, 'list')">
          <xsl:choose>
            <xsl:when test="count(./element) = 1">
              <xsl:choose>
                <xsl:when test="count(./element[1]/*) = 2 and name(./element[1]/*[1]) = 'ref' and name(./element[1]/*[2]) = 'zeroOrMore' and count(./element[1]/*[2]/*) = 1 and name(./element[1]/*[2]/*[1]) = 'ref'"/>
                <xsl:otherwise>
                  <xsl:element name="{./@name}">
                    <xsl:call-template name="error"><xsl:with-param name="message">Not implemented #1.</xsl:with-param></xsl:call-template>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="{./@name}">
                <xsl:call-template name="error"><xsl:with-param name="message">Not implemented #2.</xsl:with-param></xsl:call-template>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>  
        </xsl:when>
        <xsl:when test="count(./element) = 1 and count(./*[1]/*) &gt; 1 and ./element/@name != ''">
          <xsl:for-each select="./element"><xsl:call-template name="resource"/></xsl:for-each>
        </xsl:when>
        <xsl:when test="./@name = 'def_artist-credit'">
          <name-credit>
            <parent>artist</parent>
            <attributes><joinphrase><type><name>String</name></type></joinphrase></attributes>
          </name-credit>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="error">
    <xsl:param name="message"/>
    <xsl:param name="xpath"/>
    <error>
      <message><xsl:value-of select="$message"/></message>
      <xml><xsl:copy-of select="." /></xml>
    </error>
  </xsl:template>
</xsl:stylesheet>