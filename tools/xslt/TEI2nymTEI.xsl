<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:scholarNET="http://scholarnet.github.io"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:function name="scholarNET:strip-vowels-string">
        <xsl:param name="string" as="xs:string*"/>
        <xsl:for-each select="$string">
            <xsl:variable name="strip-vowels" select="replace(., '[ً-ٖ]', '')"/>
            <xsl:variable name="normalize-alif" select="replace($strip-vowels,'آ|إ|أ','ا')"/>
            <xsl:variable name="normalize-ya" select="replace($normalize-alif,'ئ|ي','ى')"/>
            <xsl:variable name="normalize-waw" select="replace($normalize-ya,'ؤ','و')"/>
            <xsl:value-of select="$normalize-waw"/>
        </xsl:for-each>
    </xsl:function>
    
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
        <xsl:template match="//body" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:result-document href="nymTEI.xml" format="xml">
                
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Title</title>
                            </titleStmt>
                            <publicationStmt>
                                <p>Publication Information</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Information about the source</p>
                            </sourceDesc>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <listNym>
                                <xsl:variable name="persons" select="//person[faith/@key]"/>
                                <xsl:variable name="Christians" select="$persons[faith/@key='Christian']"/>
                                <xsl:variable name="Muslims" select="$persons[faith/@key='Muslim']"/>
                                <xsl:variable name="Sabians" select="$persons[faith/@key='Sabian']"/>
                                <xsl:variable name="Zoroastrians" select="$persons[faith/@key='Zoroastrian']"/>
                                <xsl:variable name="Jews" select="$persons[faith/@key='Jewish']"/>
                                <xsl:variable name="Converts-to-Islam" select="$persons[faith/@key='Convert-to-Islam']"/>
                                <xsl:variable name="Zindiqs" select="$persons[faith/@key='Zindiq']"/>
                                <xsl:variable name="Others" select="$persons[faith/@key='Other']"/>
                                
                                <xsl:variable name="list-nym">
                                    <xsl:for-each select="distinct-values($persons/persName[@type=('ISM','IAB')])">
                                        <nym>
                                            <form type="vocalized"><xsl:value-of select="."/></form>
                                            <form type="simple"><xsl:value-of select="scholarNET:strip-vowels-string(.)"/></form>
                                        </nym>
                                    </xsl:for-each>
                                </xsl:variable>
                                
                                <xsl:for-each select="distinct-values($list-nym/nym/form[@type='simple'])">
                                    <xsl:variable name="this-nym" select="."/>
                                    <nym>
                                        <form type="simple"><xsl:value-of select="."/></form>
                                        <xsl:for-each select="$list-nym/nym[form[@type='simple']=$this-nym]/form[@type='vocalized']">
                                            <form type="vocalized"><xsl:value-of select="."/></form>
                                        </xsl:for-each>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Christians"/>
                                            <xsl:with-param name="key" select="'Christian'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Muslims"/>
                                            <xsl:with-param name="key" select="'Muslim'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Sabians"/>
                                            <xsl:with-param name="key" select="'Sabian'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Zoroastrians"/>
                                            <xsl:with-param name="key" select="'Zoroastrian'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Jews"/>
                                            <xsl:with-param name="key" select="'Jewish'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Converts-to-Islam"/>
                                            <xsl:with-param name="key" select="'Convert-to-Islam'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Zindiqs"/>
                                            <xsl:with-param name="key" select="'Zindiq'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                        <xsl:call-template name="usg">
                                            <xsl:with-param name="grp" select="$Others"/>
                                            <xsl:with-param name="key" select="'Other'"/>
                                            <xsl:with-param name="name" select="."/>
                                        </xsl:call-template>
                                    </nym>
                                </xsl:for-each>
                            </listNym>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:template>
    
        <xsl:template name="usg" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:param name="grp"/>
            <xsl:param name="key"/>
            <xsl:param name="name"/>
            <xsl:variable name="occurences" select="count($grp[$name=scholarNET:strip-vowels-string(persName[@type='ISM'])])"/>
            <usg type="{$key}">
                <measure type="occurrences"><xsl:value-of select="$occurences"/></measure>
            </usg>
            
        </xsl:template>
    
</xsl:stylesheet>