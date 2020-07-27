<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/root">
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
                <edge id="{Active_Internal_ID}-{Passive_Internal_ID}"
                    label="{Active_Internal_ID}-{Passive_Internal_ID}"
                    source="{Active_Internal_ID}"
                    target="{Passive_Internal_ID}"
                    cy:directed="0">
                    <att name="shared name"
                        value="{Active_Internal_ID}-{Passive_Internal_ID}"
                        type="string"
                        cy:type="String"/>
                    <att name="shared interaction"
                        value="{Active_Relation}"
                        type="string"
                        cy:type="String"/>
                </edge>
            </xsl:for-each>
        </graph>
    </xsl:template>
</xsl:stylesheet>