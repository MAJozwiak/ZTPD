--ZAD 1 Zdefiniuj typ obiektowy reprezentujący SAMOCHOD. Każdy samochód powinien mieć markę, model, liczbę kilometrów oraz datę produkcji i cenę. Stwórz tabelę obiektową SAMOCHODY i wprowadź kilka przykładowych obiektów. Wyświetl zawartość tabeli.

CREATE TYPE samochod AS OBJECT (
    marka VARCHAR2(20),
    model VARCHAR2(20),
    kilometry NUMBER,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

CREATE TABLE samochody of samochod;

insert into samochody values(NEW samochod('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
insert into samochody values(NEW samochod('FORD','MONDEO',80000,DATE '1997-05-10',45000));
insert into samochody values(NEW samochod('MAZDA','323',12000,DATE '2000-09-22',52000));

--ZAD 2 Zdefiniuj typ obiektowy reprezentujący SAMOCHOD. Każdy samochód powinien mieć markę, model, liczbę kilometrów oraz datę produkcji i cenę. Stwórz tabelę obiektową SAMOCHODY i wprowadź kilka przykładowych obiektów. Wyświetl zawartość tabeli.

alter type samochod replace as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10, 2),
    member function wartosc return number
);

create or replace type body samochod as
    member function wartosc return number is
    begin
        return round(cena * POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji)),2);
    end wartosc;
end;

select s.marka,s.cena,s.wartosc()
from samochody s;

--ZAD 3 Dodaj do typu SAMOCHOD metodę odwzorowującą, która pozwoli na porównywanie samochodów na podstawie ich wieku i zużycia. Przyjmij, że 10000 km odpowiada jednemu rokowi wieku samochodu.

ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

create or replace type body samochod as
    member function wartosc return number is
    begin
        return round(cena * POWER(0.9, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji)),2);
    end wartosc;
    map member function odwzoruj return number is
    begin
        return round(extract(year from current_date) - extract(year from data_produkcji) + (kilometry / 10000), 2);
    end odwzoruj;
end;
select * from samochody s order by value(s);

--ZAD 4 Stwórz tabelę (relacyjną) WLASCICIELE zawierającą imiona i nazwiska właścicieli oraz atrybut obiektowy SAMOCHOD. Wprowadź do tabeli przykładowe dane i wyświetl jej zawartość.

create table wlasciciele(
    imie varchar2(100),
    nazwisko varchar2(100),
    auto samochod
);

insert into wlasciciele values('JAN','KOWALSKI', NEW SAMOCHOD('FIAT','SEICENTO',30000,DATE '2010-12-02',19500));
insert into wlasciciele values('ADAM','NOWAK', NEW SAMOCHOD('OPEL','ASTRA',34000,DATE '2009-06-01',33700));

--ZAD 5 Usuń tabelę WLASCICIELE.

DROP TABLE wlasciciele;

--ZAD 6 Stwórz typ WLASCICIEL zawierający imię i nazwisko właściciela samochodu.Stwórz tabelę obiektową WLASCICIELE i wprowadź kilka przykładowych obiektów. Wyświetl zawartość tabeli WLASCICIELE.

CREATE TYPE WLASCICIEL AS OBJECT (
    imie varchar2(100),
    nazwisko varchar2(100)
);

create table wlasciciele of wlasciciel;

insert into wlasciciele values(Wlasciciel('Zuzanna','Lawniczak'));
INSERT INTO WLASCICIELE VALUES(WLASCICIEL('STAS','ADAMCZEWSKI'));

SELECT * FROM WLASCICIELE;

--ZAD 7 Dodaj do typu SAMOCHOD referencję do właściciela.

ALTER TYPE samochod ADD ATTRIBUTE wlasc REF wlasciciel CASCADE;

-- ZAD 8 Usuń wszystkie obiekty z tabeli SAMOCHODY.

DELETE FROM samochody;

--ZAD 9 Ogranicz zakres referencji do właścicieli w tabeli SAMOCHODY do obiektów z tabeli WLASCICIELE.

ALTER TABLE SAMOCHODY ADD SCOPE FOR(wlasc) IS WLASCICIELE;

--ZAD 10 Ogranicz zakres referencji do właścicieli w tabeli SAMOCHODY do obiektów z tabeli WLASCICIELE.

INSERT INTO samochody VALUES (NEW samochod('FIAT', 'BRAVA', 60000, DATE '1999-11-30', 25000, NULL));
INSERT INTO samochody VALUES (NEW samochod('FORD', 'MONDEO', 80000, DATE '1997-05-10', 45000, NULL));

UPDATE samochody s
SET s.wlasc = (SELECT REF(w) FROM wlasciciele w WHERE w.nazwisko = 'Lawniczak')
WHERE s.marka = 'FIAT';

UPDATE samochody s
SET s.wlasc = (SELECT REF(w) FROM wlasciciele w WHERE w.nazwisko = 'ADAMCZEWSKI')
WHERE s.marka = 'FORD';

