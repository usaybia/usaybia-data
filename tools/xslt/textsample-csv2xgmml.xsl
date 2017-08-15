<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml"/>    
    <xsl:template match="/root">
        <xsl:result-document href="../xgmml/text-sample-persons.xgmml" format="xml">
            <graph xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:cy="http://www.cytoscape.org"
                xmlns="http://www.cs.rpi.edu/XGMML"
                id="sn1"
                label="Scholar Net test"
                directed="0"
                cy:documentVersion="3.0">
                <xsl:for-each select="row">
                    <node id="{Internal_ID}" label="{Internal_ID}">
                        <att name="shared name"
                            value="{Internal_ID}"
                            type="string"
                            cy:type="String"/>
                        <att name="name"
                            value="{Person_Name_EN}"
                            type="string"
                            cy:type="String"/>
                        <att name="affiliation"
                            value="{Standardized_Affiliation_1}"
                            type="string"
                            cy:type="String"/>
                    </node>
                </xsl:for-each>
            </graph>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>