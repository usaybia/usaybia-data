xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace scholarNET = "http://scholarnet.github.io";
declare namespace functx = "http://www.functx.com";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";

(: set file to convert from epub to TEI  :)
let $epub := doc('../../data/texts/epub/DQ/OEBPS/content.opf')
let $stylesheet := saxon:compile-stylesheet(doc('../xslt/epub2tei.xsl'))

return saxon:transform($stylesheet,$epub)