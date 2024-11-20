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









