--ZAD 1
CREATE TABLE CYTATY AS
SELECT * FROM ZTPD.CYTATY;

--ZAD 2
select autor, tekst
from cytaty
where lower(tekst) like '%optymista%'
  and lower(tekst) like '%pesymista%';

--ZAD 3
create index cytaty_ctx on cytaty(tekst)
    indextype is ctxsys.context;

--ZAD 4
select * from cytaty
where contains(tekst,'optymista AND pesymista')>0;

--ZAD 5
SELECselect autor, tekst
from cytaty
where contains(tekst, 'optymista AND pesymista', 1) > 0;
--ZAD 6
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'NEAR((optymist, pesymist), 3)') > 0;

--ZAD 7
select autor, tekst
from cytaty
where contains(tekst, 'near((optymista, pesymista), 10)', 1) > 0;

--ZAD 8
select * from cytaty
where contains(tekst, 'życi%')>0;

--ZAD 9
select score(1) from cytaty
where contains(tekst, 'życi%',1)>0;

--ZAD 10
select autor, tekst, score(1) as dopasowanie
from cytaty
where contains(tekst, 'życi%', 1) > 0
order by score(1) desc
    fetch first 1 row only;


--ZAD 11

select * from cytaty
where contains(tekst, 'fuzzy(probelm)')>0;

--ZAD 12
INSERT INTO CYTATY(id,autor,tekst) values
(39,'Bertrand Russell','To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');

--ZAD 13
select * from cytaty
where contains(tekst, 'głupcy')>0;

--ZAD 14
SELECT token_text FROM DR$CYTATY_TEKST_IDX$I;

SELECT token_text FROM DR$CYTATY_TEKST_IDX$I
WHERE token_text = 'głupcy';
--nie ma

--ZAD 15
drop index cytaty_ctx;

create index cytaty_ctx on cytaty(tekst)
indextype is ctxsys.context;

--ZAD 16
select * from cytaty
where contains(tekst, 'głupcy')>0;

--ZAD 17
DROP INDEX CYTATY_TEKST_IDX;
DROP TABLE CYTATY;

-- ZAD 18
drop index cytaty_ctx;
drop table cytaty;


---CZESC 2
-- ZAD 1
create table quotes as
select * from ztpd.quotes;

--ZAD 2
create index QUOTES_TEXT_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT;

--ZAD 3
select * from quotes
where contains(text, 'work')>0;
select * from quotes
where contains(text, '$work')>0;
select * from quotes
where contains(text, 'working')>0;
select * from quotes
where contains(text, '$working')>0;

--ZAD4
select * from quotes
where contains(text, 'it')>0;

-- ZAD5
select * from CTX_STOPLISTS;

-- ZAD 6
select * from ctx_stopwords;

--ZAD 7
DROP INDEX QUOTES_TEXT_IDX;

CREATE INDEX QUOTES_TEXT_IDX
ON QUOTES(TEXT)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS('STOPLIST CTXSYS.EMPTY_STOPLIST');

--ZAD 8
select * from quotes
where contains(text, 'it')>0;
--TAK

--ZAD 9
select * from quotes
where contains(text, 'fool AND humans')>0;

-- ZAD 10
select * from quotes
where contains(text, 'fool AND computer')>0;

-- ZAD 11
select * from quotes
where contains(text, '(fool AND humans) within SENTENCE')>0;

--ZAD 12
DROP INDEX QUOTES_TEXT_IDX;

--ZAD 13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
END;

--ZAD 14
create index quotes_ctx on quotes(text)
    indextype is ctxsys.context
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group quotes_sg');

--ZAD 15
select author, text
from quotes
where contains(text, '(fool AND humans) within sentence', 1) > 0;

select author, text
from quotes
where contains(text, '(fool AND computer) within sentence', 1) > 0;

--ZAD 16
select * from quotes
where contains(text, 'humans')>0;
--zwrócił

--ZAD 17
drop index quotes_ctx;

begin
  ctx_ddl.create_preference('quotes_lex', 'BASIC_LEXER');
  ctx_ddl.set_attribute('quotes_lex', 'printjoins', '-');
  ctx_ddl.set_attribute('quotes_lex', 'index_text', 'yes');
end;
/

create index quotes_ctx on quotes(text)
    indextype is ctxsys.context
parameters ('stoplist CTXSYS.EMPTY_STOPLIST section group quotes_sg lexer quotes_lex');


-- ZAD 18
select author, text
from quotes
where contains(text, 'humans', 1) > 0;

