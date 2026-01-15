--ZAD 1 A
CREATE TABLE S6_LRS(
GEOM SDO_GEOMETRY);

--B
select SR.ID,
SDO_GEOM.SDO_LENGTH(SR.GEOM, 1, 'unit=km') DISTANCE,
ST_LINESTRING(SR.GEOM) .ST_NUMPOINTS() ST_NUMPOINTS
from STREETS_AND_RAILROADS SR, MAJOR_CITIES C
where SDO_RELATE(SR.GEOM,
SDO_GEOM.SDO_BUFFER(C.GEOM, 10, 1, 'unit=km'),
'MASK=ANYINTERACT') = 'TRUE'
and C.CITY_NAME = 'Koszalin';

insert into S6_LRS
select GEOM
from STREETS_AND_RAILROADS
where ID = 56;


--C
SELECT SDO_GEOM.SDO_LENGTH(GEOM, 1, 'unit=km') DISTANCE,
 ST_LINESTRING(GEOM).ST_NUMPOINTS() ST_NUMPOINTS
from S6_LRS

--D
update S6_LRS
SET GEOM=SDO_LRS.CONVERT_TO_LRS_GEOM(GEOM, 0, 276.681);

--E
insert into user_sdo_geom_metadata
values (
'S6_LRS',
'GEOM',
mdsys.sdo_dim_array(
    mdsys.sdo_dim_element('X', 12.0, 26.5, 1),
    mdsys.sdo_dim_element('Y', 45.5, 58.5, 1),
    mdsys.sdo_dim_element('M', 0, 300, 1)
),
8307
);

--F
create index s6_lrs_idx
    on s6_lrs(geom)
    indextype is mdsys.spatial_index_v2;

--ZAD 2 A
SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
from S6_LRS;

--B
select SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
from S6_LRS;

--C
SELECT SDO_LRS.LOCATE_PT(GEOM, 150, 0) KM150 from S6_LRS;

--D
SELECT SDO_LRS.CLIP_GEOM_SEGMENT(GEOM, 120, 160) CLIPPED from S6_LRS;

--E
SELECT SDO_LRS.GET_NEXT_SHAPE_PT(S6.GEOM, C.GEOM) AS WJAZD_NA_S6
from S6_LRS S6, MAJOR_CITIES C where C.CITY_NAME = 'Slupsk';

--F
SELECT sdo_geom.sdo_length(
sdo_lrs.offset_geom_segment(
   s6.geom,
   m.diminfo,
   50,
   200,
   50,
   'unit=m arc_tolerance=1'
),
1,
'unit=km'
) as koszt
from s6_lrs s6, user_sdo_geom_metadata m
where m.table_name  = 'S6_LRS'
  and m.column_name = 'GEOM';