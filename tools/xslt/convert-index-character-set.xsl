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
    
    <!-- regular characters to replace -->
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
    
    <!-- special terms to replace -->
    <xsl:variable name="key-doc-terms" select="doc('../../data/lhom-special-terms-encoding-key.tsv')"/>
    <xsl:variable name="key-doc-terms-lines" select="tokenize($key-doc-terms,'\n')"/>
    <xsl:variable name="from-terms">
        <xsl:for-each select="$key-doc-terms-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[1]"/></char>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="to-terms">
        <xsl:for-each select="$key-doc-terms-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[2]"/></char>
        </xsl:for-each>
    </xsl:variable>
    
    <!-- formatting -->
    <xsl:variable name="key-doc-formatting" select="doc('../../data/lhom-formatting-encoding-key.tsv')"/>
    <xsl:variable name="key-doc-formatting-lines" select="tokenize($key-doc-formatting,'\n')"/>
    <xsl:variable name="from-formatting">
        <xsl:for-each select="$key-doc-formatting-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[1]"/></char>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="to-formatting">
        <xsl:for-each select="$key-doc-formatting-lines">
            <char><xsl:sequence select="tokenize(.,'\t')[2]"/></char>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:template match="/root">
        <xsl:result-document href="lhom-personal-names-converted.xml" format="xml">
            <xsl:variable name="characters-replaced">
                <xsl:for-each select=".">
                    <xsl:copy-of select="functx:replace-multi(.,$from/tei:char/text(),$to/tei:char/text())"/>
                </xsl:for-each>  
            </xsl:variable>
            <xsl:variable name="special-terms-replaced">
                <xsl:for-each select="$characters-replaced">
                    <xsl:copy-of select="functx:replace-multi(.,$from-terms/tei:char/text(),$to-terms/tei:char/text())"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="formatting-replaced">
                <xsl:for-each select="$special-terms-replaced">
                    <xsl:copy-of select="functx:replace-multi(.,$from-formatting/tei:char/text(),$to-formatting/tei:char/text())"/>
                </xsl:for-each>
            </xsl:variable>  
            <xsl:variable name="line-breaks-inserted">
                <xsl:copy-of select="replace(replace($formatting-replaced,'\\n','&#10;'),'\n+','&#10;')"/>
            </xsl:variable>
            <xsl:variable name="tag-complete-lines">
                <!-- looks for digits or `see` -->
                <xsl:copy-of select="replace($line-breaks-inserted,'(\n.*?(`see`|\d)+[^\n]+)','$1 COMPLETE_LINE ')"/>
            </xsl:variable>
            <xsl:variable name="merge-incomplete-lines"
                select="replace(replace($tag-complete-lines,'\n',' '),' COMPLETE_LINE  ?','&#10;')"/>
            <xsl:copy-of select="$merge-incomplete-lines"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>