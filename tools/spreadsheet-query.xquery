declare namespace scholarNET='https://scholarnet.github.io/';

declare variable $search-string-file := doc('/Users/ngibson/Academic/Other Projects/ScholarNet-data/tools/pre-voyant-search-strings.csv');

declare variable $prefixes := ('ب','ل','ك','ف','و');

(: If turned on will only search for variants that include any shaddas in above strings. :)
declare variable $require-existing-shadda := 1;

(: If turned on will not allow any vowels provided in $search-strings to be absent. If off, will match any specified vowels as well as unvocalized versions, but not alternate vowels. :)
declare variable $require-existing-vowels := 0;

(: If turned on will add a search term with the definite article prefixed to the word. :)
declare variable $add-optional-article := 1;

(: If turned on will add attached prepositions and conjunctions as optional search strings. :)
declare variable $add-optional-prefixes := 1;

declare function scholarNET:process-shadda($search-string as xs:string) as xs:string {

    if ($require-existing-vowels) then
        if ($require-existing-shadda) then
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1(ّ)?'),'((ّ)\(ّ\)\?([ً-ِْ-ٖ])\(ّ\)\?)|(\(ّ\)\?([ً-ِْ-ٖ])\(ّ\)\?(ّ))','((ّ)$3$5|$3$5(ّ))') (: optional shadda before \ after required vowel, but keeps existing shaddas by replacing optional shaddas with required :)
        else 
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1(ّ)?'),'((ّ)\(ّ\)\?)|(\(ّ\)\?(ّ))','(ّ)?') (: optional shadda before / after required vowel, ignoring existing shaddas by removing duplicate shaddas :)
    else 
        if ($require-existing-shadda) then
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1?(ّ)?'),'((ّ)\(ّ\)\?([ً-ِْ-ٖ]\?)\(ّ\)\?)|(\(ّ\)\?([ً-ِْ-ٖ]\?)\(ّ\)\?(ّ))','($3$5(ّ)|(ّ)$3$5)') (: optional existing vowel + required shadda on either side :)
        else 
            replace(replace($search-string, '([ً-ٖ])','[(ّ)$1]*'),'(ّ)?(\[\(ّ\)[ً-ٖ]\]\*)(ّ)?','$1') (: optional existing vowel + optional shadda, in any order, replacing existing shaddas :)
};

declare function scholarNET:add-vowels($search-string as xs:string) as xs:string { 

if ($require-existing-shadda) then 
        replace(
            replace(
                replace(
                    $search-string,
                    '([ء-ي])(\(ّ\)?\??)',
                    '$1$2[ً-ِْ-ٖ]*') (: Adds vowel wildcard after all consonants (behind any required/optional shaddas) :) 
                ,'\[ً-ِْ-ٖ\]\*([ً-ِْ-ٖ])'
                ,'$1'), (: Then removes wildcard if it is next to an existing vowel. :)
            '([ء-ي])\[ً-ِْ-ٖ\]\*',
            '$1[ً-ٖ]*') (: If there is no shadda normalizes to shadda-agnostic. :)
    else 
        replace(
            replace(
                $search-string,
                '([ء-ي])',
                '$1[ً-ٖ]*') (: Adds vowel wildcard after all consonants :) 
            ,'\[ً-ٖ\]\*([\(ّ])'
            ,'$1') (: Then removes wildcard if it is next to an existing vowel-shadda combo. :)
};

let $rows := tokenize($search-string-file/root,'\n')

let $processed-rows := 
    for $row in $rows[position()>1]
        let $cells := tokenize($row,';')
        let $label := $cells[1]
        let $search-string :=
            for $cell in $cells[position()>1]
            return (scholarNET:add-vowels(scholarNET:process-shadda($cell)))
        let $search-url := 'http'
    return ($row,';',string-join(($search-string,$search-url),';'),'
')
return (
    concat($rows[1],';;
'),
    $processed-rows
    )