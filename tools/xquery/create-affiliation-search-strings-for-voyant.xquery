declare namespace scholarNET='https://scholarnet.github.io/';

declare variable $voyantCorpusID :='a05c92769b2183e6e05332abe89c9fde';

declare variable $search-string-file := doc('../pre-voyant-search-strings.tsv');

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
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1(ّ)?'),'((ّ)\(ّ\)\?([ً-ِْ-ٖ])\(ّ\)\?)|(\(ّ\)\?([ً-ِْ-ٖ])\(ّ\)\?(ّ))','(ّ)$3$5') (: optional shadda before / after required vowel, but keeps existing shaddas by replacing optional shaddas with required. :)
            (: NB: Looks for required shadda only before required vowel, since Voyant does not seem to support parentheses. :)
        else 
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1(ّ)?'),'((ّ)\(ّ\)\?)|(\(ّ\)\?(ّ))','(ّ)?') (: optional shadda before / after required vowel, ignoring existing shaddas by removing duplicate shaddas :)
    else 
        if ($require-existing-shadda) then
            replace(replace($search-string, '([ً-ِْ-ٖ])','(ّ)?$1?(ّ)?'),'((ّ)\(ّ\)\?([ً-ِْ-ٖ]\?)\(ّ\)\?)|(\(ّ\)\?([ً-ِْ-ٖ]\?)\(ّ\)\?(ّ))','(ّ)$3$5') (: required shadda + optional existing vowel :)
            (: NB: Looks for required shadda only before optional vowel, since Voyant does not seem to support parentheses. :)
        else 
            replace(replace($search-string, '([ً-ٖ])','[(ّ)$1]*'),'(ّ)?(\[\(ّ\)[ً-ٖ]\]\*)(ّ)?','$1') (: optional existing vowel + optional shadda, in any order, replacing existing shaddas :)
};

declare function scholarNET:add-vowels($search-string as xs:string) as xs:string { 

if ($require-existing-shadda) then 
        replace(
            replace(
                replace(
                    $search-string,
                    '([ء-ي])((\(ّ\))?\??)',
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

(: Removes final vowel because it confuses Voyant Tools. :)
declare function scholarNET:removeFinalVowel($search-string as xs:string) as xs:string {
    replace(
        replace($search-string,
        '\[ً-ٖ\]\*(\*?)($|\|)',
        '$1$2'),
    '\[ً-ِْ-ٖ\]\*(\*?)($|\|)',
    '$1$2')
};

declare function scholarNET:addArticle($search-string as xs:string) as xs:string {
    if ($add-optional-article) then
         (: Duplicates each segment of the search string, adding the article on the front of one. :) 
            replace($search-string,'(.+)','$1|الْ?$1')
        else $search-string
};

declare function scholarNET:addPrefixes($search-string as xs:string) as xs:string {
    if ($add-optional-prefixes) then 
            let $prefixes-to-add := concat(string-join($prefixes,'?[ً-ِْ-ٖ]?'),'?[ً-ِْ-ٖ]?')
            (: Breaks string into segments by | character and adds prefix query to each string, then rejoins them. :)
            let $prefixes-added := concat($prefixes-to-add,string-join(tokenize($search-string,'\|'),concat('|',$prefixes-to-add)))
            (: Accounts for elided ا when preposition ل is added producing لل instead of لال. 
            Duplicates the form with the article (if present) and creates an additional form with لل in place 
            of the article. :)
            return if (string-length(normalize-space($search-string))) then 
            replace(
                replace(
                    $prefixes-added,
                    concat('((',$prefixes-to-add,')(الْ\?)(.+?(\||$)))'),
                    '$1|لِ?لْ?$4'),
                '\|\|',
                '|')
            else $search-string
        else $search-string
};

declare function scholarNET:normalizeAYW($search-string as xs:string) as xs:string {
let $normalize-alif := replace($search-string,'ا','[آاإأ]')
let $normalize-ya := replace($normalize-alif,'ى','[يىئ]')
return replace($normalize-ya,'و','[وؤ]')
};

declare function scholarNET:voyantSearchString($search-string as xs:string) as xs:string {
    replace(
        scholarNET:normalizeAYW(
            scholarNET:addPrefixes(
                scholarNET:addArticle(
                    scholarNET:removeFinalVowel(
                        scholarNET:add-vowels(
                            scholarNET:process-shadda($search-string)
                            )
                        )
                    )
                )
            ),
       '\(ّ\)','ّ')
};

let $rows := tokenize($search-string-file/root,'\n')

let $processed-rows := 
    for $row in $rows[position()>1]
        let $cells := tokenize($row,'\t')
        let $label := $cells[1]
        let $search-strings :=
            for $cell in $cells[position()>1]
            return (scholarNET:voyantSearchString($cell))
        let $cluster := string-join($cells[position()>1 and string-length(.)],'|')
        let $search-strings-combined := replace(string-join($search-strings,'|'),'\|+\s*$','')
        let $search-url := 
            concat(
                    'http://voyant-tools.org/?corpus=',
                    $voyantCorpusID,
                    '&amp;view=Contexts&amp;query=',
                    escape-html-uri($search-strings-combined),
                    '&amp;context=50&amp;expand=500')
        return (string-join(($label,$search-strings-combined,$cluster,$search-url),'&#9;'),'
')

return (
    concat(string-join(('Macro-affiliation','Search String','Search Cluster','Link (replace ampersands)'),'&#9;'),'       
'),
    $processed-rows
    )