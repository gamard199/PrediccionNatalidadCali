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
ADD COLUMN prc_nmer14 double precision, ADD COLUMN prc_nmer15 double precision;



