-- ZAD 1 A
create table FIGURY(
    ID NUMBER(1) PRIMARY KEY,
    KSZTALT MDSYS.SDO_GEOMETRY
);


-- ZAD 1 B
INSERT INTO FIGURY
VALUES(
1, SDO_GEOMETRY(
    2003, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1, 1003, 4),
    SDO_ORDINATE_ARRAY(5,3, 7,5, 3,5)
    )
);

INSERT INTO FIGURY
VALUES(
2, SDO_GEOMETRY(
    2003, NULL, NULL,
    SDO_ELEM_INFO_ARRAY(1, 1003, 3),
    SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);

insert into figury values (
  3,
  mdsys.sdo_geometry(
          2002, -- 2D line
          null,
          null,
          mdsys.sdo_elem_info_array(1, 2, 1),
          mdsys.sdo_ordinate_array(3,2,  6,2,  7,3,  8,2,  7,1)
  )
);

-- ZAD 1 C
insert into figury values (
  4,
  mdsys.sdo_geometry(
          2003,
          null,
          null,
          mdsys.sdo_elem_info_array(1, 1003, 4),
          mdsys.sdo_ordinate_array(1,8,  2,8,  3,8)
  )
);

-- ZAD D
SELECT ID, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.005) AS VAL
FROM FIGURY

-- ZAD E
DELETE FROM FIGURY
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(KSZTALT, 0.005)<>'TRUE';

-- ZAD F
COMMIT;