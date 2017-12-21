declare default element namespace "http://www.tei-c.org/ns/1.0";

for $p in //p
let $bibls := for $bibl in tokenize($p,',')
return <bibl>DQ {$bibl}</bibl>
return 
if (count($bibls)>1) then
<person>
<persName>
{tokenize($p,',')[1]}
</persName>
{$bibls[position()>1]}
</person>
else ()