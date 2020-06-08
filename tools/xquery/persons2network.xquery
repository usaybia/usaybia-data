xquery version "3.1";

declare default element namespace 'http://www.tei-c.org/ns/1.0';
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $collection := collection('/db/apps/usaybianet/data/persons/tei/')

let $citedRanges := distinct-values($collection//citedRange)
let $peopleInCitedRanges := 
    for $citedRange in $citedRanges
    let $citedRangeRegex := concat('^\s*',$citedRange,'\s*(\.|n|$)')
    let $persons := $collection//person[matches(bibl/citedRange,$citedRangeRegex)]
    return 
        for $person at $i in $persons
        let $uri := $person/idno/text()
        let $related-persons := $persons[position()>$i]
        return 
            for $related-person in $related-persons
            let $related-uri := $related-person/idno/text()
            return concat($uri,' ',$citedRange,' ',$related-uri)

return $peopleInCitedRanges