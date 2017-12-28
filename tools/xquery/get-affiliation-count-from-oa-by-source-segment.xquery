declare default element namespace "http://www.tei-c.org/ns/1.0";

(: Gets the number of persons in each OA source by macro-affiliation. The output is formatted to be saved as a CSV spreadsheet :)

let $OA := doc('../../data/oa-tei/TEIfromOA-all.xml')

let $source-segment-names := ('IU1','IU2','IU3','IU4','IU5','IU6','IU7','IU8','IU9','IU10','IU11','IU12','IU13','IU14','IU15','IU16','IU17','IU18','IU19','IU20','IU21','IU22','IU23','IU24','IU25','IU26','IU27','IU28','IU29','IU30')
let $source-segments := ('1,1,1,11','1,12,1,22','1,23,1,33','1,34,1,44','1,45,1,55','1,56,1,66','1,67,1,77','1,78,1,88','1,89,1,99','1,100,1,110','1,111,1,121','1,122,1,132','1,133,1,143','1,144,1,154','1,155,1,165','1,166,1,176','1,177,1,187','1,188,1,198','1,199,1,209','1,210,1,220','1,221,1,231','1,232,1,242','1,243,1,253','1,254,1,264','1,265,1,275','1,276,1,286','1,287,1,297','1,298,1,308','1,309,1,319','1,320,2,4')
let $affiliation-keys := ('Muslim','Christian','Jewish','Zoroastrian','Sabian','Zindiq','Convert-to-Islam')

let $data := 
    for $affiliation in $affiliation-keys
        let $row := 
            for $segment in $source-segments
            let $vols-pgs := tokenize($segment,',')
            let $start-vol := $vols-pgs[1]
            let $start-vol-search-string := concat('IU,\s*[Tt]\.\s*',$start-vol,',*\s*[Pp]\.\s*')
            let $start-pg := $vols-pgs[2]
            let $end-vol := $vols-pgs[3]
            let $end-vol-search-string := concat('IU,\s*[Tt]\.\s*',$end-vol,',*\s*[Pp]\.\s*')
            let $end-pg := $vols-pgs[4]
            let $pg-search-string := 'IU,\s*[Tt]\.\s*\d+,*\s*[Pp]\.\s*'
            let $matching-persons := 
                if ($start-vol=$end-vol) then 
                    $OA//person[faith/@key=$affiliation and bibl[matches(.,$start-vol-search-string) and number(replace(.,$pg-search-string,''))>=number($start-pg) and number(replace(.,$pg-search-string,''))<=number($end-pg)]]
                else
                    $OA//person[faith/@key=$affiliation and bibl[(matches(.,$start-vol-search-string) and number(replace(.,$pg-search-string,''))>=number($start-pg)) or (matches(.,$end-vol-search-string) and number(replace(.,$pg-search-string,''))<=number($end-pg))]]
            return string(count($matching-persons))
        return ('
', $affiliation,',',string-join($row,','))
    
return (',',string-join($source-segment-names,','),$data)