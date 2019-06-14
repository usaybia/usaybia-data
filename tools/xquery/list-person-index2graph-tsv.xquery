xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace usy = "http://usaybia.net/tempNamespace";

declare function usy:clean-bibls($bibls) {
    for $bibl in $bibls
    return normalize-space(replace(replace($bibl,'\.',''),'\s*/\s*','/'))
};

let $index := doc("../../data/texts/tei/DQ-index-listPerson.xml")
let $contents := doc("../../data/dq-contents.xml")

let $chapters := $contents/usy:contents/usy:chapter


let $edges := 
    for $bibl in usy:clean-bibls($index//distinct-values(bibl))
        let $source := replace($bibl,'([A-Z]+).*','$1')
        let $part := replace($bibl,'[A-Z]+\s+(\d+)/.*','$1')
        let $pg := number(replace($bibl,'[A-Z]+.*/(.*)','$1'))
        let $chapter := $chapters[(number(usy:start) le $pg) and (number(usy:end) ge $pg)]
        let $chapter-num := $chapter/usy:number/text()
        let $chapter-title := $chapter/usy:title/text()
        let $persons-matching := $index//person[bibl=$bibl]
        for $person-matching at $i in $persons-matching
            let $persons-other := $persons-matching[position() gt $i]
            for $person in $persons-other                        
                return 
                (
                    $person-matching/persName/text(),
                    '&#9;',
                    $person/persName/text(),
                    '&#9;', 
                    $source,
                    '&#9;', 
                    $part,
                    '&#9;', 
                    $pg,
                    '&#9;',
                    $chapter-num,
                    '&#9;', 
                    $chapter-title,
                    '&#10;'
                    )
    
return $edges
