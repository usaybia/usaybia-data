<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:scholarnet="http://scholarnet.org"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
    <xsl:function name="functx:repeat-string" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence select="
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:pad-integer-to-length" as="xs:string"
        xmlns:functx="http://www.functx.com">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence select="
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    
    <xsl:function name="scholarnet:add-date">
        <xsl:param name="date-text"/>
        <xsl:choose>
            <xsl:when test="matches($date-text,'\d+\s*-\s*\d+')">
                <xsl:variable name="notBefore-parsed" select="replace($date-text,'^.*?(\d+)\s*-\s*\d+.*?$','$1')"/>
                <xsl:variable name="notAfter-parsed" select="replace($date-text,'^.*?\d+\s*-\s*(\d+).*?$','$1')"/>
                <xsl:if test="string-length($notBefore-parsed) &lt;= 4">
                    <xsl:attribute name="notBefore" select="functx:pad-integer-to-length($notBefore-parsed,4)"/>
                </xsl:if>
                <xsl:if test="string-length($notAfter-parsed) &lt;= 4">
                    <xsl:variable name="difference" select="string-length($notAfter-parsed) - string-length($notBefore-parsed)"/>
                    <xsl:variable name="notAfter-corrected" select="replace($notBefore-parsed,concat('^(\d{',$difference,'})\d+'),concat('$1',$notAfter-parsed))"/>
                    <xsl:attribute name="notAfter" select="functx:pad-integer-to-length($notAfter-corrected,4)"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="when-parsed" select="replace($date-text,'^.*?(\d+).*?$','$1')"/>
                <xsl:if test="string-length($when-parsed) &lt;= 4">
                    <xsl:attribute name="when" select="functx:pad-integer-to-length($when-parsed,4)"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:attribute name="calendar" select="'islamic'"/>
    </xsl:function>
    
        <xsl:template match="//body">
            <xsl:result-document href="../../data/oa-tei/TEIfromOA-all.xml" format="xml">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://syriaca.org/documentation/syriaca-tei-main.rnc" type="application/relax-ng-compact-syntax"</xsl:text>
                </xsl:processing-instruction>
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>type="text/xsl" href="TEI2XGMML.xsl"</xsl:text>
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
                                <xsl:for-each select="//div[@class='entryContainer']/table">
                                    <person>
                                        <!-- This does not do anything with the comments, which could be useful -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'ISM|IAB|GAD|ABG|GAG|GGG|KUN|LAQ|LQB|NSB|SUH') and not(matches(@class,'hide'))]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <persName xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></persName>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="$type"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <idno type="OA-ID"><xsl:value-of select="@data-id"/></idno>
                                        <idno type="URI"><xsl:value-of select="../ul/li/a/@href"/></idno>
                                        <xsl:for-each select="tbody/tr[@class='ligne_general ligne DIN']">
                                            <xsl:variable name="key">
                                                <xsl:choose>
                                                    <xsl:when test="matches(.,'صَابِئِِ')">Sabian</xsl:when>
                                                    <xsl:when test="matches(.,'مَجُوسِ')">Zoroastrian</xsl:when>        
                                                    <xsl:when test="matches(.,'زِندِيق')">Zindiq</xsl:when>
                                                    <xsl:when test="matches(.,'[اإ]َ?سْ?لَ?م|اعتَنَقَ  الإسلام')">Convert-to-Islam</xsl:when>
                                                    <xsl:when test="matches(.,'يَهُودِ|إسرَاِئِيلِ')">Jewish</xsl:when>
                                                    <xsl:when test="matches(.,'نَصرَانِ|مَسِيحِ|نِسطُورِ|نِصرَانِ|رَاهِب|سِريَانِ')">Christian</xsl:when>
                                                    <xsl:when test="matches(.,'حَنَف|زَيدِي|السُنِّي|سُنِّي
                                                        |أنصَارِي|خَارِجِي|صَحَابِي|إمَامِي|مَالِكِ|شَافِعِ|مُعتَزِلِ|صُوف|غَ?الِ?ي|عَارِف  بالله|حَنبَلِ|مُرجِئ|أشعَرِ|عَلَوِي|شِيع|رَافِضِ|مُسلِم')">Muslim</xsl:when>
                                                    <xsl:otherwise>Other</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <faith key="{$key}" xml:lang="ar">
                                                <xsl:value-of select="td[@class='contents']"/>
                                            </faith>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'DIN'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:for-each select="tbody/tr[matches(@class,'GNS')]">
                                            <sex xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></sex>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'GNS'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        <!-- Events -->
                                        <xsl:if test="string-length(normalize-space(string-join(tbody/tr[matches(@class,'HWL|WLD')]/td[not(@class='category')],'')))">
                                            
                                                <birth xml:lang="ar">
                                                    <xsl:for-each select="tbody/tr[matches(@class,'HWL|WLD')]">
                                                        <xsl:variable name="tr" select="."/>
                                                        <xsl:variable name="contents" select="normalize-space($tr/td[@class='contents'])"/>
                                                        <xsl:variable name="comments" select="normalize-space($tr/td[@class='comments'])"/>
                                                        <xsl:variable name="type" select="replace(@class,'.*?([A-Z]+)$','$1')"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$type='HWL' and string-length($contents)">
                                                                <placeName><xsl:value-of select="$contents"/></placeName>
                                                            </xsl:when>
                                                            <xsl:when test="$type='WLD' and string-length($contents)">
                                                                <date>
                                                                    <xsl:copy-of select="scholarnet:add-date($contents)"/>
                                                                    <xsl:value-of select="$contents"/>
                                                                </date>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        
                                                        <xsl:call-template name="comments">
                                                            <xsl:with-param name="tr" select="$tr"/>
                                                            <xsl:with-param name="type" select="$type"/>
                                                        </xsl:call-template>
                                                        
                                                    </xsl:for-each>
                                                </birth>
                                        </xsl:if>
                                        <xsl:if test="string-length(normalize-space(string-join(tbody/tr[matches(@class,'HMT|MAT|SMT|UMT')]/td[not(@class='category')],'')))">
                                            <death xml:lang="ar">
                                                <xsl:for-each select="tbody/tr[matches(@class,'HMT|MAT|SMT|UMT')]">
                                                    <xsl:variable name="tr" select="."/>
                                                    <xsl:variable name="contents" select="normalize-space($tr/td[@class='contents'])"/>
                                                    <xsl:variable name="comments" select="normalize-space($tr/td[@class='comments'])"/>
                                                    <xsl:variable name="type" select="replace(@class,'.*?([A-Z]+)$','$1')"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$type='HMT' and string-length($contents)">
                                                            <placeName><xsl:value-of select="$contents"/></placeName>
                                                        </xsl:when>
                                                        <xsl:when test="$type='MAT' and string-length($contents)">
                                                            <date>
                                                                <xsl:copy-of select="scholarnet:add-date($contents)"/>
                                                                <xsl:value-of select="$contents"/>
                                                            </date>
                                                        </xsl:when>
                                                        <xsl:when test="$type='SMT' and string-length($contents)">
                                                            <note type="SMT"><xsl:value-of select="$contents"/></note>
                                                        </xsl:when>
                                                        <xsl:when test="$type='UMT' and string-length($contents)">
                                                            <note type="UMT"><xsl:value-of select="$contents"/></note>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                    
                                                    <xsl:call-template name="comments">
                                                        <xsl:with-param name="tr" select="$tr"/>
                                                        <xsl:with-param name="type" select="$type"/>
                                                    </xsl:call-template>
                                                    
                                                </xsl:for-each>
                                            </death>
                                        </xsl:if>
                                        
                                        <xsl:for-each select="tbody/tr[matches(@class,'TRH')]">
                                            <event calendar="AH"><desc><xsl:value-of select="td[@class='contents']/text()"/></desc></event>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'TRH'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        <!-- Places -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'HAL')]">
                                            <residence xml:lang="ar"><placeName><xsl:value-of select="td[@class='contents']"/></placeName></residence>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'HAL'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:if test="tbody/tr[matches(@class,'HAQ|HDF|HDR|HRB|HRI')]">
                                            <note type="places">
                                                <xsl:for-each select="tbody/tr[matches(@class,'HAQ|HDF|HDR|HRB|HRI')]">
                                                    <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                                    <placeName xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></placeName>
                                                    <xsl:call-template name="comments">
                                                        <xsl:with-param name="tr" select="."/>
                                                        <xsl:with-param name="type" select="$type"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </note>                                            
                                        </xsl:if>
                                        
                                        <!-- Traits -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'SIF|AKH')]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <trait xml:lang="ar" type="{$type}"><desc><xsl:value-of select="td[@class='contents']"/></desc></trait>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="$type"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        <!-- Occupation -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'SWM')]">
                                            <occupation xml:lang="ar"><xsl:value-of select="td[@class='contents']"/></occupation>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'SWM'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        <!-- Relationships -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'ILA|MIN|SLT')]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <relation xml:lang="ar" type="{$type}"><desc><xsl:value-of select="td[@class='contents']"/></desc></relation>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="$type"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        <!-- Other -->
                                        <xsl:for-each select="tbody/tr[matches(@class,'AQB|SNF|SRK') and not(matches(@class,'hide'))]">
                                            <xsl:variable name="type" select="replace(@class,'ligne_general ligne ','')"/>
                                            <note xml:lang="ar" type="{$type}"><xsl:value-of select="td[@class='contents']"/></note>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="$type"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        
                                        
                                        <xsl:for-each select="tbody/tr[@class='ligne_reference ligne REF']">
                                            <bibl>
                                                <xsl:attribute name="type">
                                                    <xsl:analyze-string select="td[@class='contents']" regex="^[\s\t\n]*([A-Z]+)">
                                                        <xsl:matching-substring><xsl:value-of select="regex-group(1)"/></xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:attribute>
                                                <xsl:value-of select="normalize-space(td[@class='contents'])"/>
                                            </bibl>
                                            <xsl:call-template name="comments">
                                                <xsl:with-param name="tr" select="."/>
                                                <xsl:with-param name="type" select="'REF'"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </person>
                                </xsl:for-each>
                            </listPerson>
                                                
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:template>
    
        <xsl:template name="comments">
            <xsl:param name="tr"/>
            <xsl:param name="type"/>
            <xsl:if test="string-length(string-join($tr/td[@class='comments'],''))">
                <note xmlns="http://www.tei-c.org/ns/1.0" xml:lang="ar" type="{$type}"><xsl:value-of select="$tr/td[@class='comments']"/></note>
            </xsl:if>
        </xsl:template>
    
</xsl:stylesheet>