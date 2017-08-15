<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>
    
        <xsl:template match="/TEI/text/body" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:result-document href="../../data/xgmml/XGMMLfromSPEAR.xgmml" format="xml">
                
                <graph id="sn1" label="Relations from IU Samples" directed="1" cy:documentVersion="3.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:cy="http://www.cytoscape.org" xmlns="http://www.cs.rpi.edu/XGMML">
                    <att name="networkMetadata">
                        <rdf:RDF>
                            <rdf:Description rdf:about="http://www.cytoscape.org/">
                                <dc:type>N/A</dc:type>
                                <dc:description>N/A</dc:description>
                                <dc:identifier>N/A</dc:identifier>
                                <dc:date>2017-06-28</dc:date>
                                <dc:title>Relations from IU Samples</dc:title>
                                <dc:source>IU</dc:source>
                                <dc:format>Cytoscape-XGMML</dc:format>
                            </rdf:Description>
                        </rdf:RDF>
                    </att>
                    <xsl:variable name="distinct-active-passive" select="distinct-values(div/listRelation/relation/(@active|@passive))"/>
                    <xsl:variable name="distinct-mutual" select="tokenize(string-join(div/listRelation/relation/@mutual,' '),'\s+')"/>
                    <xsl:variable name="distinct-persons" select="distinct-values(($distinct-active-passive,$distinct-mutual))"/>
                    <xsl:for-each select="$distinct-persons">
                        <node id="{.}" label="{.}">
                            <att name="shared name" value="{.}" type="string" cy:type="String"/>
                        </node>
                    </xsl:for-each>
                    <xsl:for-each select="div">
                        <xsl:variable name="person1">
                            <xsl:choose>
                                <xsl:when test="listRelation/relation/@active"><xsl:value-of select="listRelation/relation/@active"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="tokenize(listRelation/relation/@mutual,'\s+')[1]"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="person2">
                            <xsl:choose>
                                <xsl:when test="listRelation/relation/@passive"><xsl:value-of select="listRelation/relation/@passive"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="tokenize(listRelation/relation/@mutual,'\s+')[2]"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="edge-id" select="concat($person1,'-',$person2,'-',position())"/>
                        <xsl:variable name="edge-id-reciprocal" select="concat($person2,'-',$person1,'-',position())"/>
                        <xsl:variable name="relation" select="listRelation/relation/@ref"/>
                        <xsl:variable name="mutual">
                            <xsl:choose>
                                <xsl:when test="listRelation/relation/@active">1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <edge id="{$edge-id}" label="{$person1} {$relation} {$person2}" source="{$person1}" target="{$person2}" cy:directed="1">
                            <att name="shared name" value="{$person1} {$relation} {$person2}" type="string" cy:type="String"/>
                            <att name="shared interaction" value="{$relation}" type="string" cy:type="String"/>
                            <att name="relation type" value="{listRelation/relation/@ana}" type="string" cy:type="String"/>
                            <att name="source" value="{bibl/ptr/@target} {string-join(bibl/citedRange,'.')}" type="string" cy:type="String"/>
                            <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                        </edge>
                        <xsl:if test="$mutual">
                            <edge id="{$edge-id-reciprocal}" label="{$person2} {$relation} {$person1}" source="{$person2}" target="{$person1}" cy:directed="1">
                                <att name="shared name" value="{$person2} {$relation} {$person1}" type="string" cy:type="String"/>
                                <att name="shared interaction" value="{$relation}" type="string" cy:type="String"/>
                                <att name="relation type" value="{listRelation/relation/@ana}" type="string" cy:type="String"/>
                                <att name="source" value="{bibl/ptr/@target} {string-join(bibl/citedRange,'.')}" type="string" cy:type="String"/>
                                <att name="selected" value="0" type="boolean" cy:type="Boolean"/>
                            </edge>
                        </xsl:if>
                    </xsl:for-each>                    
                </graph>                
            </xsl:result-document>
        </xsl:template>    
</xsl:stylesheet>