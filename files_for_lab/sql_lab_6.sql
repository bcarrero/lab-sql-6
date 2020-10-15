-- Instructions
USE sakila;

/* 
Lab | SQL Queries 6
 We are going to do some database maintenance. We have received the film catalog for 2020. 
 We have just one item for each film, and all will be placed in store 2. 
 All other movies will be moved to store 1. 
 The rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost of 8.99€. 
 The catalog is in a CSV file named films_2020.csv that can be found at files_for_lab folder.
 Instructions
    Add the new films to the database.
    Update inventory.
*/
SHOW VARIABLES LIKE 'secure_file_priv';
-- Besides locating where the upload folder is, the SQL mode prevents to import data which is eventually not going to be complete... giving you an error when you run the import function.
-- We need to change the SQL mode at least for the session and delete the "strict" part.
-- this doesn't work => SHOW VARIABLES LIKE 'sql-mode';
SELECT @@sql_mode; 
-- didn't work: SET @@global.sql_mode= 'NO_ENGINE_SUBSTITUTION';
-- didn't seem to work: SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'NO_ENGINE_SUBSTITUTION';
-- This one Worked!!!!

describe film;

-- copy structure from film but not content
DROP TABLE film_backup;
CREATE TABLE film_backup LIKE FILM;
INSERT film_backup 
SELECT *
FROM film;

DROP TABLE test;
CREATE TABLE test LIKE FILM;
INSERT test 
SELECT *
FROM film;
-- Need to add movies first to inventory 

SELECT * from test;
DESCRIBE film;

INSERT INTO film (campaign_id, mobile, vote, vote_date)  
SELECT campaign_id, from_number, received_msg, date_received
  FROM `received_txts`
 WHERE `campaign_id` = '8';

-- yet another issue => EOL character in Windows is different than the EOL in LINUX or MAC... I had to put '\r\n' for MYSQL to identify the end of the line
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\films_2020_v2.csv' 
INTO TABLE film
FIELDS TERMINATED BY ','
ENCLOSED BY'"'
LINES TERMINATED BY '\r\n'
(title,description,release_year,language_id,original_language_id,length,rating,special_features);

SELECT * from test order by film_id DESC;
-- Yessssssssssssssssssssssssssssssssssssssss... this works :-)
-- Now we want to add the new films 
-- The rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost of 8.99€. 
-- REPLACE INTO test(rental_duration,rental_rate,replacement_cost)
-- VALUES(3,2.99,8.99) WHERE release_year = 2020;

SELECT * from test WHERE rental_duration <> 3 AND release_year = 2020 order by film_id DESC;
SELECT * from test WHERE rental_rate <> 2.99 AND release_year = 2020 order by film_id DESC;

UPDATE test SET rental_duration = 3, rental_rate = 2.99, replacement_cost = 8.99 
WHERE release_year = 2020; 

SELECT * from inventory; -- where store_id =1;
UPDATE inventory SET store_id = 1
WHERE store_id = 2; 
-- We have changed all old movies to store 1
-- Now we need to add all new movies to the inventory and store 2.

 

