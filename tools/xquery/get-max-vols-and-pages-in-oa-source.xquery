declare default element namespace "http://www.tei-c.org/ns/1.0";

let $doc := doc('../../data/oa-tei/TEIfromOA-all.xml')

let $bibls := $doc//bibl

let $matching-bibl := $bibls[matches(.,'SD,')]

let $vols :=
for $bibl in $matching-bibl
return replace(replace($bibl,'SD,\s*[Tt]\.\s*',''),',*\s*[Pp]\.\s*\d+','')

let $pages := 
for $vol in distinct-values($vols)
let $search-string := concat( 'SD,\s*[Tt]\.\s*',$vol,',*\s*[Pp]\.\s*')
let $matching-pages := $matching-bibl[matches(.,$search-string)]
let $extracted-pages := for $page in $matching-pages
return number(replace($page,$search-string,''))

return ($vol,max($extracted-pages))


return $pages