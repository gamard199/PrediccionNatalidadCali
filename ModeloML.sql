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