SELECT s.marka, s.model, DEREF(s.wlasc)
FROM samochody s;

-- KOLEKCJE
-- ZAD 11 Zbuduj kolekcję (tablicę o zmiennym rozmiarze) zawierającą informacje o przedmiotach (łańcuchy znaków). Wstaw do kolekcji przykładowe przedmioty, rozszerz kolekcję, wyświetl zawartość kolekcji, usuń elementy z końca kolekcji.

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := '9';
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- ZAD 12  Zbuduj kolekcję (w oparciu o tablicę o zmiennym rozmiarze) zawierającą listę tytułów książek. Wykonaj na kolekcji kilka czynności (rozszerz, usuń jakiś element, wstaw nową książkę).

DECLARE
TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(50);
moje_ksiazki t_ksiazki := t_ksiazki('ksiazka_1');
BEGIN

moje_ksiazki.EXTEND(4);
FOR i IN 2..5 LOOP
moje_ksiazki(i) := 'ksiazka_' || i;
END LOOP;

DBMS_OUTPUT.PUT_LINE('Output:');
FOR i IN moje_ksiazki.FIRST .. moje_ksiazki.LAST LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;


moje_ksiazki.TRIM;

moje_ksiazki.EXTEND;
moje_ksiazki(moje_ksiazki.LAST) := 'Akademia_Pana_Kleksa';
DBMS_OUTPUT.PUT_LINE('Add:');
FOR i IN moje_ksiazki.FIRST .. moje_ksiazki.LAST LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;

DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT);
DBMS_OUTPUT.PUT_LINE('Liczba elementów: ' || moje_ksiazki.COUNT);
END;

-- ZAD 13 Zbuduj kolekcję (tabelę zagnieżdżoną) zawierającą informacje o wykładowcach. Wykonaj na kolekcji kilka czynności (rozszerz, wstaw/usuń elementy).

DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- ZAD 14  Zbuduj kolekcję (w oparciu o tabelę zagnieżdżoną) zawierającą listę miesięcy. Wstaw do kolekcji właściwe dane, usuń parę miesięcy, wyświetl zawartość kolekcji.

DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(20);
 moje_miesiace t_miesiace := t_miesiace();
BEGIN
 moje_miesiace.EXTEND(12);
 moje_miesiace(1) := 'STYCZEN';
 moje_miesiace(2) := 'LUTY';
 moje_miesiace(3) := 'MARZEC';
 moje_miesiace(4) := 'KWIECIEN';
 moje_miesiace(5) := 'MAJ';
 moje_miesiace(6) := 'CZERWIEC';
 moje_miesiace(7) := 'LIPIEC';
 moje_miesiace(8) := 'SIERPIEN';
 moje_miesiace(9) := 'WRZESIEN';
 moje_miesiace(10) := 'PAZDZIERNIK';
 moje_miesiace(11) := 'LISTOPAD';
 moje_miesiace(12) := 'GRUDZIEN';
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 moje_miesiace.DELETE(4,9);
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 IF moje_miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END IF;
 END LOOP;
END;

-- ZAD 15 Sprawdź działanie obu rodzajów kolekcji w przypadku atrybutów bazodanowych.

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- ZAD 16 Utwórz tabelę ZAKUPY zawierającą atrybut zbiorowy KOSZYK_PRODUKTOW w postaci tabeli zagnieżdżonej. Wstaw do tabeli przykładowe dane. Wyświetl zawartość tabeli, usuń wszystkie zakupy zawierające wybrany produkt.

create type koszyk_produktow as table of varchar2(20);

create type zakup as object (
    sklep varchar2(50),
    produkty koszyk_produktow
);

create table zakupy of zakup
nested table produkty store as tab_produkty;

insert into zakupy values
(zakup('vinted', koszyk_produktow('macbook', 'iphone')));
insert into zakupy values
(zakup('allegro', koszyk_produktow('sukienka', 'buty', 'kurtka')));
insert into zakupy values
(zakup('zalando', koszyk_produktow('sweter')));

select * from zakupy;

delete from zakupy
where sklep in (
    select sklep
    from zakupy z, table(z.produkty) p
    where p.column_value = 'sweter'
);

--Polimorfizm, dziedziczenie
-- ZAD 17 Zbuduj hierarchię typów reprezentującą instrumenty muzyczne.

DROP TYPE instrument_klawiszowy FORCE;
DROP TYPE instrument_dety FORCE;
DROP TYPE instrument FORCE;


CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/

SET SERVEROUTPUT ON;

DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

-- ZAD 18 Zbuduj hierarchię typów reprezentującą zwierzęta i przetestuj klasy abstrakcyjne.

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 --InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- ZAD 19 Zbadaj własność polimorfizmu na przykładzie hierarchii instrumentów.

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
-- nie dziala bez rzutowania
END;

-- ZAD 20 Utwórz tabelę zawierającą różne instrumenty. Zbadaj działanie funkcji wirtualnych.
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;
