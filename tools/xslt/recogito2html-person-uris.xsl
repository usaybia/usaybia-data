<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" indent="yes" method="html" name="html"/>
    <xsl:template match="/tei:TEI">
        <xsl:variable name="converted-file" select="replace(base-uri(),'^.*/','')"/>
        <xsl:variable name="filename">../../../tools/html/recogito-person-uris-from_<xsl:value-of select="$converted-file"/>.html</xsl:variable>
        <xsl:result-document href="{$filename}" format="html">
        <xsl:variable name="persNames" select="tei:text/tei:body//tei:persName[contains(@ana,'https://usaybia.net/person')]"/>
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <title>Names for matching occuring in Ibn Abī Uṣaybiʿa (1884 Mueller edition)
                        </title>
                    </head>
                    <body>
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>URI</th>
                                </tr>
                            </thead>
                            <tbody>
                        <xsl:for-each select="$persNames">
                            <xsl:variable name="i" select="position()"/>
                                    <tr>
                                        <td><xsl:value-of select="$i"/></td>
                                        <td><xsl:value-of select="."/></td>
                                        <td id="URI{$i}">
                                            <xsl:value-of select="./replace(@ana,'.*?#(https://usaybia.net/person/\d+).*','$1')"/>
                                        </td>
                                    </tr>
                        </xsl:for-each>
                            </tbody>
                        </table>
                    </body>
                </html>
            </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>