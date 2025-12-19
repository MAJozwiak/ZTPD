--ZAD 1 Utwórz w swoim schemacie tabelę DOKUMENTY o poniższej strukturze:
create table DOKUMENTY (

    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB

);

--ZAD 2 Wstaw do tabeli DOKUMENTY dokument utworzony przez konkatenację 10000 kopii tekstu 'Oto tekst.' nadając mu ID = 1 (Wskazówka: wykorzystaj anonimowy blok kodu PL/SQL).
DECLARE
    tekst VARCHAR(15) := 'Oto tekst. ';
    licznik number :=10000;
    tekst_clob CLOB;
BEGIN
    for i in 1..licznik
    loop
        tekst_clob := concat(tekst_clob,tekst);
    end loop;
    insert into DOKUMENTY VALUES
    (1, tekst_clob);
END;

--ZAD 3 Wykonaj poniższe zapytania:...
SELECT * FROM dokumenty;

SELECT ID,UPPER(DOKUMENT) FROM DOKUMENTY;

SELECT ID,LENGTH(DOKUMENT) FROM DOKUMENTY;

SELECT ID,DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

select id, substr(dokument, 5,1000) from dokumenty;

select id, DBMS_LOB.SUBSTR(dokument,1000,5) from dokumenty;

--ZAD 4 Wstaw do tabeli drugi dokument jako pusty obiekt CLOB nadając mu ID = 2.
insert into dokumenty values(2, empty_clob());

--ZAD 5 Wstaw do tabeli trzeci dokument jako NULL nadając mu ID = 3. Zatwierdź transakcję.
insert into dokumenty values(3,null);


--ZAD 6 Sprawdź jaki będzie efekt zapytań z punktu 3 dla wszystkich trzech dokumentów.
SELECT * FROM dokumenty;

1 Oto tekst....
2
3 (null)

SELECT ID,UPPER(DOKUMENT) FROM DOKUMENTY;

1 OTO TEKST....
2
3 (null)

SELECT ID,LENGTH(DOKUMENT) FROM DOKUMENTY;

1 110000
2 0
3 (null)

SELECT ID,DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

1 110000
2 0
3 (null)

select id, substr(dokument, 5,1000) from dokumenty;

1 tekst....
2
3 (null)

select id, DBMS_LOB.SUBSTR(dokument,1000,5) from dokumenty;

1 tekst....
2 (null)
3 (null)

--ZAD 7 Napisz program w formie anonimowego bloku PL/SQL, który do dokumentu o identyfikatorze 2 przekopiuje tekstową zawartość pliku dokument.txt znajdującego się w katalogu systemu plików serwera udostępnionym przez obiekt DIRECTORY o nazwieSET SERVEROUTPUT ON SIZE 30000;
DECLARE
    v_file     BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    v_clob     CLOB;

    dst_off    INTEGER := 1;
    src_off    INTEGER := 1;

    csid       INTEGER := 0;
    ctx        INTEGER := 0;
    warning    INTEGER;
BEGIN
    SELECT dokument
    INTO v_clob
    FROM dokumenty
    WHERE id = 2
    FOR UPDATE;

    DBMS_LOB.FILEOPEN(v_file, DBMS_LOB.FILE_READONLY);

    DBMS_LOB.LOADCLOBFROMFILE(
        v_clob,
        v_file,
        DBMS_LOB.LOBMAXSIZE,
        dst_off,
        src_off,
        csid,
        ctx,
        warning
    );

    DBMS_LOB.FILECLOSE(v_file);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Status kopiowania: ' || warning);
END;

--ZAD 8 Do dokumentu o identyfikatorze 3 przekopiuj tekstową zawartość pliku dokument.txt znajdującego się w katalogu systemu plików serwera (za pośrednictwem obiektu BFILE), tym razem nie korzystając z PL/SQL, a ze zwykłego polecenia UPDATE z poziomu SQL.
update dokumenty
set dokument=to_clob(bfilename('TPD_DIR','dokument.txt'))
where id=3;

--ZAD 9 Odczytaj zawartość tabeli DOKUMENTY.
SELECT * FROM DOKUMENTY;

--ZAD 10 Odczytaj rozmiar wszystkich dokumentów z tabeli DOKUMENTY.
SELECT ID,DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

--ZAD 11 Usuń tabelę DOKUMENTY.
drop table dokumenty;

--ZAD 12 Zaimplementuj w PL/SQL procedurę CLOB_CENSOR, która w podanym jako pierwszy parametr dużym obiekcie CLOB zastąpi wszystkie wystąpienia tekstu podanego jako drugi parametr (typu VARCHAR2) kropkami, tak aby każdej zastępowanej literze odpowiadała jedna kropka.
CREATE OR REPLACE PROCEDURE clob_censor(
    p_clob IN OUT CLOB,
    p_text IN VARCHAR2
) IS
    v_mask     VARCHAR2(32767) := '';
    v_len      INTEGER := LENGTH(p_text);
    v_pos      INTEGER;
BEGIN
    FOR i IN 1 .. v_len LOOP
        v_mask := v_mask || '.';
    END LOOP;

    v_pos := DBMS_LOB.INSTR(p_clob, p_text, 1);

    WHILE v_pos > 0 LOOP
        DBMS_LOB.WRITE(p_clob, v_len, v_pos, v_mask);

        v_pos := DBMS_LOB.INSTR(p_clob, p_text, v_pos + v_len);
    END LOOP;
END clob_censor;

--ZAD 14 Usuń kopię tabeli BIOGRAPHIES ze swojego schematu.
DROP TABLE BIOGRAPHIES;

