declare default element namespace "http://www.tei-c.org/ns/1.0";

let $apps := //app[rdg/lb]
let $count := 
    for $app in $apps
    return count($app/rdg/lb/preceding-sibling::node()[not(name())])

return $count