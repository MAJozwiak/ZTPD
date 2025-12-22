--CW 1 A
insert into user_sdo_geom_metadata values (
    'FIGURY',
    'KSZTALT',
    mdsys.sdo_dim_array(
          mdsys.sdo_dim_element('X', 0, 10, 0.01),
          mdsys.sdo_dim_element('Y', 0, 10, 0.01)
    ),
    null
);

--B
select sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0) as est
from dual;

--C
create index FIGURY_IDX
on FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

--D
select ID
from FIGURY
where SDO_FILTER(KSZTALT,
SDO_GEOMETRY(2001,null,
SDO_POINT_TYPE(3,3,null),null,null)) = 'TRUE';


--E
select ID
from FIGURY
where SDO_RELATE(KSZTALT,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';
--Tak

--CW 2 A
select A.CITY_NAME as miasto, SDO_NN_DISTANCE(1) odl
from MAJOR_CITIES A, major_cities B
where B.city_name='Warsaw' AND A.city_name <> 'Warsaw' AND SDO_NN(A.GEOM,B.GEOM,
 'sdo_num_res=10 unit=km',1) = 'TRUE';

--B
select a.city_name as miasto
from major_cities a, major_cities b
where b.city_name ='Warsaw' and a.city_name <> 'Warsaw' and
SDO_WITHIN_DISTANCE(a.geom, b.geom, 'distance=100 unit=km')='TRUE';

--C
select B.CNTRY_NAME as kraj, C.city_name as miasto
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where B.CNTRY_NAME = 'Slovakia' AND
SDO_RELATE(B.GEOM, C.GEOM, 'mask=CONTAINS') = 'TRUE';

--D
select distinct A.CNTRY_NAME as panstwo, SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km') ODL
from COUNTRY_BOUNDARIES B, COUNTRY_BOUNDARIES A
where B.CNTRY_NAME = 'Poland' AND
SDO_RELATE(A.GEOM, B.GEOM, 'mask=ANYINTERACT') <> 'TRUE';

--CW 3
--A
SELECT B.CNTRY_NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') As odleglosc
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND
SDO_RELATE(A.geom, b.geom, 'mask=ANYINTERACT')='TRUE'
AND B.CNTRY_NAME<>'Poland';

--B
select cntry_name
from COUNTRY_BOUNDARIES
order by SDO_GEOM.sdo_area(GEOM, 1, 'unit=SQ_KM') DESC
FETCH FIRST 1 ROWS ONLY;

--C
select SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1)), 1, 'unit=SQ_KM') AS SQ_KM
from MAJOR_CITIES A, MAJOR_CITIES B
where A.CITY_NAME = 'Warsaw'
and B.CITY_NAME = 'Lodz';

--D
select sdo_geom.sdo_union(pl.geom, pr.geom, 0.01).sdo_gtype as gtype
from (select geom from country_boundaries where cntry_name = 'Poland') pl,
     (select geom from major_cities       where city_name  = 'Prague') pr;
--E
select city_name, cntry_name
from (
 select mc.city_name,
mc.cntry_name,
sdo_geom.sdo_distance(
    mc.geom,
    sdo_geom.sdo_centroid(cb.geom, 1),
    1,
    'unit=km'
) as dist_km
 from major_cities mc
          join country_boundaries cb
               on cb.cntry_name = mc.cntry_name
 order by dist_km
 )
fetch first 1 row only;

--F
select r.name,
sum(
   sdo_geom.sdo_length(
       sdo_geom.sdo_intersection(r.geom, pl.geom, 1),
       1,
       'unit=km'
   )
) as dlugosc
from rivers r,
     (select geom from country_boundaries where cntry_name = 'Poland') pl
where sdo_relate(r.geom, pl.geom, 'mask=ANYINTERACT') = 'TRUE'
group by r.name
order by dlugosc desc;