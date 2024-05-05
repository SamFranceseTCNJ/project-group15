CREATE VIEW Goat AS 
SELECT animal_id AS goat_id, sex, overall_adg, dob
FROM Animal;	

CREATE VIEW Picklist AS
	SELECT picklistvalue_id, value
	FROM PicklistValue;

CREATE VIEW Trait AS 
	SELECT animal_id, trait_code, value
	FROM SessionAnimalActivity; 
