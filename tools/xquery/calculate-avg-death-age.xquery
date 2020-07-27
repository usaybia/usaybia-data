xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";


declare function functx:is-a-number
  ( $value as xs:anyAtomicType? )  as xs:boolean {

   string(number($value)) != 'NaN'
 } ;

let $doc := doc("/Users/nathan/Academic/Other Projects/ScholarNET-data/data/oa-tei/TEIfromOA-all.xml")
 
let $persons := $doc/TEI/text/body/listPerson/person

let $ages := $persons/death/note[@type='UMT' and functx:is-a-number(.)]

let $ages-from-dates := 
    for $person in $persons[death/date[@when or (@notBefore and @notAfter)] and ./birth/date[@when or (@notBefore and @notAfter)] and not(./death/note[@type='UMT' and functx:is-a-number(.)])]
    
    let $deathYears := 
            for $date in $person/death/date[@when or (@notBefore and @notAfter)]
            return
                if ($date/@when) then number($date/@when)
                else number($date/@notBefore + (($date/@notAfter - $date/@notBefore) div 2))
                
    let $birthYears := 
        for $date in $person/birth/date[@when or (@notBefore and @notAfter)]
            return
                if ($date/@when) then number($date/@when)
                else number($date/@notBefore + (($date/@notAfter - $date/@notBefore) div 2))        
            
    return avg($deathYears) - avg($birthYears)
        
return avg(($ages,$ages-from-dates))
    
    