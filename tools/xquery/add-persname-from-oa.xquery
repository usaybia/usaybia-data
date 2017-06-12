xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace scholarNET = "http://scholarnet.github.io";
declare namespace functx = "http://www.functx.com";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";

(:declare function scholarNET:normalize-alif-regex($string as xs:string) as xs:string {:)
(:    replace(replace($string,'أ','[اأ]'),'إ','[اإ]'):)
(:};:)
(::)
(:declare function scholarNET:normalize-waw-regex($string as xs:string) as xs:string {:)
(:    replace($string,'ؤ','[ؤو]'):)
(:};:)

declare function scholarNET:add-persNames($nodes as node()*, $names-all-regex-string as xs:string) {
    for $node in $nodes/node()
        return 
            if ($node/node() and $node/name()) then
                element {$node/name()} {
                            $node/@*,
                            scholarNET:add-persNames($node,$names-all-regex-string)}
            else
                let $text-matched := analyze-string($node, $names-all-regex-string)
                for $analyzed-node in $text-matched
                    for $string in $analyzed-node/node()
                    return 
                        if ($string/fn:group) then 
    (:                        Not sure if this will handle spacing correctly :)
                            element persName {$string/fn:group/text()}
                        else 
                            $string/text()
};

let $nymList := doc("../../data/oa-tei/nymTEI.xml")
let $text := doc("../../data/texts/IU/epubTEI.xml")

let $names := $nymList/TEI/text/body/listNym/nym/form[@type='vocalized']

let $names-regex := 
    for $name in $names
    return replace(replace($name,'([ؠ-ي])([ؠ-ي])','$1[ً-ٖ]*$2'),'([ؠ-ي])([ؠ-ي])','$1[ً-ٖ]*$2')
    
let $names-all-regex-string := concat('[\s\t\n^](',string-join($names-regex,')[\s\t\n$]|[\s\t\n^]('),')[\s\t\n$]')

let $text-w-persNames := 
    for $p in $text//p
    let $text-matched := analyze-string($p, $names-all-regex-string)
    for $node in $text-matched
        return element p {
            for $string in $node/node()
                return 
                    if ($string/fn:group) then 
(:                        Not sure if this will handle spacing correctly :)
                        element persName {$string/fn:group/text()}
                    else 
                        $string/text()
        }

return scholarNET:add-persNames($text/node(), $names-all-regex-string)