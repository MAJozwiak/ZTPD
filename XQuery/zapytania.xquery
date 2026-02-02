(: Zad.5 :)
for $l in doc("db/bib/bib.xml")//book/author/last
return $l

(: Zad.6:)
for $b in doc("db/bib/bib.xml")//book
for $t in $b/title
for $a in $b/author
return
  <ksiazka>
    <title>{ data($t) }</title>
    <author>{ $a }</author>
  </ksiazka>

(: Zad.7 :)
for $b in doc("db/bib/bib.xml")/bib/book
for $t in $b/title
for $a in $b/author
return
    <książka>
        <autor>
          {concat($a/last,$a/first)}
        </autor>
        <tytul>
          {$t/text()}
        </tytul>
    </książka>



(: Zad.8 :)
for $b in doc("db/bib/bib.xml")//book
for $t in $b/title
for $a in $b/author
return
  <ksiazka>
    <autor>{ $a/last || " " || $a/first }</autor>
    <tytul>{ data($t) }</tytul>
  </ksiazka>


(: Zad.9  :)
<wynik>
{
for $b in doc("db/bib/bib.xml")/bib/book
for $t in $b/title
for $a in $b/author
return
    <książka>
        <autor>
          {concat($a/last," ",$a/first)}
        </autor>
        <tytul>
          {$t/text()}
        </tytul>
    </książka>
}
</wynik>

(: Zad.10 :)
<imiona>{
  for $f in doc("db/bib/bib.xml")//book[title="Data on the Web"]/author/first
  return <imie>{ data($f) }</imie>
}</imiona>


(: Zad.11:)

(: <DataOnTheWeb>{ doc("db/bib/bib.xml")//book[title="Data on the Web"] }</DataOnTheWeb> :)

(: 11b. :)
<DataOnTheWeb>
{
for $p in doc("db/bib/bib.xml")/bib/book
where $p/title="Data on the Web"
return $p
}
</DataOnTheWeb>


(: Zad.12 :)
<Data>{
  for $a in doc("db/bib/bib.xml")//book[contains(title, "Data")]/author
  return <nazwisko>{ data($a/last) }</nazwisko>
}</Data>

(: Zad.13 :)
for $b in doc("db/bib/bib.xml")//book[contains(title, "Data")]
return
  <Data>
    <title>{ data($b/title) }</title>
    {
      for $a in $b/author
      return <nazwisko>{ data($a/last) }</nazwisko>
    }
  </Data>

(: Zad.14 :)
for $b in doc("db/bib/bib.xml")//book
where count($b/author) <= 2
return $b/title


(: Zad.15 :)
for $b in doc("db/bib/bib.xml")//book
return
  <ksiazka>
    { $b/title }
    <autorow>{ count($b/author) }</autorow>
  </ksiazka>


(: Zad.16 :)
let $years := doc("db/bib/bib.xml")//book/@year ! xs:integer(.)
return <przedział>{ min($years) || " - " || max($years) }</przedział>

(: zad.17 :)
let $max := max(doc("db/bib/bib.xml")//book/price)
let $min := min(doc("db/bib/bib.xml")//book/price)
return
<różnica>
  {$max - $min}
</różnica>

(: zad.18 :)
let $minP := min(doc("db/bib/bib.xml")//book/price ! xs:decimal(.))
return
  <najtańsze>{
    for $b in doc("db/bib/bib.xml")//book[xs:decimal(price) = $minP]
    return
      <najtańsza>
        { $b/title }
        { $b/author }
      </najtańsza>
  }</najtańsze>

(: zad.19 :)
for $a in distinct-values(doc("db/bib/bib.xml")//book/author/last)
let $b := doc("db/bib/bib.xml")//book[author/last = $a]/title
return
  <autor>
    <last>{$a}</last>
    {$b}
  </autor>

(: Zad.20 :)
<wynik>{
  for $p in collection("db/shakespeare")//PLAY
  return <TITLE>{ data($p/TITLE) }</TITLE>
}</wynik>

(: Zad.21:)
for $s in collection("db/shakespeare")/PLAY
where some $l in $s//LINE satisfies contains($l, "or not to be")
return $s/TITLE

(: Zad.22:)
<wynik>
{
  for $s in collection("db/shakespeare")/PLAY
  return
  <sztuka tytul='{$s/TITLE}'>
    <postaci>{count($s//PERSONA)}</postaci>
    <aktow>{count($s//ACT)}</aktow>
    <scen>{count($s//SCENE)}</scen>
  </sztuka>
}
</wynik>