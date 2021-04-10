xquery version "3.1";
declare default element namespace 'http://www.tei-c.org/ns/1.0';
declare namespace pkg="http://expath.org/ns/pkg";

let $pkgdoc := doc("/db/apps/usaybia-data/expath-pkg.xml")
let $corver := $pkgdoc/pkg:package/@version

let $coll := collection("/db/apps/usaybia-data/data/persons/tei/")
let $oldver := $coll/TEI/teiHeader/fileDesc/editionStmt/edition/@n

return 
    (update insert $corver following $oldver, update delete $oldver)
