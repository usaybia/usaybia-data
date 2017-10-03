xquery version "3.0";

declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace syriaca = "http://syriaca.org";
declare namespace functx = "http://www.functx.com";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";

let $syriaca := doc('/db/apps/scholarnet/data/syriaca/nymTEI-Syriaca.xml')
let $syriaca-names := $syriaca/TEI/text/body/listNym/nym
let $oa := doc('/db/apps/scholarnet/data/oa-tei/nymTEI.xml')
let $oa-names := $oa/TEI/text/body/listNym/nym


    
let $nyms :=
    for $name in $oa-names 
    return
    if ($name/form[@type='simple']=$syriaca-names/form) 
    then 
        let $matching-syriaca-name := $syriaca-names[form=$name/form[@type='simple']]
        return
        element nym {
            $name/form,
            for $usg in $name/usg
            return
            element usg {
                attribute type {$usg/@type}, 
                element measure {
                    attribute type {'occurrences'}, 
                    $usg/measure + $matching-syriaca-name/usg[@type=$usg/@type]/measure
                    
                }
                
            },
            $matching-syriaca-name/usg[not(@type=$name/usg/@type)]
        }
    else $name
    
let $xml-doc :=
    <TEI xmlns="http://www.tei-c.org/ns/1.0"
         xmlns:scholarNET="http://scholarnet.github.io">
       <teiHeader>
          <fileDesc>
             <titleStmt>
                <title>Names from Onomasticon Arabicum and Syriaca.org</title>
             </titleStmt>
             <publicationStmt>
                <p>Publication Information</p>
             </publicationStmt>
             <sourceDesc>
                <p>Information about the source</p>
             </sourceDesc>
          </fileDesc>
       </teiHeader>
       <text>
          <body>
             <listNym>
                 {$nyms}
             </listNym>
         </body>
     </text>
 </TEI>
 
 return xmldb:store('/db/apps/scholarnet/data/','combined-OA-Syriaca-nymTEI.xml',$xml-doc)