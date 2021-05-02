xquery version "3.1";
declare default element namespace 'http://www.tei-c.org/ns/1.0';
declare namespace pkg="http://expath.org/ns/pkg";

let $pkgdoc := doc("/db/apps/usaybia-data/expath-pkg.xml")
(: This should be a string which gets put into the @n of the edition. 
 It needs to be @n not @ value to be TEI-compliant. :)
let $current-version := string($pkgdoc/pkg:package/@version)
(: changed the this to a string value as well :)
let $current-date := string(current-date())

(: removed /persons/ to include all subfolders  :)
let $coll := collection("/db/apps/usaybia-data/data/")

(: $coll/ works, $coll// does not :)
let $old-editions := $coll/TEI/teiHeader/fileDesc/editionStmt/edition/@n
let $old-dates := $coll/TEI/teiHeader/fileDesc/publicationStmt/date

(: this works for me as well, I hope for you as well :)
return
    (update value $old-editions with $current-version, update value $old-dates with $current-date)
