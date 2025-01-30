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

-- Construccion de tablas de indicador de natalidad filtrado por estrato 
-- socioeconomico y porcentaje de poblacion femenina en edad reproductiva
-- que tuvieron hijo en el periodo 2003 a 2017 con respecto al total de 
-- cada manzana (menor y mayor al 50% del total)


SELECT manzanac, ed1, ed2, ed3, ed4, ed5, ed6, ed7, ed8, ed9, ed10, ed11,
ed12, ed13, ed14, ed15 FROM manzanas_cali
WHERE estrato_md >= 4 and manzanac is not null;

SELECT 

-- Creacion de tabla

CREATE TABLE resultados_17(manzanac varchar(254), ed1 int, ed2 int, ed3 int,
ed4 int, ed5 int, ed6 int, ed7 int, ed8 int, ed9 int, ed10 int, ed11 int,
ed12 int, ed13 int, ed14 int, ed15 int)

INSERT INTO resultados_17 SELECT manzanac, ed1, ed2, 
ed3, ed4, ed5, ed6, ed7, ed8, ed9, ed10, ed11, ed12, ed13, ed14, ed15
FROM manzanas_cali WHERE estrato_md >= 4 and manzanac is not null;

SELECT zona, SUM(ed1) AS nac2017, SUM(ed2) AS nac2016, SUM(ed3) AS nac2015,
SUM(ed4) AS nac2014, SUM(ed5) AS nac2013, SUM(ed6) AS nac2012, SUM(ed7) AS nac2011,
SUM(ed8) AS nac2010, SUM(ed9) AS nac2009, SUM(ed10) AS nac2008, SUM(ed11) AS nac2007,
SUM(ed12) AS nac2006, SUM(ed13) AS nac2005, SUM(ed14) AS nac2004, SUM(ed15) AS nac2003,
SUM(pred_nc18) AS pred_n2018, SUM(pred_nc19) AS pred_n2019, SUM(pred_nc20) AS pred_n2020,
SUM(pred_nc21) AS pred_n2021, SUM(pred_nc22) AS pred_n2022, SUM(pred_nc23) AS pred_n2023,
SUM(pred_nc24) AS pred_n2024, SUM(pred_nc25) AS pred_n2025, SUM(pred_nc26) AS pred_n2026,
SUM(pred_nc27) AS pred_n2027, SUM(pred_nc28) AS pred_n2028, SUM(pred_nc29) AS pred_n2029,
SUM(pred_nc30) AS pred_n2030, SUM(pred_nc31) AS pred_n2031, SUM(pred_nc32) AS pred_n2032
FROM manzanac456 where comuna = 'Comuna 2'
GROUP BY zona ORDER BY nac2017, nac2016, nac2015, nac2014, nac2013, nac2012,
nac2011, nac2010, nac2009, nac2008, nac2007, nac2006, nac2005, nac2004, nac2003,
pred_n2018, pred_n2019, pred_n2020, pred_n2021,
pred_n2022, pred_n2023, pred_n2024, pred_n2025, pred_n2026, pred_n2027,
pred_n2028, pred_n2029, pred_n2030, pred_n2031, pred_n2032;

alter table barrios add column n2003 int, add column n2004 int, add column n2005 int,
add column n2006 int, add column n2007 int, add column n2008 int, add column n2009 int,
add column n2010 int, add column n2011 int, add column n2012 int, add column n2013 int,
add column n2014 int, add column n2015 int, add column n2016 int, add column n2017 int;

alter table barrios add column pred2018 int, add column pred2019 int,
add column pred2020 int, add column pred2021 int, add column pred2022 int,
add column pred2023 int, add column pred2024 int, add column pred2025 int,
add column pred2026 int, add column pred2027 int, add column pred2028 int,
add column pred2029 int, add column pred2030 int, add column pred2031 int,
add column pred2032 int;

update barrios set pred2032 = (select SUM(pred_nc32) from manzanac456 
where manzanac456.barrio = barrios.barrio );






