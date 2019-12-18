<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:template match="/TEI" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:variable name="filename" select="replace(base-uri(),'file.*/','')"/>
        <xsl:result-document href="{$filename}-tokenized.xml" format="xml">
            <xsl:call-template name="all"/>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="node()[not(name())]" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:for-each 
            select="tokenize(.,'\s+')[string-length(.)>0]">
            <w><xsl:copy-of select="."/></w>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="@*|*" name="all" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/> 
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>