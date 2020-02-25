declare namespace functx = "http://www.functx.com";

declare function functx:if-absent
  ( $arg as item()* ,
    $value as item()* )  as item()* {

    if (exists($arg))
    then $arg
    else $value
 } ;
 
declare function functx:replace-multi
  ( $arg as xs:string? ,
    $changeFrom as xs:string* ,
    $changeTo as xs:string* )  as xs:string? {

   if (count($changeFrom) > 0)
   then functx:replace-multi(
          replace($arg, $changeFrom[1],
                     functx:if-absent($changeTo[1],'')),
          $changeFrom[position() > 1],
          $changeTo[position() > 1])
   else $arg
 } ;
 
 let $key-doc := doc('../data/lhom-encoding-key.tsv')
 let $from := 
    for $line at $i in tokenize($key-doc,'\n')
    return if ($i=2) then () else tokenize($line,'	')[1]
 let $to := 
    for $line at $i in tokenize($key-doc,'\n')
    return if ($i=2) then () else tokenize($line,'	')[2]
 let $text :=doc('../data/lhom-personal-names.txt')
 

  
 for $line in $text
    return functx:replace-multi($line,$from,$to)