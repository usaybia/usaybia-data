<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/html">
        <TEI>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title></title>
                        <author></author>
                    </titleStmt>
                    <publicationStmt>
                        <authority></authority>
                    </publicationStmt>
                    <sourceDesc>
                        <bibl>
                            <publisher></publisher>
                            <idno type="uuid"></idno>
                        </bibl>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <xsl:for-each select=""></xsl:for-each>
                </body>
            </text>
        </TEI>
    </xsl:template>
     <xsl:template match="//p[not(matches(.,'^[\s\t\n ]*$'))]">
        <p>
            <xsl:value-of select="."/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!-- sometimes repeats text -->
    <xsl:template match="//a[matches(.,'p\.')]">
        <pb ed="kopf" n="{replace(.,'^.*?(\d+).*$','$1')}"/>
    </xsl:template>
    <xsl:template match="//u">
        <head><xsl:value-of select="."/></head>
    </xsl:template>
</xsl:stylesheet>