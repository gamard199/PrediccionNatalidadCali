# Proyecto de Geomarketing Educativo en Cali con Análisis de Machine Learning

Proyecto de machine learning enfocado en la predicción de datos demográficos de nacimientos desde el año 2018 en los barrios y manzanas censales de Cali de acuerdo a la información del Censo de Población 2018 del DANE.

## Presentación

El Proyecto de Machine Learning para geomarketing educativo en Cali pretende apoyar las labores de estimación de la población escolar en los territorios de la ciudad de Cali realizadas por los equipos de marketing educativo de las Instituciones educativas de la ciudad para complementar la información demográfica brindada por el Censo Nacional de Población y Vivienda 2018, publicada por el DANE, de manera que dichos equipos de investigación de mercados puedan dimensionar la demanda del servicio educativo en los territorios, con un alcance posterior al año 2018 en el cual se realizó el Censo de Población mencionado, utilizando técnicas de machine learning para la predicción de datos estadísticos.

## Objetivo General

Predecir los datos de personas que nacieron entre los años 2018 y el año 2032 en los barrios de estratos socioeconómicos 5 y 6 de la ciudad de Cali - Colombia con fines de estimar la población o mercado objetivo para la prestación del servicio educativo en las zonas La Flora (Norte), Santa Monica (Norte), Oeste, El Lido (suroccidente), El Ingenio (Sur) y Ciudad Jardin (Sur) de la ciudad de Cali.

## Objetivos Especificos

Ajustar los datos de número de viviendas por barrio y estrato socioeconomico 5 y 6, publicados por la Alcaldía de Cali, relacionando la densidad de población femenina en edad reproductiva por manzana censal, como universo potencial base sobre el cual se estimará el porcentaje de nacimientos de acuerdo a datos historicos de los Censos de Población y Vivienda de los años 2018 y 2005 para realizar el entrenamiento del algoritmo con el que se pretende predecir el dato de nacimientos posteriores al año 2018 y hasta el año 2032.

## Fuentes de datos:

Censos Nacionales de Población y Vivienda 2018 y 2005. Departamento Administrativo Nacional de Estadística DANE. Infraestructura de Datos Espaciales de Santiago de Cali, IDESC.

## Tecnologías y software utilizados:

Lenguaje de programación: Python 3.8  
Entorno de desarrollo integrado (IDE): Jupyter Notebook  
Librerías de Python: MatplotLib, Pandas, NumPy, Scikit-Learn  
Sistema gerenciador de bases de datos: PostgreSQL con extensión PostGIS para soporte de datos espaciales  
Sistema de información geográfica: QGIS 3.4

## Instrucciones:

Para consultar el código de desarrollo del modelo predictivo de datos demográficos de natalidad en la ciudad de Cali, que utiliza el algoritmo Bosques Aleatorios Regresión de Machine Learning, por favor ver archivos con extensión RandomForestHistorico.ipynb (Jupyter Notebook)

Para visualizar los graficos de análisis de datos demográficos consultar carpeta "Graficas"

