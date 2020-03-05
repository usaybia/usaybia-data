<?xml version="1.0" encoding="UTF-8"?>
<!-- Something I added to the encoding key has completely messed up the conversion. 
Need to debug by trying different sections of the encoding table. -->
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:function name="functx:if-absent" as="item()*">
        <xsl:param name="arg" as="item()*"/>
        <xsl:param name="value" as="item()*"/>
        
        <xsl:sequence select="
            if (exists($arg))
            then $arg
            else $value
            "/>
    </xsl:function>
    
    <xsl:function name="functx:replace-multi" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="changeFrom" as="xs:string*"/>
        <xsl:param name="changeTo" as="xs:string*"/>
        
        <xsl:sequence select="
            if (count($changeFrom) > 0)
            then functx:replace-multi(
            replace($arg, $changeFrom[1],
            functx:if-absent($changeTo[1],'')),
            $changeFrom[position() > 1],
            $changeTo[position() > 1])
            else $arg
            "/>
        
    </xsl:function>
    
    <xsl:variable name="key-doc" select="doc('../../data/lhom-encoding-key.tsv')"/>
    <xsl:variable name="key-doc-lines" select="tokenize($key-doc,'\n')"/>
    <xsl:variable name="from">
        <xsl:for-each select="$key-doc-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[1]"/></char>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="to">
        <xsl:for-each select="$key-doc-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[2]"/></char>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:template match="/root">
        <xsl:result-document href="lhom-personal-names-converted.xml" format="xml">
            <xsl:for-each select=".">
                <xsl:copy-of select="functx:replace-multi(.,$from/tei:char/text(),$to/tei:char/text())"/>
            </xsl:for-each>            
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>