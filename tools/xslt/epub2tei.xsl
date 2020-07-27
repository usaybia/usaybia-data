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
    <xsl:function name="scholarNET:strip-vowels">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:for-each select="$nodes">
            <xsl:choose>
                <xsl:when test="*">
                    <xsl:copy-of select="scholarNET:strip-vowels(*)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(., '[ً-ٖ]', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="scholarNET:vowel-neutral-regex">
        <xsl:param name="regex-string" as="xs:string"/>
        <xsl:variable name="add-vowels" select="replace($regex-string, '([ؠ-ي])', '$1[ً-ٖ]*')"/>
        <xsl:variable name="normalize-alif" select="replace($add-vowels,'ا','[آاإأ]')"/>
        <xsl:variable name="normalize-ya" select="replace($normalize-alif,'ى','[يىئ]')"/>
        <xsl:variable name="normalize-waw" select="replace($normalize-ya,'و','[وؤ]')"/>
        <xsl:value-of select="$normalize-waw"/>
    </xsl:function>
    <xsl:function name="scholarNET:add-affiliation"
        xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:for-each select="$nodes">
            <xsl:variable name="this-element-name" select="name(.)"/>
            <xsl:choose>
                <xsl:when test="*">
                    <xsl:copy-of select="scholarNET:add-affiliation(*)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="tagged-text">
                        <xsl:analyze-string select="."
                            regex="{scholarNET:vowel-neutral-regex(string-join(($search-christian,$search-muslim,$search-zoroastrian,$search-convert,$search-jewish,$search-sabian,$search-zindiq),'|'))}">
                            <xsl:matching-substring>
                                <xsl:choose>
                                    <xsl:when test="regex-group(1)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="christian">
                                            <xsl:copy-of select="regex-group(1)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(2)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="muslim">
                                            <xsl:copy-of select="regex-group(2)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(3)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="zoroastrian">
                                            <xsl:copy-of select="regex-group(3)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(4)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="convert">
                                            <xsl:copy-of select="regex-group(4)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(5)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="jewish">
                                            <xsl:copy-of select="regex-group(5)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(6)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="sabian">
                                            <xsl:copy-of select="regex-group(6)"/>
                                        </affiliation>
                                    </xsl:when>
                                    <xsl:when test="regex-group(7)">
                                        <affiliation xmlns="http://www.tei-c.org/ns/1.0" ana="zindiq">
                                            <xsl:copy-of select="regex-group(7)"/>
                                        </affiliation>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:copy-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$this-element-name">
                            <xsl:element name="{$this-element-name}">
                                <xsl:copy-of select="$tagged-text"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$tagged-text"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="scholarNET:add-persname"
        xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:for-each select="$nodes">
            <xsl:variable name="this-element-name" select="name(.)"/>
            <xsl:choose>
                <xsl:when test="*">
                    <xsl:copy-of select="scholarNET:add-persname(*)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="tagged-text">
                        <xsl:variable name="persNames-regex" select="scholarNET:vowel-neutral-regex(string-join(($search-ism),'|'))"/>
                        <xsl:variable name="name-connectors-regex" select="scholarNET:vowel-neutral-regex('ابن|بن|ابو|ابي|عبد')"/>
                        <xsl:variable name="article-regex" select="scholarNET:vowel-neutral-regex('ال.+?\s|لل.+?\s')"/>
                        <xsl:analyze-string select="."
                            regex="((لل.+?\W)|(ال.+?\W)|({$persNames-regex}\W))*({$name-connectors-regex}\W)+\w\W((({$persNames-regex}\W)*({$name-connectors-regex}\W)+\w)|({$persNames-regex})|(ال.+?\W))*">
                            <xsl:matching-substring>
                                <tei:persName xmlns="http://www.tei-c.org/ns/1.0">
                                    <xsl:copy-of select="."/>
                                </tei:persName>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:copy-of select="."/>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$this-element-name">
                            <xsl:element name="{$this-element-name}">
                                <xsl:copy-of select="$tagged-text"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="$tagged-text/node()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>

    <!-- Word break after سرياني so that it doesn't catch سريانية . But will this mess up feminine? -->
    <xsl:variable name="search-christian"
        select="'(مسيح|نسطور.*?\W.*?\W|نصران.*?\W|راهب.*?\W|سرياني\W)'"/>
    <xsl:variable name="search-muslim"
        select="
            '(حنف.*?\W|زيدي.*?\W|السني
        .*?\W|أنصاري.*?\W|خارجي.*?\W|صحابي.*?\W|إمامي.*?\W|مالكي.*?\W|شافع.*?\W|معتزل.*?\W|صوف.*?\W|عارِف  بالله.*?\W|حنبل.*?\W|مرجئ.*?\W|أشعر.*?\W|علوي.*?\W|شيع.*?\W|رافض.*?\W|مسلم)'"/>
    <xsl:variable name="search-zoroastrian" select="'(مجوس.*?\W)'"/>
    <xsl:variable name="search-convert" select="'(اعتنق.*?  الإسلام|اسلم.*?\W)'"/>
    <xsl:variable name="search-jewish" select="'(يهود.*?\W|إسرائيل.*?\W)'"/>
    <xsl:variable name="search-sabian" select="'(صابئ.*?\W)'"/>
    <xsl:variable name="search-zindiq" select="'(زنديق.*?\W)'"/>
    
    <xsl:variable name="nyms" select="doc('../../data/oa-tei/nymTEI.xml')/tei:TEI/tei:text/tei:body/tei:listNym/tei:nym"/>
    <xsl:variable name="search-ism" select="concat('(',string-join($nyms/tei:form[@type='simple'],')|('),')')"/>



    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    <xsl:template match="/opf:package" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
        <xsl:result-document href="../epubTEI.xml" format="xml">
            <xsl:variable name="folder-uri" select="replace(base-uri(.), '/[^/]*$', '/')"/>
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="{@xml:lang}">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title>
                                <xsl:value-of select="opf:metadata/dc:title"/>
                            </title>
                            <author>
                                <xsl:value-of select="opf:metadata/dc:creator"/>
                            </author>
                        </titleStmt>
                        <publicationStmt>
                            <authority>ScholarNET</authority>
                        </publicationStmt>
                        <sourceDesc>
                            <bibl>
                                <publisher>
                                    <xsl:value-of select="opf:metadata/dc:publisher"/>
                                </publisher>
                                <idno type="uuid">
                                    <xsl:value-of select="opf:metadata/dc:identifier"/>
                                </idno>
                            </bibl>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <text>
                    <body>
                        <div>
                            <xsl:variable name="page-doc-bodies">
                                <xsl:for-each
                                    select="opf:manifest/opf:item[@media-type = 'application/xhtml+xml']">
                                    <xsl:variable name="page-doc"
                                        select="doc(concat($folder-uri, @href))"/>
                                    <xsl:copy-of select="$page-doc/xhtml:html/xhtml:body/node()"/>

                                    <!--<xsl:apply-templates select="$page-doc/xhtml:html/xhtml:body"
                                        xpath-default-namespace="http://www.tei-c.org/ns/1.0"/>-->
                                    <pb/>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="head-p">
                                <xsl:apply-templates select="$page-doc-bodies"
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
                <!--<xsl:value-of select="scholarNET:add-affiliation(scholarNET:add-persname(node()))"/>-->
                <xsl:value-of select="scholarNET:add-affiliation(node())"/>
            </head>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="text"
        match="xhtml:div[@id = 'book-container']/node()[not(name() = ('a', 'span', 'hr', 'br'))]"
        xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:if test="string-length(normalize-space(.)) > 0">
            <p>
<!--                <xsl:copy-of select="scholarNET:add-affiliation(scholarNET:add-persname(.))"/>-->
                <xsl:copy-of select="scholarNET:add-affiliation(.)"/>
            </p>
        </xsl:if>
    </xsl:template>
    <xsl:template name="pb" match="tei:pb" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template name="other-span"
        match="xhtml:div[@id = 'book-container']/xhtml:span[not(@class = 'title')]"/>
    <xsl:template name="other-div" match="xhtml:div[not(@id = 'book-container')]"/>
</xsl:stylesheet>
