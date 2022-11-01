SELECT * FROM public.t2018_kar_buildings
SELECT * FROM public.t2019_kar_buildings
SELECT * FROM public.t2018_kar_poi_table
SELECT * FROM public.t2019_kar_poi_table

--1---------------------------------------------------
CREATE TABLE nowe_b AS
SELECT new.polygon_id as new, new.geom FROM t2018_kar_buildings as old FULL OUTER JOIN t2019_kar_buildings as new ON old.polygon_id =  new.polygon_id
WHERE new.height <> old.height OR old.geom IS NULL OR ST_Equals(new.geom, old.geom) IS FALSE 

SELECT * FROM nowe_b
DROP TABLE nowe_b
--2--------------------------------------------------

SELECT new.type, COUNT(new.type) FROM t2018_kar_poi_table as old
FULL OUTER JOIN t2019_kar_poi_table as new 
ON old.poi_id = new.poi_id , nowe_b as b
WHERE old.geom IS NULL AND ST_Disjoint(ST_Buffer(new.geom, 0.005), b.geom) IS FALSE
GROUP BY new.type

--3--------------------------------------------------------------
SELECT * FROM public.t2019_kar_streets

CREATE TABLE streets_reprojected AS 
SELECT *, ST_Transform(geom,3068) as geometry FROM t2019_kar_streets

ALTER TABLE streets_reprojected
DROP COLUMN geom

SELECT * FROM streets_reprojected

--4----------------------------------------------------------------

CREATE TABLE input_points(id INT primary key, geom GEOMETRY);
INSERT INTO input_points VALUES(1, ST_GeomFromText('Point(8.36093 49.03174)',4326));
INSERT INTO input_points VALUES(2, ST_GeomFromText('Point(8.39876 49.00644)',4326));
select *, ST_SRID(geom) FROM input_points
--5-------------------------------------------------------------------

UPDATE input_points
SET geom = ST_Transform(geom,3068)

SELECT id , ST_AsText(geom), ST_SRID(geom) FROM input_points

--6---------------------------------------------------------------------

SELECT *, ST_SRID(geom),ST_AsText(geom) FROM public.t2019_kar_street_node

SELECT node.Link_id FROM t2019_kar_street_node as node, input_points as point
WHERE ST_Contains(ST_Buffer(ST_ShortestLine(point.geom, point.geom ),200), ST_Transform(node.geom,3068)) IS TRUE

--7-------------------------------------------------------------------------------------------------
SELECT * FROM public.t2019_kar_land_use_a
SELECT * FROM public.t2019_kar_poi_table


SELECT poi.link_id FROM t2019_kar_poi_table as poi, t2019_kar_land_use_a as land
WHERE poi.type = 'Sporting Goods Store' 
AND ST_Contains(ST_Buffer((SELECT land.geom WHERE land.type = 'Park (City/County)'),300), poi.geom) IS TRUE

--8------------------------------------------------------------------------------------------------------
SELECT * FROM public.t2019_kar_railways
SELECT * FROM public.t2019_kar_water_lines

CREATE TABLE T2019_KAR_BRIDGES AS 
SELECT ST_Intersection(rai.geom, wat.geom) as geometry FROM t2019_kar_railways as rai, t2019_kar_water_lines as wat

SELECT * FROM T2019_KAR_BRIDGES
