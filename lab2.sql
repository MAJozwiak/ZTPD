--ZAD 1 Utwórz w swoim schemacie kopię tabeli MOVIES ze schematu ZTPD. Wskazówka: Skorzystaj z polecenia CREATE TABLE … AS SELECT …
create table movies as select * from ztpd.movies;

--ZAD 2 Zapoznaj się ze schematem tabeli MOVIES, zwracając uwagę na kolumnę typu BLOB.
describe movies;
SELECT * FROM MOVIES;

--ZAD Sprawdź zapytaniem SQL do tabeli MOVIES, które filmy nie mają okładek.
select * from movies
where cover is null;

--ZAD 4 Dla filmów, które mają okładki odczytaj rozmiar obrazka w bajtach.
select title, id, DBMS_LOB.GETLENGTH(cover) as filesize from movies
where cover is not null;

--ZAD 5 Sprawdź co się stanie gdy zostanie dokonana próba odczytu rozmiaru obrazków dla filmów, które nie posiadają okładek w tabeli MOVIES
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies
where cover is null;

--ZAD 6 Brakujące okładki zostały umieszczone w jednym z katalogów systemu plików serwera bazy danych w plikach eagles.jpg i escape.jpg. Został on udostępniony w bazie danych jako obiekt DIRECTORY o nazwie TPD_DIR. Upewnij się zapytaniem do perspektywy
select * from ALL_DIRECTORIES;

--ZAD 7 Zmodyfikuj okładkę filmu o identyfikatorze 66 w tabeli MOVIES na pusty obiekt BLOB (lokalizator bez wartości), a jako typ MIME (w przeznaczonej do tego celu kolumnie tabeli) podaj: image/jpeg. Zatwierdź transakcję.
update movies
set cover = empty_blob(), mime_type = 'image/jpeg'
where id = 66;

--ZAD 8 Odczytaj z tabeli MOVIES rozmiar obrazków dla filmów o identyfikatorach 65 i 66.
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies
where id in (65,66);


--ZAD 9 Napisz program w formie anonimowego bloku PL/SQL, który dla filmu o identyfikatorze 66 przekopiuje binarną zawartość obrazka z pliku escape.jpg znajdującego się w katalogu systemu plików serwera (za pośrednictwem obiektu BFILE) do pustego w tej chwili obiektu...
DECLARE
    v_blob   BLOB;
    v_bfile  BFILE;
    v_len    INTEGER;
BEGIN
    v_bfile := BFILENAME('TPD_DIR', 'escape.jpg');

    SELECT cover
    INTO v_blob
    FROM movies
    WHERE id = 66
    FOR UPDATE;

    DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);

    v_len := DBMS_LOB.GETLENGTH(v_bfile);

    DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, v_len);

    DBMS_LOB.FILECLOSE(v_bfile);

    COMMIT;
END;

--ZAD 10 Utwórz tabelę TEMP_COVERS o poniższej strukturze:...
CREATE TABLE TEMP_COVERS (
    MOVIE_ID NUMBER(12),
    IMAGE BFILE,
    MIME_TYPE VARCHAR2(50)
);

--ZAD 11  Wstaw do tabeli TEMP_COVERS obrazek z pliku eagles.jpg z udostępnionego katalogu. Nadaj mu identyfikator filmu, którego jest okładką (65). Jako typ MIME podaj: image/jpeg. Zatwierdź transakcję.
DECLARE
    fils BFILE := BFILENAME('TPD_DIR','eagles.jpg');
BEGIN
    INSERT INTO TEMP_COVERS(MOVIE_ID, IMAGE, MIME_TYPE)
    VALUES (65, fils, 'image/jpeg');
    COMMIT;
END;

--ZAD 12 Odczytaj rozmiar w bajtach dla obrazka załadowanego jako BFILE.
SELECT movie_id, DBMS_LOB.GETLENGTH(image) from temp_covers where movie_id=65;

--ZAD 13 Napisz program w formie anonimowego bloku PL/SQL, który dla filmu o identyfikatorze 65 utworzy obiekt BLOB, przekopiuje do niego binarną zawartość okładki BFILE z tabeli TEMP_COVERS i umieści BLOB w odpowiednim wierszu tabeli MOVIES. Wykorzystaj poniższy schemat postępowania:
DECLARE
    v_blob      BLOB;
    v_bfile     BFILE;
    v_mime      VARCHAR2(50);
    v_size      INTEGER;
BEGIN
    SELECT image, mime_type
    INTO v_bfile, v_mime
    FROM temp_covers
    WHERE movie_id = 65;

    DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);

    DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);

    v_size := DBMS_LOB.GETLENGTH(v_bfile);

    DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, v_size);

    DBMS_LOB.FILECLOSE(v_bfile);

    UPDATE movies
    SET cover = v_blob,
        mime_type = v_mime
    WHERE id = 65;

    DBMS_LOB.FREETEMPORARY(v_blob);

    COMMIT;
END;


--ZAD 14 Odczytaj rozmiar w bajtach dla okładek filmów 65 i 66 z tabeli MOVIES.
SELECT id, DBMS_LOB.GETLENGTH(cover) from movies where id in (65,66);

--ZAD 15 Usuń tabelę MOVIES ze swojego schematu.
DROP TABLE movies;