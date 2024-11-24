-- Creacion de extension Postgis para el soporte de datos espaciales en la base de datos

CREATE EXTENSION postgis;

-- Creacion de los campos de numero de mujeres en edad reproductiva MER para los
-- periodos 2013 a 2017, 2008 a 2013 y 2003 a 2007 (15 años antes del Censo 2018)

ALTER TABLE manzanas_cali ADD COLUMN mer13_17 int, ADD COLUMN mer08_12 int,
ADD COLUMN mer03_07 int;

-- Calculo de indicador de numero de mujeres en edad reproductiva para cada 
-- periodo modelo

UPDATE manzanas_cali SET mer13_17 = (mujr20_24 + mujr25_29 + mujr30_34 + mujr35_39 + mujr40_44 + mujr45_49); 
UPDATE manzanas_cali SET mer08_12 = (mujr25_29 + mujr30_34 + mujr35_39 + mujr40_44 + mujr45_49 + mujr50_54); 
UPDATE manzanas_cali SET mer03_07 = (mujr30_34 + mujr35_39 + mujr40_44 + mujr45_49 + mujr50_54 + mujr55_59); 

-- Calculo de indicadores de porcentaje de nacimientos con respecto al total de
-- mujeres en edad reproductiva para cada año desde 2003 hasta 2017

---- Creacion de campos para indicadores

ALTER TABLE manzanas_cali ADD COLUMN prc_nmer03 double precision,
ADD COLUMN prc_nmer04 double precision, ADD COLUMN prc_nmer05 double precision,
ADD COLUMN prc_nmer06 double precision, ADD COLUMN prc_nmer07 double precision,
ADD COLUMN prc_nmer08 double precision, ADD COLUMN prc_nmer09 double precision,
ADD COLUMN prc_nmer10 double precision, ADD COLUMN prc_nmer11 double precision,
ADD COLUMN prc_nmer12 double precision, ADD COLUMN prc_nmer13 double precision,
ADD COLUMN prc_nmer14 double precision, ADD COLUMN prc_nmer15 double precision,
ADD COLUMN prc_nmer16 double precision, ADD COLUMN prc_nmer17 double precision;



-- Calculo de indicadores por cada año

---- año 2003
UPDATE manzanas_cali SET prc_nmer03 = ROUND((cast(ed15 as double precision)/mer03_07)*100, 4) 
where mer03_07 <>0;

---- año 2004
UPDATE manzanas_cali SET prc_nmer04 = (cast(ed14 as double precision)/mer03_07)*100 
where mer03_07 <>0;

---- año 2005
UPDATE manzanas_cali SET prc_nmer05 = (cast(ed13 as double precision)/mer03_07)*100 
where mer03_07 <>0;

---- año 2006
UPDATE manzanas_cali SET prc_nmer06 = (cast(ed12 as double precision)/mer03_07)*100 
where mer03_07 <>0;

---- año 2007
UPDATE manzanas_cali SET prc_nmer07 = (cast(ed11 as double precision)/mer03_07)*100 
where mer03_07 <>0;

---- año 2008
UPDATE manzanas_cali SET prc_nmer08 = (cast(ed10 as double precision)/mer08_12)*100 
where mer08_12 <>0;

---- año 2009
UPDATE manzanas_cali SET prc_nmer09 = (cast(ed9 as double precision)/mer08_12)*100 
where mer08_12 <>0;

---- año 2010
UPDATE manzanas_cali SET prc_nmer10 = (cast(ed8 as double precision)/mer08_12)*100 
where mer08_12 <>0;

---- año 2011
UPDATE manzanas_cali SET prc_nmer11 = (cast(ed7 as double precision)/mer08_12)*100 
where mer08_12 <>0;

---- año 2012
UPDATE manzanas_cali SET prc_nmer12 = (cast(ed6 as double precision)/mer08_12)*100 
where mer08_12 <>0;

---- año 2013
UPDATE manzanas_cali SET prc_nmer13 = (cast(ed5 as double precision)/mer13_17)*100 
where mer13_17 <>0;

---- año 2014
UPDATE manzanas_cali SET prc_nmer14 = (cast(ed4 as double precision)/mer13_17)*100 
where mer13_17 <>0;

---- año 2015
UPDATE manzanas_cali SET prc_nmer15 = (cast(ed3 as double precision)/mer13_17)*100 
where mer13_17 <>0;

---- año 2016
UPDATE manzanas_cali SET prc_nmer16 = (cast(ed2 as double precision)/mer13_17)*100 
where mer13_17 <>0;

---- año 2017
UPDATE manzanas_cali SET prc_nmer17 = (cast(ed1 as double precision)/mer13_17)*100 
where mer13_17 <>0;


-- Segmentacion geografica de los datos de la BD por comunas y barrios

---- Creacion de campos de segmentacion geografica

ALTER TABLE manzanas_cali ADD COLUMN comuna varchar(20), 
ADD COLUMN barrio varchar(70);

---- Segmentacion geografica por comuna y barrio

UPDATE manzanas_cali SET comuna = (SELECT comunas.nombre FROM comunas 
WHERE ST_Intersects(manzanas_cali.geom, comunas.geom));

UPDATE manzanas_cali SET barrio = (SELECT barrios.nombre FROM barrios 
WHERE ST_Intersects(manzanas_cali.geom, barrios.geom));

-- Construccion y generacion de tabla de indicadores de procentaje de poblacion
-- femenina en edad reproductiva que tuvo hijo en cada año de la serie modelo
-- con respecto al total de poblacion universo con potencial reproductivo 
-- segmentado por manzana censal en la comuna 2 de Cali

SELECT manz_ccnct AS codigo_manzana, prc_nmer03, prc_nmer04, prc_nmer05,
prc_nmer06, prc_nmer07, prc_nmer08, prc_nmer09, prc_nmer10, prc_nmer11,
prc_nmer12, prc_nmer13, prc_nmer14, prc_nmer15, prc_nmer16, prc_nmer17
FROM manzanas_cali WHERE comuna = 'Comuna 2' and prc_nmer03 is not null;

-- Segmentacion geografica por zonas de la Comuna 2

---- Creacion de campo para realizar la segmentacion por zonas

ALTER TABLE manzanas_cali ADD COLUMN zona varchar(20);

---- Creacion de tabla de indicadores de numero de nacimientos por zona por año

SELECT zona, SUM(ed1) AS edad1, SUM(ed2) AS edad2, SUM(ed3) AS edad3, 
SUM(ed4) AS edad4, SUM(ed5) AS edad5, SUM(ed6) AS edad6, SUM(ed7) AS edad7,
SUM(ed8) AS edad8, SUM(ed9) AS edad9, SUM(ed10) AS edad10, SUM(ed11) AS edad11,
SUM(ed12) AS edad12, SUM(ed13) AS edad13, SUM(ed14) AS edad14, 
SUM(ed15) AS edad15
FROM manzanas_cali WHERE comuna = 'Comuna 2' and ed1 is not null 
and zona is not null
GROUP BY zona ORDER BY edad1, edad2, edad3, edad4, edad5, edad6, edad7, edad8,
edad9, edad10, edad11, edad12, edad13, edad14, edad15;












