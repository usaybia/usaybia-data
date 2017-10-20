(: Creates search strings for macro-affiliations to use in Voyant Tools :)

let $search-labels := (
'Muslim',
'Christian',
'Jewish',
'Zoroastrian',
'Sabian',
'Zindiq',
'Convert-to-Islam')

let $search-strings := (
'حنف*|زيدي*|السني*|أنصاري*|خارجي*|صحابي*|إمامي*|مالكي*|شافع*|معتزل*|صوف*|عارِف  بالله*|حنبل*|مرجئ*|أشعر*|علوي*|شيع*|رافض*|مسلم',
'مسيح*|نسطور*|نصران*|راهب*|سرياني*'
,'يهود*|إسرائيل*'
,'مجوس*'
,'صابئ*'
,'زنديق*',
'اسلم*|*عتنق* الإسلام')

for $string at $i in $search-strings
let $add-vowels := replace($string, '([ؠ-ي])', '$1[ً-ٖ]?')
    let $normalize-alif := replace($add-vowels,'ا','[آاإأ]')
    let $normalize-ya := replace($normalize-alif,'ى','[يىئ]')
    let $normalize-waw := replace($normalize-ya,'و','[وؤ]')

return (concat($search-labels[$i],': '),$normalize-waw,'
')