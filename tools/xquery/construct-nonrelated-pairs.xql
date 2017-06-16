declare default element namespace "http://www.tei-c.org/ns/1.0";

let $this-doc := doc("text-sample-relations.xml")

let $sample-ptr := 'scholarNET:IU'
let $sample-vol := '1'
let $sample-pp := '280'

let $relations := $this-doc//div[bibl[ptr/@target=$sample-ptr and citedRange[@unit='vol']=$sample-vol and citedRange[@unit='pp']=$sample-pp]]/listRelation/relation
let $active := for $relation in $relations return string($relation/@active)
let $passive := for $relation in $relations return string($relation/@passive) 
let $unique := distinct-values(($active,$passive))

let $non-related-pairs := 
    for $person at $i in $unique
        let $related-persons := ($relations[@active=$person]/@passive,$relations[@passive=$person]/@active)
    
        for $other-person at $i2 in $unique
        return if (not($related-persons=$other-person) and $i2 > $i) then 
            concat(string($person),'&#09;',string($other-person))
            else ()
            
return 
    string-join($non-related-pairs,'&#xa;')
