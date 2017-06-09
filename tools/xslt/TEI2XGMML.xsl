<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
        <xsl:template match="//body" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:result-document href="XGMMLfromTEI-adjacentEntryTo.xgmml" format="xml">
                
                <graph id="sn1" label="Scholar Net test" directed="0" cy:documentVersion="3.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:cy="http://www.cytoscape.org" xmlns="http://www.cs.rpi.edu/XGMML">
                    <att name="networkMetadata">
                        <rdf:RDF>
                            <rdf:Description rdf:about="http://www.cytoscape.org/">
                                <dc:type>N/A</dc:type>
                                <dc:description>N/A</dc:description>
                                <dc:identifier>N/A</dc:identifier>
                                <dc:date>2017-04-04 10:31:00</dc:date>
                                <dc:title>Scholar Net test</dc:title>
                                <dc:source>N/A</dc:source>
                                <dc:format>Cytoscape-XGMML</dc:format>
                            </rdf:Description>
                        </rdf:RDF>
                    </att>
                    <att name="shared name" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="name" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="selected" value="1" type="boolean" cy:type="Boolean"/>
                    <att name="religious-affiliation-standardized1" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation1" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation-standardized2" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation2" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation-standardized3" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation3" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation-standardized4" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="religious-affiliation4" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref1" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref2" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref3" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref4" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref5" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref6" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref7" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref8" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="ref9" value="Scholar Net test" type="string" cy:type="String"/>
                    <att name="__Annotations" type="list" cy:type="List" cy:elementType="String">
                    </att>
                    
                    <xsl:for-each select="listPerson/person">
                        <xsl:variable name="this-person" select="."/>
                        <xsl:variable name="OA-id" select="idno[@type='OA-ID']/text()"/>
                        <xsl:variable name="ISM" select="persName[@type='ISM'][1]"/>
                        <xsl:variable name="display-name" select="concat($ISM,' - ',$OA-id)"/>
                        <xsl:variable name="begin">
                            <xsl:choose>
                                <xsl:when test="$this-person/birth/date/@when"><xsl:value-of select="$this-person/birth/date/@when"/></xsl:when>
                                <xsl:when test="$this-person/birth/date/@notBefore"><xsl:value-of select="$this-person/birth/date/@notBefore"/></xsl:when>
                                <xsl:when test="$this-person/death/date/@when"><xsl:value-of select="min($this-person/death/date/@when) - 60"/></xsl:when>
                                <xsl:when test="$this-person/death/date/@notBefore"><xsl:value-of select="min($this-person/death/date/@notBefore) - 60"/></xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="end">
                            <xsl:choose>
                                <xsl:when test="$this-person/death/date/@when"><xsl:value-of select="$this-person/death/date/@when"/></xsl:when>
                                <xsl:when test="$this-person/death/date/@notAfter"><xsl:value-of select="$this-person/deat/date/@notAfter"/></xsl:when>
                                <xsl:when test="$this-person/birth/date/@when"><xsl:value-of select="max($this-person/birth/date/@when) + 60"/></xsl:when>
                                <xsl:when test="$this-person/birth/date/@notAfter"><xsl:value-of select="max($this-person/birth/date/@notAfter) + 60"/></xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="places" select="$this-person//placeName"/>
                        <node id="{$OA-id}" label="{$display-name}">
                            <att name="shared name" value="{$display-name}" type="string" cy:type="String"/>
                            <att name="name" value="{$display-name}" type="string" cy:type="String"/>
                            <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                            <xsl:for-each select="faith">
                                <att name="{concat('religious-affiliation-standardized',position())}" value="{@key}" type="string" cy:type="String"/>
                                <att name="{concat('religious-affiliation',position())}" value="{.}" type="string" cy:type="String"/>
                            </xsl:for-each>
                            <xsl:for-each select="bibl">
                                <att name="{concat('ref',position())}" value="{.}" type="string" cy:type="String"/>
                            </xsl:for-each> 
                            <xsl:for-each select="$places">
                                <att name="places" value="{text()}" type="string" cy:type="String"/>
                            </xsl:for-each>
                            <xsl:if test="$begin"><att name="begin" value="{$begin}" type="string" cy:type="String"/></xsl:if>
                            <xsl:if test="$end"><att name="end" value="{$end}" type="string" cy:type="String"/></xsl:if>
                        </node>
                        <!--<xsl:for-each select="following-sibling::person[bibl=$this-person/bibl]">
                            <!-\- does not take into account multiple matching sources -\->
                            <xsl:variable name="other-person" select="."/>
                            <xsl:variable name="other-OA-id" select="idno[@type='OA-ID']/text()"/>
                            <xsl:variable name="other-ISM" select="persName[@type='ISM'][1]"/>
                            <xsl:variable name="other-display-name" select="concat($other-ISM,' - ',$other-OA-id)"/>
                            <xsl:variable name="edge-id" select="concat($OA-id,'-',$other-OA-id,'-p-',position())"/>
                            <xsl:for-each select="$other-person/bibl[.=$this-person/bibl]">
                                <edge id="{$edge-id}" label="{$display-name} (shares page with) {$other-display-name}" source="{$OA-id}" target="{$other-OA-id}" cy:directed="0">
                                    <att name="shared name" value="{$display-name} (shares page with) {$other-display-name}" type="string" cy:type="String"/>
                                    <att name="shared interaction" value="shares page with" type="string" cy:type="String"/>
                                    <att name="name" value="{$display-name} (shares page with) {$other-display-name}" type="string" cy:type="String"/>
                                    <att name="source" value="{.}" type="string" cy:type="String"/>
                                    <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                                    <att name="interaction" value="shares page with" type="string" cy:type="String"/>
                                </edge>
                            </xsl:for-each> 
                        </xsl:for-each>-->
                        <xsl:for-each select="bibl[matches(.,'n°')]">
                            <xsl:variable name="this-bibl" select="."/>
                            <xsl:variable name="entry" select="replace(.,'.*n°\s*(\d+).*','$1')"/>
                            <xsl:variable name="next-entry" select="number($entry) + 1"/>
                            <xsl:variable name="bibl-test" select="replace(.,concat('(n°\s*)',$entry),concat('$1',string($next-entry)))"/>
                            <xsl:variable name="other-person" select="/TEI/text/body/listPerson/person[idno[@type='OA-ID']/text()!=$OA-id and bibl/text()=$bibl-test]"/>
                            <xsl:for-each select="$other-person">
                                <xsl:variable name="other-OA-id" select="idno[@type='OA-ID']/text()"/>
                                <xsl:variable name="other-ISM" select="persName[@type='ISM'][1]"/>
                                <xsl:variable name="other-display-name" select="concat($other-ISM,' - ',$other-OA-id)"/>
                                <xsl:variable name="edge-id" select="concat($OA-id,'-',$other-OA-id,'-n-',position())"/>
                                <edge id="{$edge-id}" label="{$display-name} (adjacent entry to) {$other-display-name}" source="{$OA-id}" target="{$other-OA-id}" cy:directed="0">
                                    <att name="shared name" value="{$display-name} (adjacent entry to) {$other-display-name}" type="string" cy:type="String"/>
                                    <att name="shared interaction" value="adjacent entry to" type="string" cy:type="String"/>
                                    <att name="name" value="{$display-name} (adjacent entry to) {$other-display-name}" type="string" cy:type="String"/>
                                    <att name="source" value="{$this-bibl}" type="string" cy:type="String"/>
                                    <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                                    <att name="interaction" value="adjacent entry to" type="string" cy:type="String"/>
                                </edge>
                            </xsl:for-each>
                        </xsl:for-each>
                        
