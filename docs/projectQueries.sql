ACCEPT inputYear1, inputYear 2
SELECT birth_year, birth_weight
FROM Goat 
WHERE inputYear1=birth_year OR inputYear2=birth_year
ORDER BY birth_year; 
Average / Mean : SELECT avg(column) AS column_avg. FROM table;
Median: SELECT. percentile_cont(.5) WITHIN GROUP (ORDER BY column) FROM table_name;


SELECT value, overall_adg
FROM Trait JOIN Goat ON goat_id=animal_id
WHERE trait_code=(
SELECT picklistvalue_id FROM picklist value WHERE value= ”vigor score”;
) OR trait_code=(
	SELECT picklistvalue_id FROM picklist value WHERE value= “Dead”;
);
