(:Zad 26:)
(: for $k in doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')/SWIAT/KONTYNENTY/KONTYNENT
   return <KRAJ> { $k/NAZWA, $k/STOLICA } </KRAJ> :)

(:Zad 27:)
(: for $k in doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ
return <KRAJ>
  { $k/NAZWA, $k/STOLICA }
</KRAJ> :)

(: Zad 28:)
(: for $k in doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(string(NAZWA),'A')]
   return <KRAJ>{ $k/NAZWA, $k/STOLICA }</KRAJ> :)

(: Zad 29 :)
(: for $k in doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[substring(string(NAZWA),1,1) = substring(string(STOLICA),1,1)]
   return <KRAJ>{ $k/NAZWA, $k/STOLICA }</KRAJ> :)

(:Zad 32::)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')//PRACOWNICY/ROW/NAZWISKO:)

(:Zad 33::)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)

(:Zad 34::)
(:count(doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml'):)
(:  /ZESPOLY/ROW[ID_ZESP=10]/PRACOWNICY/ROW ):)

(:Zad 35:)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_SZEFA=100]/NAZWISKO:)

(:Zad 36:)
sum(doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')
  //PRACOWNICY/ROW[ID_ZESP = //PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]/PLACA_POD
)

