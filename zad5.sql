CREATE EXTENSION postgis;

CREATE TABLE obiekty (id INT primary key, name VARCHAR(50), geom GEOMETRY);

INSERT INTO obiekty VALUES (1, 'obiekt1', ST_GeomFromEWKT('SRID=0; COMPOUNDCURVE(LineString(0 1, 1 1),CIRCULARSTRING(1 1, 2 0, 3 1),CIRCULARSTRING(3 1, 4 2, 5 1),LineString(5 1, 6 1) )'));
INSERT INTO obiekty VALUES (2, 'obiekt2', ST_GeomFromEWKT('SRID=0; CURVEPOLYGON(COMPOUNDCURVE( 
														  LineString(10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), 
														  CIRCULARSTRING(14 2, 12 0, 10 2), LineString(10 2, 10 6)),
														  CIRCULARSTRING(11 2, 13 2, 11 2))'));
INSERT INTO obiekty VALUES (3, 'obiekt3', ST_GeomFromEWKT('SRID=0; CURVEPOLYGON(COMPOUNDCURVE(LineString(10 17, 12 13, 7 15, 10 17)))'));
INSERT INTO obiekty VALUES (4, 'obiekt4', ST_GeomFromEWKT('SRID=0; MULTICURVE(COMPOUNDCURVE(LineString(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)))'));
INSERT INTO obiekty VALUES (5, 'obiekt5', ST_GeomFromEWKT('SRID=0; MULTIPOINT ( (30 30 59), (38 32 234) )'));
INSERT INTO obiekty VALUES (6, 'obiekt6', ST_GeomFromEWKT('SRID=0; GeometryCollection( LineString(1 1, 3 2), POINT(4 2))'));


SELECT id,ST_GeometryType(geom) FROM obiekty;
SELECT id, ST_AsText(geom) FROM obiekty;

DELETE FROM obiekty
WHERE id = 6;


--1-----------------------------------------
SELECT ST_Area(ST_Buffer(ST_ShortestLine(geom,geom),5))
FROM obiekty
WHERE id IN (3, 4)
LIMIT 1;

--2------------------------------------------

UPDATE obiekty
SET geom = ST_GeomFromEWKT('SRID=0;CURVEPOLYGON(COMPOUNDCURVE(LineString(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)))')
WHERE id = 4;

--3------------------------------------------

INSERT INTO obiekty VALUES (7, 'obiekt7', (SELECT ST_collect(geom) FROM obiekty WHERE id IN (3, 4)));
																			
--4------------------------------------------

SELECT SUM(ST_Area(ST_Buffer(geom,5))) FROM obiekty
WHERE ST_HasArc(geom) = FALSE;
																			


