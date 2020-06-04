xquery version "3.1";

(:Have attempted to strip LTR override characters in @n using \p{Cf} but this doesn't seem to work.
  This doesn't seem to be able to correctly update all items -- does about 600 then doesn't tag the rest. 
  Maybe has something to do with lists inside lists? 
  Could try doing smaller batches at a time or doing find/replace for titles and then incrementing URIs somehow. :)

declare default element namespace "http://www.tei-c.org/ns/1.0";

let $collection := collection("/db/apps/usaybianet/data/texts/tei")
let $next-limit := 500

for $item at $i in ($collection//list/item)[position()<=$next-limit]
return if ($item[not(title)]) then 
let $section-number := $item/parent::list/preceding-sibling::p[hi][1]/hi/text()[1]
let $section-number-sanitized := normalize-space(replace(replace(replace($section-number,".*\[", ""),"\].*",""),"\p{Cf}",""))
let $item-number := replace(concat("no",replace($item/preceding-sibling::label[1]/text()[1],"(\d+).*","$1")),"\p{Cf}","")
let $title := 
    element title {
        attribute ref {concat("https://usaybia.net/work/",$i)},
        attribute n {replace(concat($section-number-sanitized,$item-number),"\p{Cf}","")},
        attribute change {"#change-1"},
        attribute cert {"low"},
        $item/node()
    }
    
let $item-new := 
    element item {
        $item/@*,
        $title
    }

return 
    (update insert $item-new following $item, update delete $item)
else ()