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

-- Segmentacion geografica de los datos de la BD por comunas y barrios

---- Creacion de campos de segmentacion geografica

ALTER TABLE manzanas_cali ADD COLUMN comuna varchar(20), 
ADD COLUMN barrio varchar(70);

---- Segmentacion geografica por comuna y barrio

UPDATE manzanas_cali SET comuna = (SELECT comunas.nombre FROM comunas 
WHERE ST_Intersects(manzanas_cali.geom, comunas.geom));

UPDATE manzanas_cali SET barrio = (SELECT barrios.nombre FROM barrios 
WHERE ST_Intersects(manzanas_cali.geom, barrios.geom));



-- Segmentacion geografica por zonas de la Comuna 2

---- Creacion de campo para realizar la segmentacion por zonas

ALTER TABLE manzanas_cali ADD COLUMN zona varchar(20);

---- Creacion de tabla de indicadores de numero de nacimientos por zona por año

SELECT zona, ed1 , ed2 AS ed, SUM(ed3) AS edad3, 
SUM(ed4) AS edad4, SUM(ed5) AS edad5, SUM(ed6) AS edad6, SUM(ed7) AS edad7,
SUM(ed8) AS edad8, SUM(ed9) AS edad9, SUM(ed10) AS edad10, SUM(ed11) AS edad11,
SUM(ed12) AS edad12, SUM(ed13) AS edad13, SUM(ed14) AS edad14, 
SUM(ed15) AS edad15
FROM manzanas_cali WHERE comuna = 'Comuna 2' and ed1 is not null 
and totaled0_15 >= 50 
GROUP BY zona ORDER BY edad1, edad2, edad3, edad4, edad5, edad6, edad7, edad8,
edad9, edad10, edad11, edad12, edad13, edad14, edad15;

-- Segmentacion geografica de manzanas por estrato moda del barrio donde se ubica

ALTER TABLE manzanas_cali ADD COLUMN estrato_md int;

-- Construccion de indicador de promedio de poblacion femenina en edad 
-- reproductiva para los 3 quinquenios por manzana

---- Creacion del campo

ALTER TABLE manzanas_cali ADD COLUMN prom_mer03_17 double precision;

---- Construccion del indicador

UPDATE manzanas_cali SET prom_mer03_17 = (mer13_17+mer08_12+mer03_07)/3;

-- Construccion de indicador de porcentaje de mujeres en edad reproductiva 
-- que tuvieron hijo en el periodo 2003 a 2017 con respecto al promedio
-- de poblacion total femenina para los 3 quinquenios

---- Creacion del campo

ALTER TABLE manzanas_cali ADD COLUMN porc_nmer03_17 double precision;

---- Calculo del indicador de porcentaje

UPDATE manzanas_cali SET porc_nmer03_17 = totaled0_15 / prom_mer03_17
where prom_mer03_17 <> 0;















