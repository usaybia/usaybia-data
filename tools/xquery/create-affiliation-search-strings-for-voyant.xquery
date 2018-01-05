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
'حنف*|زيدي*|السني*|أنصاري*|خارجي*|صحابي*|إمامي*|مالكي*|شافع*|معتزل*|صوفي*|حنبل*|مرجئ*|أشعر*|علوي*|شيع*|رافض*',
'مسيح*|نسطور*|نصران*|راهب*|سرياني*'
,'يهود*|إسرائيل*'
,'مجوس*'
,'صابئ*'
,'زنديق*',
'اسلم*|*عتنق* الإسلام')

(: If turned on will not allow any vowels provided in $search-strings to be absent. If off, will match any specified vowels as well as unvocalized versions, but not alternate vowels. :)
let $require-existing-vowels := 0

for $string at $i in $search-strings
let $existing-vowels := 
    if ($require-existing-vowels) 
    then replace($string, '([ً-ٖ])','ّ?$1ّ?') (: optional shadda before / after vowel :)
    else replace($string, '([ً-ٖ])','[ّ$1]*') (: optional vowel + optional shadda :)

let $add-vowels := replace(replace($existing-vowels,'([ء-ي])','$1[ً-ٖ]?'),'\[ً-ٖ\]\?(\[[ً-ٖ]+\]\*)','$1')  (: Adds vowel wildcard after all consonants, then removes wildcard if it is next to an existing vowel. :)
let $normalize-alif := replace($add-vowels,'ا','[آاإأ]')
let $normalize-ya := replace($normalize-alif,'ى','[يىئ]')
let $normalize-waw := replace($normalize-ya,'و','[وؤ]')

return (concat($search-labels[$i],': '),$normalize-waw,'
')