CREATE TABLE uk_250k_mosaic AS
SELECT ST_Union(r.rast)
FROM uk_250k AS r;



CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
       ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
        ) AS loid
FROM uk_250k_mosaic;

SELECT lo_export(loid, 'C:\semestr_V\Bazy_danych_przestrzennych\zad7\myraster.tiff') --> Save the file in a placewhere the user postgres have access. In windows a flash drive usualy worksfine.
FROM tmp_out;

DROP TABLE tmp_out;

---------------------------------------------------------------
SELECT ST_SRID(geom) FROM public.main_national_parks;
CREATE TABLE public.uk_lake_district AS
SELECT ST_Clip(a.rast, b.geom, true)
FROM  public.uk_250k AS a, public.main_national_parks AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.gid  = 1;

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(st_clip), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM public.uk_lake_district;

SELECT lo_export(loid, 'C:\semestr_V\Bazy_danych_przestrzennych\zad7\myraster.tiff') --> Save the file in a placewhere the user postgres have access. In windows a flash drive usualy worksfine.
FROM tmp_out;

DROP TABLE tmp_out;

----------------------------------------------------------------------------------------
create table red as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM r1  
                        UNION ALL
                         SELECT rast FROM r2) foo;
						 
create table nir as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM nir1  
                        UNION ALL
                         SELECT rast FROM nir2) foo;


create table ndvi as
WITH r1 AS ((SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
			FROM public.red AS a, public.main_national_parks AS b
			WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1)),
			
			r2 AS ((SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
			FROM public.nir AS a, public.main_national_parks AS b
			WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1))
			
			

SELECT ST_MapAlgebra(r1.rast, r2.rast,'([rast1.val] - [rast2.val]) / ([rast2.val] +
[rast1.val])::float','32BF') AS rast 
FROM r1,r2


CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM public.ndvi;

SELECT lo_export(loid, 'C:\semestr_V\Bazy_danych_przestrzennych\zad7\zad3.tiff') --> Save the file in a placewhere the user postgres have access. In windows a flash drive usualy worksfine.
FROM tmp_out;

DROP TABLE tmp_out;
			
			

