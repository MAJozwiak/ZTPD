--ZAD 1 a
select lpad('-',2*(level-1),'|-') ||
    t.owner||'.'||t.type_name||
    ' (FINAL:'||t.final||
    ', INSTANTIABLE:'||t.instantiable||
    ', ATTRIBUTES:'||t.attributes||
    ', METHODS:'||t.methods||')' as tree
from all_types t
    start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
       and prior t.owner = t.owner;
--B
select distinct m.method_name
from all_type_methods m
 where m.type_name = 'ST_POLYGON'
  and m.owner = 'MDSYS'
order by 1;

--C
create table myst_major_cities(
    fips_cntry varchar2(2),
    city_name varchar2(40),
    stgeom st_point
);

--D
 insert into MYST_MAJOR_CITIES
 select C.FIPS_CNTRY, C.CITY_NAME,
 TREAT(ST_POINT.FROM_SDO_GEOM(C.GEOM) AS ST_POINT)
 from MAJOR_CITIES C;

--ZAD 2
select * from major_cities where city_name='Warsaw';
--FIPS_CNTRY = 'PL' i SRID to 8307

--A
insert into myst_major_cities values(
    'PL',
    'Szczyrk',
    ST_POINT(19.036107,49.718655,8307)
);

--ZAD 3 a
create table myst_country_boundaries(
fips_country varchar2(2),
cntry_name varchar2(40),
stgeom st_multipolygon
);

--B
insert into myst_country_boundaries (fips_cntry, cntry_name, stgeom)
select cb.fips_cntry,
       cb.cntry_name,
       st_multipolygon(cb.geom)
from country_boundaries cb;

--C
select B.STGEOM.ST_GEOMETRYTYPE() typ_obiektu, count(*) as ile
from MYST_COUNTRY_BOUNDARIES B
group by B.STGEOM.ST_GEOMETRYTYPE();

--D
select B.STGEOM.ST_ISSIMPLE()
from MYST_COUNTRY_BOUNDARIES b;

-- ZAD 4 A
select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B,
 MYST_MAJOR_CITIES C
where C.STGEOM.ST_WITHIN(B.STGEOM) = 1
group by B.CNTRY_NAME;

--B
select a.cntry_name as a_name,
       b.cntry_name as b_name
from myst_country_boundaries a,
     myst_country_boundaries b
where a.stgeom.st_touches(b.stgeom) = 1
  and b.cntry_name = 'Czech Republic'
order by a_name;

--C
select distinct B.CNTRY_NAME, R.name
from MYST_COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Czech Republic'
and ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1

--D
select treat(A.STGEOM.ST_UNION(B.STGEOM) as ST_POLYGON).ST_AREA() as powierzchnia
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

--E
select h.stgeom.st_difference(st_geometry(wb.geom)).st_geometrytype() as wegry_bez
from myst_country_boundaries h,
water_bodies wb
where h.cntry_name = 'Hungary'
and wb.name = 'Balaton';


--ZAD 5 A
explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select plan_table_output from table(dbms_xplan.display('plan_table',null,'basic'));

--B
insert into user_sdo_geom_metadata
select 'MYST_MAJOR_CITIES', 'STGEOM', diminfo, srid
from all_sdo_geom_metadata
where table_name = 'MAJOR_CITIES' and column_name = 'GEOM';

--C
CREATE INDEX MYST_MAJOR_CITIES_IDX ON MYST_MAJOR_CITIES(STGEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;


--D
explain plan for
select cb.cntry_name as a_name,
       count(*)      as ile
from myst_country_boundaries cb,
     myst_major_cities mc
where cb.cntry_name = 'Poland'
  and sdo_within_distance(mc.stgeom, cb.stgeom, 'distance=100 unit=km') = 'TRUE'
group by cb.cntry_name;

select plan_table_output from table(dbms_xplan.display);