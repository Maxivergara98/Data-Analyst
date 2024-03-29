#DATA CLEANING

#CHANGE NAME FROM ï»¿id TO ID
ALTER TABLE us_household_income_statistics
RENAME COLUMN `ï»¿id` to `id`;

SELECT * FROM us_household_income_statistics;
SELECT * FROM us_household_income;

#CHEQUEAR SI HAY DUPLICADOS EN EL DATASET
SELECT ID, COUNT(ID) 
FROM us_household_income
GROUP BY ID
HAVING COUNT(ID) > 1;


SELECT *
FROM 
	(
	SELECT ROW_ID, 
	ID,
	ROW_NUMBER () OVER (PARTITION BY ID ORDER BY ID) ROW_NUM
	FROM  us_household_income) AS R1
	WHERE ROW_NUM > 1;

#BORRAMOS LOS REGISTROS DUPLICADOS 
DELETE FROM us_household_income
WHERE ROW_ID IN (
	SELECT ROW_ID
	FROM 
		(
		SELECT ROW_ID, 
		ID,
		ROW_NUMBER () OVER (PARTITION BY ID ORDER BY ID) ROW_NUM
		FROM  us_household_income) AS R1
	WHERE ROW_NUM > 1);


#CHEQUMOAS STATE_NAME QUE SEAN TODOS IGUALES
SELECT * FROM us_household_income;

SELECT STATE_NAME, COUNT(STATE_NAME) 
FROM us_household_income
GROUP BY STATE_NAME
ORDER BY COUNT(STATE_NAME) ASC;

SELECT DISTINCT STATE_NAME
FROM us_household_income;

#STANDARIZAR DATA, ALABAMA Y GEORGIA ESTAN DISTINTOS
UPDATE us_household_income
SET STATE_NAME = 'Alabama'
WHERE STATE_NAME = 'alabama';

UPDATE us_household_income
SET STATE_NAME = 'Georgia'
WHERE STATE_NAME = 'georia';

#INSERTAMOS EN UN VALOR SIN NADA, EL PLACE "'Autauga County" YA QUE BASADO EN LA INFORMACION ESE EN EL PLACE DE ESE COUNTY
SELECT *
FROM us_household_income
WHERE COUNTY = 'Autauga County';

SELECT *
FROM us_household_income
WHERE PLACE = '';

UPDATE us_household_income
SET PLACE = 'Autaugaville' 
WHERE COUNTY = 'Autauga County' AND CITY = 'Vinemont';


#CHEQUEMAOS LA STANDARDIZACION DE TPYE, HAY UN PROBLEMA DE CDP Y HAY UN CPD QUE ESTAN MAL, Y HAY UN ERROR EN BOROUGH Y 'Boroughs'
#ENTONCES CAMBIAMOS ESOS DATOS.
SELECT TYPE, COUNT(TYPE)
FROM us_household_income
GROUP BY TYPE;

UPDATE us_household_income
SET TYPE = 'CDP'  
WHERE TYPE = 'CPD';

UPDATE us_household_income
SET TYPE = 'Borough'
WHERE TYPE = 'Boroughs';

SELECT ALAND, AWATER
FROM us_project.us_household_income
WHERE (ALAND = 0 OR ALAND = '' OR ALAND IS NULL)
AND (AWATER = 0 OR AWATER = '' OR AWATER IS NULL);