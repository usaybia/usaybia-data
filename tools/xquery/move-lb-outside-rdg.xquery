declare default element namespace "http://www.tei-c.org/ns/1.0";

let $doc := doc('../../data/texts/transkribus/IU-vol2-2b_2-collatex-tokenized.xml')
let $apps := $doc//app[rdg/lb]
let $lines := 
    for $app in $apps
    return $app/rdg/node()[not(name()='lb')]

let $words-per-line := 
    for $line in $lines 
    return tokenize($line,'[\s\n\t]+') 
    
return $words-per-line

(: Word count before and after line breaks 
seems to be quite stable between the two 
texts so can use that to determine where the 
line break should fall in the alignment. :)