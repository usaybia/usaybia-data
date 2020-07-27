declare default element namespace "http://www.tei-c.org/ns/1.0";

(: Gets the number of persons in each OA source by macro-affiliation. The output is formatted to be saved as a CSV spreadsheet :)

let $OA := doc('../../data/oa-tei/TEIfromOA-all.xml')

let $source-types := ('DQ','HQ','IU','SD','YT')
let $affiliation-keys := ('Muslim','Christian','Jewish','Zoroastrian','Sabian','Zindiq','Convert-to-Islam')

let $data := 
    for $affiliation in $affiliation-keys
        let $row := 
            for $type in $source-types
            return string(count($OA//person[bibl/@type=$type and faith/@key=$affiliation]))
        return ('
', $affiliation,',',string-join($row,','))
    
return (',',string-join($source-types,','),$data)