<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/tei:TEI/tei:text/tei:body">
        <xsl:variable name="persNames" select="//tei:persName"/>
        <xsl:for-each select="//distinct-values($persNames/@ana/tokenize(.,'\s'))">
            <xsl:if test="starts-with(.,'#https://usaybia.net')">
                <xsl:variable name="person-uri" select="replace(.,'#https://usaybia.net/person/','https://usaybia.net/person/')"/>
                <xsl:variable name="person-id" select="replace($person-uri,'https://usaybia.net/person/(\d+)','$1')"/>
                <listPerson>
                    <person xml:id="person-{$person-id}">
                        <xsl:for-each select="$persNames[matches(@ana,$person-uri)]">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <persName xml:id="name{$person-id}-1" xml:lang="ar" source="#bib{$person-id}-1">
                            
                        </persName>
                        
                        <note type="abstract" xml:id="abstract-en-2"/>
                        <idno type="URI">http://syriaca.org/person/2</idno>
                        
                        
                        <bibl xml:id="bib2-1">
                            <title level="m" xml:lang="en"></title>
                            <ptr target=""/>
                            <citedRange unit="entry"></citedRange>
                            <citedRange unit="pp"></citedRange>
                        </bibl>
                    </person>
            </listPerson>
            </xsl:if>
            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>