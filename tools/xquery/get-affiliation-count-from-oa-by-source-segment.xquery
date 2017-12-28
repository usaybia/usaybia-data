declare default element namespace "http://www.tei-c.org/ns/1.0";

(: Gets the number of persons in each OA source by macro-affiliation. The output is formatted to be saved as a CSV spreadsheet :)

let $OA := doc('../../data/oa-tei/TEIfromOA-all.xml')

let $source-segment-names := ('SD1','SD2','SD3','SD4','SD5','SD6','SD7','SD8','SD9','SD10','SD11','SD12','SD13','SD14','SD15','SD16','SD17','SD18','SD19','SD20','SD21','SD22','SD23','SD24','SD25','SD26','SD27','SD28','SD29','SD30')
let $source-segments := ('1,1,1,182','1,183,1,364','1,365,2,142','2,142,2,323','2,324,3,28','3,28,3,209','3,210,3,391','3,392,4,150','4,150,4,331','4,332,4,513','4,514,5,171','5,171,5,352','5,353,6,107','6,107,6,288','6,289,6,470','6,471,7,87','7,87,7,268','7,269,7,450','7,451,7,632','7,633,8,16','8,16,8,197','8,198,8,379','8,380,8,561','8,562,9,118','9,118,9,299','9,300,9,481','9,482,10,112','10,112,10,293','10,294,10,475','10,476,10,657')
let $affiliation-keys := ('Muslim','Christian','Jewish','Zoroastrian','Sabian','Zindiq','Convert-to-Islam')

let $data := 
    for $affiliation in $affiliation-keys
        let $row := 
            for $segment in $source-segments
            let $vols-pgs := tokenize($segment,',')
            let $start-vol := $vols-pgs[1]
            let $start-vol-search-string := concat('SD,\s*[Tt]\.\s*',$start-vol,',*\s*[Pp]\.\s*')
            let $start-pg := $vols-pgs[2]
            let $end-vol := $vols-pgs[3]
            let $end-vol-search-string := concat('SD,\s*[Tt]\.\s*',$end-vol,',*\s*[Pp]\.\s*')
            let $end-pg := $vols-pgs[4]
            let $pg-search-string := 'SD,\s*[Tt]\.\s*\d+,*\s*[Pp]\.\s*'
            let $matching-persons := 
                if ($start-vol=$end-vol) then 
                    $OA//person[faith/@key=$affiliation and bibl[matches(.,$start-vol-search-string) and number(replace(.,$pg-search-string,''))>=number($start-pg) and number(replace(.,$pg-search-string,''))<=number($end-pg)]]
                else
                    $OA//person[faith/@key=$affiliation and bibl[(matches(.,$start-vol-search-string) and number(replace(.,$pg-search-string,''))>=number($start-pg)) or (matches(.,$end-vol-search-string) and number(replace(.,$pg-search-string,''))<=number($end-pg))]]
            return string(count($matching-persons))
        return ('
', $affiliation,',',string-join($row,','))
    
return (',',string-join($source-segment-names,','),$data)