-- file: schema.sql
--
-- this is the original Gallagher Microsoft SQL schema, except:
--     replaced nvarchar with varchar
--     replaced datetime with timestamp
--
-- as a regression test, this file can be executed in psql:
--     \i schema.sql
--
-- John DeGood
-- degoodj@tcnj.edu
-- March 2024

DROP TABLE Animal;
CREATE TABLE Animal (
	animal_id integer primary key,
	lrid integer NOT NULL default 0,
	tag varchar(16) NOT NULL default '',
	rfid varchar(15) NOT NULL default '',
	nlis varchar(16) NOT NULL default '',
	is_new integer NOT NULL default 1,
	draft varchar(20) NOT NULL default '',
	sex varchar(20) NOT NULL default '',
	dob timestamp,
	sire varchar(16) NOT NULL default '',
	dam varchar(16) NOT NULL default '',
	breed varchar(20) NOT NULL default '',
	colour varchar(20) NOT NULL default '',
	weaned integer NOT NULL default 0 ,
	prev_tag varchar(10) NOT NULL default '',
	prev_pic varchar(20) NOT NULL default '',
	note varchar(30) NOT NULL default '',
	note_date timestamp,
	is_exported integer NOT NULL default 0,
	is_history integer NOT NULL default 0,
	is_deleted integer NOT NULL default 0,
	tag_sorter varchar(48) NOT NULL default '',
	donordam varchar(16) NOT NULL default '',
	whp timestamp,
	esi timestamp,
	status varchar(20) NOT NULL default '',
	status_date timestamp,
	overall_adg varchar(20) NOT NULL default '',
	current_adg varchar(20) NOT NULL default '',
	last_weight varchar(20) NOT NULL default '',
	last_weight_date timestamp,
	selected integer default 0,
	animal_group varchar(20) NOT NULL default '',
	current_farm varchar(20) NOT NULL default '',
	current_property varchar(20) NOT NULL default '',
	current_area varchar(20) NOT NULL default '', 
	current_farm_date timestamp,
	current_property_date timestamp,
	current_area_date timestamp,
	animal_group_date timestamp,
	sex_date timestamp,
	breed_date timestamp,
	dob_date timestamp,
	colour_date timestamp,
	prev_pic_date timestamp,
	sire_date timestamp,
	dam_date timestamp,
	donordam_date timestamp,
	prev_tag_date timestamp,
	tag_date timestamp,
	rfid_date timestamp,
	nlis_date timestamp,
	modified timestamp,
	full_rfid varchar(16) default '',
	full_rfid_date timestamp);

DROP TABLE Note;
CREATE TABLE Note (
	animal_id integer NOT NULL,
	created timestamp,
	note varchar(30) NOT NULL,
	session_id integer NOT NULL,
	is_deleted integer default 0,
	is_alert integer default 0,
	primary key( animal_id, created ));

DROP TABLE SessionAnimalActivity;
CREATE TABLE SessionAnimalActivity (
	session_id integer NOT NULL,
	animal_id integer NOT NULL,
	activity_code integer NOT NULL,
	when_measured timestamp NOT NULL,
	latestForSessionAnimal integer default 1,
	latestForAnimal integer default 1,
	is_history integer NOT NULL default 0,
	is_exported integer NOT NULL default 0,
	is_deleted integer default 0,
	primary key( session_id, animal_id, activity_code, when_measured ));

DROP TABLE SessionAnimalTrait;
CREATE TABLE SessionAnimalTrait (
	session_id integer NOT NULL,
	animal_id integer NOT NULL,
	trait_code integer NOT NULL,
	alpha_value varchar(20) NOT NULL default '',
	alpha_units varchar(10) NOT NULL default '',
	when_measured timestamp NOT NULL,
	latestForSessionAnimal integer default 1,
	latestForAnimal integer default 1,
	is_history integer NOT NULL default 0,
	is_exported integer NOT NULL default 0,
	is_deleted integer default 0,
	primary key(session_id, animal_id, trait_code, when_measured));

DROP TABLE PicklistValue;
CREATE TABLE PicklistValue (
	picklistvalue_id integer NOT NULL,
	picklist_id integer NOT NULL,
	value varchar(30) NOT NULL DEFAULT '',
	PRIMARY KEY (picklistvalue_id)
);

-- read the CSV file into the table
\copy Animal from 'Animal.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy Note from 'Note.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalActivity from 'SessionAnimalActivity.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalTrait from 'SessionAnimalTrait.csv' WITH DELIMITER ',' CSV HEADER;

\copy PicklistValue FROM 'PicklistValue.csv' WITH DELIMITER ',' CSV HEADER;

DROP TABLE Trait; 
DROP TABLE Picklist; 
DROP TABLE Goat;

CREATE TABLE Goat (
	goat_id integer primary key,
	sex varchar(20) NOT NULL default '',
	dob timestamp,
	status varchar(20) NOT NULL default '',
	status_date timestamp,
	overall_adg varchar(20) NOT NULL DEFAULT '0'
);

CREATE TABLE Picklist (
	picklistvalue_id integer NOT NULL,
	value varchar(30) NOT NULL DEFAULT '',
	PRIMARY KEY (picklistvalue_id)
);

CREATE TABLE Trait (
	goat_id integer NOT NULL REFERENCES Goat,
	trait_code integer NOT NULL REFERENCES Picklist,
	alpha_value varchar(20) NOT NULL default '',
	when_measured timestamp NOT NULL,
	primary key(goat_id, trait_code, when_measured)
);

INSERT INTO Picklist
SELECT picklistvalue_id, value
FROM PicklistValue;

INSERT INTO Goat
SELECT animal_id, sex, dob, status, status_date,
CASE WHEN length(Animal.overall_adg) = 0 THEN '0' 
ELSE Animal.overall_adg END AS overall_adg
FROM Animal;

INSERT INTO Trait
SELECT animal_id, trait_code,
CASE WHEN length(T.alpha_value) = 0 THEN '-1' 
ELSE T.alpha_value END AS alpha_value, when_measured
FROM SessionAnimalTrait AS T;
