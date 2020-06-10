xquery version "3.1";

declare default element namespace 'http://www.tei-c.org/ns/1.0';

let $collection := collection('/db/apps/usaybianet/data/persons/tei/')

let $citedRanges := distinct-values($collection//citedRange)
let $personsInCitedRanges := 
    for $citedRange in $citedRanges[position()<20]
    let $citedRangeRegex := concat('^',$citedRange,'\s*(\.|n|$)')
    let $persons := $collection//person[matches(bibl/citedRange,$citedRangeRegex)]
    return
        for $person at $i in $persons
        let $source-uri := $person/idno
        let $source-name := $person/persName[1]
        let $related-persons := $persons[position()<$i]
        return 
            for $related-person in $related-persons
            let $target-uri := $related-person/idno
            let $target-name := $related-person/persName[1]
            return concat($source-uri,'	',$source-name,'	',$citedRange,'	',$target-uri,'	',$target-name)
            
let $spreadsheet := string-join(('Source URI	Source Name	Cited Range (Edge)	Target URI	Target Name',$personsInCitedRanges),'
')

return 
    xmldb:store('/db/apps/usaybianet/data/persons','citedRangesNetwork.tsv',$spreadsheet)