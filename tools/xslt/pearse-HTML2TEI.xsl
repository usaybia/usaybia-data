<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:opf="http://www.idpf.org/2007/opf"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:functx="http://www.functx.com"
    xmlns:scholarNET="http://scholarnet.github.io" exclude-result-prefixes="xs" version="2.0">

    <xsl:function name="functx:index-of-node" as="xs:integer*" xmlns:functx="http://www.functx.com">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:param name="nodeToFind" as="node()"/>

        <xsl:sequence
            select="
                for $seq in (1 to count($nodes))
                return
                    $seq[$nodes[$seq] is $nodeToFind]
                "/>

    </xsl:function>
    
    
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:template match="/html" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:result-document href="../../data/texts/tei/IU-2-en.xml" format="xml">
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>History of the Physicians</title>
                            <author>Ibn Abī Uṣaybiʿa</author>
                        </titleStmt>
                        <publicationStmt>
                            <authority>Usaybia.net</authority>
                        </publicationStmt>
                        <sourceDesc>
                            <biblStruct>
                                <monogr>
                                    <author>Ibn Abi Usaibia</author>
                                    <editor role="translator">Lothar Kopf</editor>
                                    <editor role="annotator">M. Plessner</editor>
                                    <editor role="html-encoder">Roger Pearse</editor>
                                    <title>History of physicians</title>
                                    <ptr target="http://www.tertullian.org/fathers/ibn_abi_usaibia_03.htm"/>                  
                                    <availability>
                                        <licence>public domain</licence>
                                    </availability>
                                    <funder>Translated for the National Library of Medicine, Bethesda, Maryland, 
                                        under the Special Foreign Currency Program, carried out under a 
                                        National Science Foundation Contract with the Israel Program for 
                                        Scientific Translations, Jerusalem, Israel</funder>
                                    <imprint>
                                        <date>1971</date>
                                    </imprint>
                                </monogr>
                            </biblStruct>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <!-- Continue adapting this here. -->
                        <div>
                            <xsl:variable name="head-p">
                                <xsl:apply-templates select="body"
                                    xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>
                            </xsl:variable>
                            <xsl:copy-of select="$head-p/p[not(preceding-sibling::head)]"/>
                            <xsl:for-each select="$head-p/head">
                                <xsl:variable name="i">
                                    <xsl:number/>
                                </xsl:variable>
                                <xsl:variable name="this-head" select="."/>
                                <div>
                                    <head n="{$i}">
                                        <xsl:value-of select="."/>
                                    </head>
                                    <xsl:copy-of
                                        select="$head-p/head[$i + 1]/preceding-sibling::*[preceding-sibling::head[1] = $this-head]"/>
                                    <xsl:if test=". = $head-p/head[last()]">
                                        <xsl:copy-of
                                            select="$head-p/head[last()]/following-sibling::*"/>
                                    </xsl:if>
                                </div>
                            </xsl:for-each>
                        </div>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="head" match="xhtml:div[@id = 'book-container']/xhtml:span[@class = 'title']"
        xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:for-each select=".">
            <head>
                
            </head>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="text"
        match="xhtml:div[@id = 'book-container']/node()[not(name() = ('a', 'span', 'hr', 'br'))]"
        xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:if test="string-length(normalize-space(.)) > 0">
            <p>
            </p>
        </xsl:if>
    </xsl:template>
    <xsl:template name="pb" match="//A[starts-with(@NAME,'p')]" xmlns="http://www.tei-c.org/ns/1.0">
        <pb n="{replace(@NAME,'p','')}"/>
    </xsl:template>
    <xsl:template name="other-span"
        match="xhtml:div[@id = 'book-container']/xhtml:span[not(@class = 'title')]"/>
    <xsl:template name="other-div" match="xhtml:div[not(@id = 'book-container')]"/>
</xsl:stylesheet>