<!--                        Same time/place -->
                        <!--<xsl:variable name="following-persons" select="$this-person/following-sibling::person"/>
                        <xsl:if test="$places and $begin and $end">
                            <xsl:for-each select="$places">
                                <xsl:variable name="this-place" select="."/>
                                <xsl:for-each select="$following-persons[.//placeName=$this-place and .//date/(@when|@notBefore|@notAfter)]">
                                    <xsl:variable name="other-person" select="."/>
                                    <xsl:if test="$other-person//date[(@when|@notBefore|@notAfter)>=$begin and (@when|@notBefore|@notAfter)&lt;=$end]">
                                        <xsl:variable name="other-OA-id" select="idno[@type='OA-ID']/text()"/>
                                        <xsl:variable name="other-ISM" select="persName[@type='ISM'][1]"/>
                                        <xsl:variable name="other-display-name" select="concat($other-ISM,' - ',$other-OA-id)"/>
                                        <xsl:variable name="edge-id" select="concat($OA-id,'-',$other-OA-id,'-','timeplace-',position())"/>
                                        <xsl:variable name="edge-interaction" select="'shares timeplace with'"/>
                                        <xsl:variable name="edge-label" select="string-join(($display-name,'(',$edge-interaction,')',$other-display-name,'at',$this-place,'during',$begin,'-',$end),' ')"/>
                                        <edge id="{$edge-id}" label="{$edge-label}" source="{$OA-id}" target="{$other-OA-id}" cy:directed="0">
                                            <att name="shared name" value="{$edge-label}" type="string" cy:type="String"/>
                                            <att name="shared interaction" value="{$edge-interaction}" type="string" cy:type="String"/>
                                            <att name="name" value="{$edge-label}" type="string" cy:type="String"/>
                                            <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                                            <att name="interaction" value="{$edge-interaction}" type="string" cy:type="String"/>
                                        </edge>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>                            
                        </xsl:if>-->
                        
                        <!--<xsl:for-each select="following-sibling::person[//placeName=$this-person//placeName]">
                            
                            <xsl:for-each select="$other-person//placeName[.=$this-person//placeName]">
                                
                            </xsl:for-each> 
                        </xsl:for-each>-->
                    </xsl:for-each>
                    
                </graph>
                
            </xsl:result-document>
        </xsl:template>
    
</xsl:stylesheet>