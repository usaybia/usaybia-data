xquery version "3.1";
declare default element namespace 'http://www.tei-c.org/ns/1.0';
declare namespace pkg="http://expath.org/ns/pkg";

(: To prevent crashes from this large operation, memory on the eXist instance should be set to at least 1024m :)
let $pkgdoc := doc("/db/apps/usaybia-data/expath-pkg.xml")
(: Gets the version number from the package metadata as a string. :)
let $current-version := string($pkgdoc/pkg:package/@version)
(: Gets today's date as a string. :)
let $current-date := string(current-date())

let $coll := collection("/db/apps/usaybia-data/data/")

let $old-editions := $coll/TEI/teiHeader/fileDesc/editionStmt/edition/@n
let $old-dates := $coll/TEI/teiHeader/fileDesc/publicationStmt/date

(: Changes version number in TEI documents to match package metadata and changes publication date to today :)
return
    (update value $old-editions with $current-version, update value $old-dates with $current-date)
