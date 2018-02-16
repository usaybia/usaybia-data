(: Creates search strings for macro-affiliations to use in Voyant Tools :)

(: The labels to append to each item in $search-strings :)
let $search-labels := (
'Muslim',
'Christian',
'Jewish',
'Zoroastrian',
'Sabian',
'Zindiq',
'Convert-to-Islam')

let $search-strings := (
'حنف*|زيدي*|السنّي*|أنصاري*|خارجي*|صحابي*|إمامي*|مالكي*|شافع*|معتزل*|صوفي*|حنبل*|مرجئ*|أشعر*|علوي*|شيع*|رافض*',
'مسيح*|نسطور*|نصران*|نصارى*|راهب*|سرياني*'
,'يهود*|إسرائيل*'
,'مجوس*'
,'صابئ*'
,'زنديق*',
'اسلم*|*عتنق* الإسلام')

let $prefixes := ('ب','ل','ك','ف','و')

(: If turned on will only search for variants that include any shaddas in above strings. :)
let $require-existing-shadda := 1
(: If turned on will not allow any vowels provided in $search-strings to be absent. If off, will match any specified vowels as well as unvocalized versions, but not alternate vowels. :)
let $require-existing-vowels := 0
(: If turned on will add a search term with the definite article prefixed to the word. :)
let $add-optional-article := 1
(: If turned on will add attached prepositions and conjunctions as optional search strings. :)
let $add-optional-prefixes := 1

for $string at $i in $search-strings
let $existing-vowels := 
    if ($require-existing-vowels) then
        if ($require-existing-shadda) then
            replace(replace($string, '([ً-ِْ-ٖ])','ّ?$1ّ?'),'(ّّ\?([ً-ِْ-ٖ])ّ\?)|(ّ\?([ً-ِْ-ٖ])ّ\?ّ)','(ّ$2$4)|($2$4ّ)') (: optional shadda before / after required vowel, but keeps existing shaddas by replacing optional shaddas with required :)
        else 
            replace(replace($string, '([ً-ِْ-ٖ])','ّ?$1ّ?'),'(ّّ\?)|(ّ\?ّ)','ّ?') (: optional shadda before / after required vowel, ignoring existing shaddas by removing duplicate shaddas :)
    else 
        if ($require-existing-shadda) then
            replace(replace($string, '([ً-ِْ-ٖ])','$1?'),'(ّ([ً-ِْ-ٖ]\?))|(([ً-ِْ-ٖ]\?)ّ)','($2$4ّ)|(ّ$2$4)') (: optional existing vowel + required shadda on either side :)
        else 
            replace(replace($string, '([ً-ٖ])','[ّ$1]*'),'ّ?(\[ّ[ً-ٖ]\]\*)ّ?','$1') (: optional existing vowel + optional shadda, in any order, replacing existing shaddas :)

let $add-vowels := 
    if ($require-existing-shadda) then 
        replace(
            replace(
                replace(
                    $existing-vowels,
                    '([ء-ي])(ّ?)',
                    '$1$2[ً-ِْ-ٖ]*') (: Adds vowel wildcard after all consonants :) 
                ,'\[ً-ِْ-ٖ\]\*([ً-ِْ-ٖ])'
                ,'$1'), (: Then removes wildcard if it is next to an existing vowel. :)
            '([ء-ي])\[ً-ِْ-ٖ\]\*',
            '$1[ً-ٖ]*') (: If there is no shadda normalizes to shadda-agnostic. :)
    else 
        replace(
            replace(
                $existing-vowels,
                '([ء-ي])',
                '$1[ً-ٖ]*') (: Adds vowel wildcard after all consonants :) 
            ,'\[ً-ٖ\]\*([\(ّ])'
            ,'$1') (: Then removes wildcard if it is next to an existing vowel-shadda combo. :)
            
let $remove-final-vowel := (: Removes final vowel because it confuses Voyant Tools. :)
    replace(
        replace($add-vowels,
        '\[ً-ٖ\]\*(\*?)($|\|)',
        '$1$2'),
    '\[ً-ِْ-ٖ\]\*(\*?)($|\|)',
    '$1$2')

let $add-article := 
    if ($add-optional-article) then
     (: Duplicates each segment of the search string, adding the article on the front of one. 
     Then removes any back-to-back | characters created in the process. :) 
        replace(
            replace($remove-final-vowel,'(.*?[\|$])','$1|الْ?$1'),
            '\|\|',
            '|')
    else $remove-final-vowel

let $add-prefixes := 
    if ($add-optional-prefixes) then 
        let $prefixes-to-add := concat(string-join($prefixes,'?[ً-ِْ-ٖ]?'),'?[ً-ِْ-ٖ]?')
        (: Breaks string into segments by | character and adds prefix query to each string, then rejoins them. :)
        let $prefixes-added := concat($prefixes-to-add,string-join(tokenize($add-article,'\|'),concat('|',$prefixes-to-add)))
        (: Accounts for elided ا when preposition ل is added producing لل instead of لال. 
        Duplicates the form with the article (if present) and creates an additional form with لل in place 
        of the article. :)
        return replace(
            replace(
                $prefixes-added,
                concat('((',$prefixes-to-add,')(الْ\?)(.*?[\|$]))'),
                '$1|لِ?لْ?$4'),
            '\|\|',
            '|')
    else $add-article

let $normalize-alif := replace($add-prefixes,'ا','[آاإأ]')
let $normalize-ya := replace($normalize-alif,'ى','[يىئ]')
let $normalize-waw := replace($normalize-ya,'و','[وؤ]')

return (concat($search-labels[$i],': '),$normalize-waw,'
')