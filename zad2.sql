SELECT * FROM popp;
SELECT * FROM public.majrivers;


--1-----------------------------------------------------------------------------
CREATE TABLE TableB AS
SELECT p.* FROM popp as p, majrivers as maj 
	WHERE (ST_Contains(ST_Buffer( maj.geom , 1000), p.geom)) = TRUE AND  p.f_codedesc = 'Building'; 
	
SELECT * FROM TableB;

--2------------------------------------------------------------------------------
	CREATE TABLE airpotsNEW AS
	SELECT name, geom, elev FROM public.airports;
	SELECT * FROM airpotsNEW;
--a----------	
	SELECT name, ST_AsText(geom) FROM airpotsNEW WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airpotsNEW);
	SELECT name, ST_AsText(geom) FROM airpotsNEW WHERE ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airpotsNEW);
			
	SELECT ST_AsText(geom) FROM airpotsNEW 
	WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airpotsNEW) 
	OR ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airpotsNEW);
	
	
--b--------------------------	
INSERT INTO airpotsNEW VALUES( 'airportb',
							  (SELECT ST_Centroid(ST_Collect(geom))
							  FROM airpotsNEW 
							  WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airpotsNEW) 
							  OR ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airpotsNEW)), 0 );
SELECT * FROM airpotsNEW;		


--3-------------------------------------------------------------------------
SELECT ST_Distance(lakes.geom, airports.geom)*2000 + pi()*1000*1000
FROM lakes, airports
WHERE lakes.names = 'Iliamna Lake' AND airports.name = 'AMBLER'; 

--4----------------------------------------------------------------

SELECT * FROM  trees;
SELECT * FROM  swamp;
SELECT * FROM  tundra;

SELECT tr.vegdesc, SUM(ST_Area(ST_Intersection(tr.geom,ST_Union(sw.geom, tu.geom))))
FROM trees as tr, swamp as sw, tundra as tu
GROUP BY tr.vegdesc;







