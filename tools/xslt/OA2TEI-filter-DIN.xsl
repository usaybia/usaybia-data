<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
        <xsl:template match="//body">
            <xsl:result-document href="TEIfromAO-IU.xml" format="xml">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:text>
                </xsl:processing-instruction>
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
                            
                            <listPerson>
                                <xsl:for-each select="//div[@class='entryContainer']/table[not(tbody/tr/@class='ligne_general ligne DIN')]">
                                    <person>
                                        <!-- This does not do anything with the comments, which could be useful -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'ISM|IAB|GAD|ABG|GAG|GGG|KUN|LAQ|LQB|NSB|SUH') and not(matches(@class,'hide'))]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <persName xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></persName>
                                        </xsl:for-each>
                                        <idno type="URI">http://onomasticon.irht.cnrs.fr/en/person/<xsl:value-of select="@data-id"/></idno>
                                        <xsl:for-each select="tbody/tr[@class='ligne_general ligne DIN']">
                                            <faith xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></faith>
                                        </xsl:for-each>
                                        <xsl:for-each select="tbody/tr[matches(@class,'GNS')]">
                                            <sex xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></sex>
                                        </xsl:for-each>
                                        
                                        <!-- Events -->
                                        <xsl:if test="tbody/tr[matches(@class,'HWL|WLD')]">
                                            <death xml:lang="ar">
                                                <xsl:for-each select="*[matches(@class,'HWL')]">
                                                    <placeName><xsl:value-of select="td[@class='contents']"/></placeName>
                                                </xsl:for-each>
                                                <xsl:for-each select="*[matches(@class,'WLD')]">
                                                    <date><xsl:value-of select="td[@class='contents']/text()"/></date>
                                                </xsl:for-each>
                                            </death>
                                        </xsl:if>
                                        <xsl:if test="tbody/tr[matches(@class,'HMT|MAT|SMT|UMT')]">
                                            <death xml:lang="ar">
                                                <xsl:for-each select="*[matches(@class,'HMT')]">
                                                    <placeName><xsl:value-of select="td[@class='contents']"/></placeName>
                                                </xsl:for-each>
                                                <xsl:for-each select="*[matches(@class,'MAT')]">
                                                    <date><xsl:value-of select="td[@class='contents']/text()"/></date>
                                                </xsl:for-each>
                                                <xsl:for-each select="*[matches(@class,'SMT')]">
                                                    <note type="SMT"><xsl:value-of select="td[@class='contents']"/></note>
                                                </xsl:for-each>
                                                <xsl:for-each select="*[matches(@class,'UMT')]">
                                                    <note type="UMT"><xsl:value-of select="td[@class='contents']/text()"/></note>
                                                </xsl:for-each>
                                            </death>
                                        </xsl:if>
                                        <xsl:for-each select="tbody/tr[matches(@class,'TRH')]">
                                            <event calendar="AH"><desc><xsl:value-of select="td[@class='contents']/text()"/></desc></event>
                                        </xsl:for-each>
                                        
                                        <!-- Places -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'HAL')]">
                                            <residence xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></residence>
                                        </xsl:for-each>
                                        <xsl:if test="tbody/tr[matches(@class,'HAQ|HDF|HDR|HRB|HRI')]">
                                            <note type="places">
                                                <xsl:for-each select="tbody/tr[matches(@class,'HAQ|HDF|HDR|HRB|HRI')]">
                                                    <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                                    <placeName xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></placeName>
                                                </xsl:for-each>
                                            </note>                                            
                                        </xsl:if>
                                        
                                        <!-- Traits -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'SIF|AKH')]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <trait xml:lang="ar" type="{$type}"><desc><xsl:value-of select="td[@class='contents']"/></desc></trait>
                                        </xsl:for-each>
                                        
                                        <!-- Occupation -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'SWM')]">
                                            <occupation xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></occupation>
                                        </xsl:for-each>
                                        
                                        <!-- Relationships -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'ILA|MIN|SLT')]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <relation xml:lang="ar" type="{$type}"><desc><xsl:value-of select="td[@class='contents']"/></desc></relation>
                                        </xsl:for-each>
                                        
                                        <!-- Other -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'AQB|SNF|SRK') and not(matches(@class,'hide'))]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <note xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></note>
                                        </xsl:for-each>
                                        
                                        
                                        <xsl:for-each select="tbody/tr[@class='ligne_reference ligne REF']">
                                            <bibl><xsl:value-of select="normalize-space(td[@class='contents'])"/></bibl>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>
                            </listPerson>
                                                
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:template>
    
</xsl:stylesheet>