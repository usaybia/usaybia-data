xquery version "3.1";
declare default element namespace 'http://www.tei-c.org/ns/1.0';
declare namespace pkg="http://expath.org/ns/pkg";

let $pkgdoc := doc("/db/apps/usaybia-data/expath-pkg.xml")
let $corver := $pkgdoc/pkg:package/@version

let $currentdate := <date>
{current-date()
}
</date>

let $coll := collection("/db/apps/usaybia-data/data/")

let $oldver := $coll/TEI/teiHeader/fileDesc/editionStmt/edition/@version
let $olddate := $coll/TEI/teiHeader/fileDesc/publicationStmt/date

return 
    (update insert $corver following $oldver, update delete $oldver,update insert $currentdate following $olddate, update delete $olddate)
