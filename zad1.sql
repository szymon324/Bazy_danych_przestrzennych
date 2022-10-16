CREATE EXTENSION postgis;

CREATE TABLE roads(id INT primary key, name VARCHAR(50), geom GEOMETRY);
CREATE TABLE building(id INT primary key, name VARCHAR(50), geom GEOMETRY, height REAL);
CREATE TABLE point(id INT primary key, name VARCHAR(50), geom GEOMETRY, liczbrac INT);
--POINT(x y)
--LINESTRING(x1 y2,x2 y2, ... )
--POLYGON(x1 y1, x2 y2, ..., x1 y1)

INSERT INTO roads VALUES(1, 'roadX', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0));
INSERT INTO roads VALUES(2, 'roadY', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0));

INSERT INTO building VALUES(1, 'BuildingA', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))',0), 1);
INSERT INTO building VALUES(2, 'BuildingB', ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))',0), 2);
INSERT INTO building VALUES(3, 'BuildingC', ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))',0), 3);
INSERT INTO building VALUES(4, 'BuildingD', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))',0), 3);
INSERT INTO building VALUES(5, 'BuildingF', ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))',0), 2);

INSERT INTO point VALUES(1, 'G', ST_GeomFromText('Point(1 3.5)',0), 1);
INSERT INTO point VALUES(2, 'H', ST_GeomFromText('Point(5.5 1.5)',0), 2);
INSERT INTO point VALUES(3, 'I', ST_GeomFromText('Point(9.5 6)',0), 4);
INSERT INTO point VALUES(4, 'J', ST_GeomFromText('Point(6.5 6)',0), 8);
INSERT INTO point VALUES(5, 'K', ST_GeomFromText('Point(6 9.5)',0), 3);


SELECT *,ST_AsText(roads.geom) AS WKT FROM roads;
SELECT *,ST_AsText(building.geom) AS WKT FROM building;
SELECT *,ST_AsText(point.geom) AS WKT FROM point;


--1-----------------------------
SELECT sum(ST_Length(geom)) FROM roads; 

--2-----------------------------
SELECT ST_AsText(building.geom) AS WKT,
		ST_Area(geom) AS area, 
		ST_Perimeter(geom) AS circumstance 
		FROM building 
		where name = 'BuildingA';

--3------------------------------
SELECT ST_AsText(building.geom) AS WKT,
		ST_Area(geom) AS area, 
		ST_Perimeter(geom) AS circumstance 
		FROM building 
		ORDER BY name;
		
--4-----------------------------
SELECT ST_AsText(building.geom) AS WKT,
		ST_Area(geom) AS area, 
		ST_Perimeter(geom) AS circumstance 
		FROM building 
		ORDER BY area DESC, area ASC LIMIT 2;
		
--5-----------------------------
SELECT ST_Distance(building.geom, point.geom) AS distance
		FROM building, point
		WHERE building.name = 'BuildingC' AND point.name = 'G';

--6-------------------------------
SELECT ST_Area(ST_Difference(
   	(SELECT geom FROM building 
	WHERE name = 'BuildingC'), ST_Buffer(geom, 0.5)))
	FROM building WHERE name = 'BuildingB';

--7--------------------------------
SELECT building.name 
	FROM building, roads 
	WHERE st_y(st_centroid(building.geom)) > st_y(st_centroid(roads.geom))
	AND roads.name = 'roadX';

--8-------------------------------
SELECT ST_Area(ST_SymDifference(ST_GeomFromText('polygon((4 7, 6 7, 6 8, 4 8, 4 7))'), geom)) as area
FROM building WHERE name = 'BuildingC';
