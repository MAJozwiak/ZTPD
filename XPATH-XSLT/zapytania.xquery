(:for $k in doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')//KRAJ:)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:where starts-with($k/NAZWA, 'A'):)
(:where substring($k/NAZWA, 1, 1) = substring($k/STOLICA, 1, 1):)
(:return <KRAJ>:)
(:  {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:Zad 32 XPath zesp_prac.xml:)
(:NAZWISKO:)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')//PRACOWNICY/ROW/NAZWISKO:)

(:Zad 33 SYSTEMY EKSPERCKIE:)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')/ZESPOLY/ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)

(:Zad 34 ID=10:)
(:count(doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml'):)
(:  /ZESPOLY/ROW[ID_ZESP=10]/PRACOWNICY/ROW ):)

(:Zad 35 SZEF ID=100:)
(:doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_SZEFA=100]/NAZWISKO:)

(:Zad 36 SUMA PŁAC:)
sum(doc('/Users/marta/PycharmProjects/ztpd_in/XPATH-XSLT/zesp_prac.xml')
  //PRACOWNICY/ROW[ID_ZESP = //PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]/PLACA_POD
)

