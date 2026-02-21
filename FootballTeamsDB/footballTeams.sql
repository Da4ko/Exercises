CREATE SCHEMA Football_Database;
USE Football_Database;

CREATE TABLE countries(
country_id INT PRIMARY KEY AUTO_INCREMENT,
country_name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
town_id INT PRIMARY KEY AUTO_INCREMENT,
town_name VARCHAR(45) NOT NULL,
country_id INT NOT NULL,
CONSTRAINT FK_TO1 FOREIGN KEY (country_id)  REFERENCES countries(country_id)
);

CREATE TABLE stadiums(
stadium_id INT PRIMARY KEY AUTO_INCREMENT,
stadium_name VARCHAR(45) NOT NULL,
capacity INT NOT NULL,
town_id INT NOT NULL,
CONSTRAINT FK_S1 FOREIGN KEY(town_id) REFERENCES towns(town_id)
);

CREATE TABLE teams(
team_id INT PRIMARY KEY AUTO_INCREMENT,
team_name VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT DEFAULT 0 NOT NULL,
stadium_id INT NOT NULL,
CONSTRAINT FK_TE1 FOREIGN KEY (stadium_id) REFERENCES stadiums(stadium_id)
);


CREATE TABLE skills_data(
skill_data_id INT PRIMARY KEY AUTO_INCREMENT,
dribbling INT DEFAULT 0,
pace INT DEFAULT 0,
passing INT DEFAULT 0,
shooting INT DEFAULT 0,
speed INT DEFAULT 0,
strength INT DEFAULT 0
);

CREATE TABLE coaches(
coach_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
coach_level INT DEFAULT 0 NOT NULL
);

CREATE TABLE players(
player_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age int DEFAULT 0 NOT NULL,
position CHAR NOT NULL,
salary DECIMAL(10,2) DEFAULT 0 NOT NULL,
hire_date DATETIME,
skills_data_id INT NOT NULL,
team_id INT,
CONSTRAINT FK_PL1 FOREIGN KEY (skills_data_id) REFERENCES skills_data(skill_data_id),
CONSTRAINT FK_PL2 FOREIGN KEY (team_id) REFERENCES teams(team_id)
);


CREATE TABLE players_coaches(
player_id INT,
coach_id INT,
CONSTRAINT FK_PC1 FOREIGN KEY (player_id) REFERENCES players(player_id),
CONSTRAINT FK_PC2 FOREIGN KEY (coach_id) REFERENCES coaches(coach_id) 
);

-- Insertinsert records of data into the coaches table, based on the players table.
-- For players with age over 45 (inclusive), insert data in the coaches table with the following values:

-- first_name – set it to first name of the player
-- last_name – set it to last name of the player.
-- salary – set it to double as player’s salary.
-- coach_level – set it to be equals to count of the characters in player’s first_name.

INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary*2, LENGTH(first_name) FROM players WHERE age>=45;

-- Update all coaches, who train one or more players and their first_name starts with ‘A’. Increase their level with 1.
UPDATE coaches
JOIN players_coaches on coaches.coach_id = players_coaches.coach_id
SET coach_level = coach_level+1
WHERE coaches.first_name like "A%";

-- Delete all players from table players, which are already added in table coaches.
DELETE FROM players WHERE (first_name, last_name, salary) IN(
SELECT first_name, last_name, salary/2 FROM coaches
);

-- Extract info about all of the players.
-- Order the results by players - salary descending.

SELECT * FROM players 
ORDER BY salary DESC;


-- Identify all young offensive players who are under the age of 23 and play in the 'A' position. 
-- To qualify for this scout report, the players must currently be free agents with no hire_date on record and possess
-- a physical strength rating exceeding 50. The resulting list should be ordered primarily
-- by salary in ascending order, with age as the secondary ascending sort.

SELECT player_id, CONCAT(first_name, " ", last_name) AS full_name, age, position, hire_date FROM players
JOIN skills_data ON players.skills_data_id = skills_data.skill_data_id
WHERE age<23 AND position="A" AND hire_date IS NULL AND strength>50
ORDER BY salary, age;


-- Extract from the database all of the teams and the count of the players that they have.
-- Order the results descending by count of players, then by fan_base descending.

SELECT team_name, fan_base, COUNT(players.team_id) AS count_of_players FROM teams 
JOIN players ON teams.team_id = players.team_id
GROUP BY(players.team_id)
ORDER BY count_of_players DESC, fan_base DESC;


-- Extract from the database the speed of the fastest player (having max speed), in terms of towns where their team played.
-- Order by speed descending, then by town name.
-- Skip players that played in team ‘Devify’

SELECT MAX(speed) AS max_speed, town_name FROM players 
JOIN skills_data ON players.skills_data_id = skills_data.skill_data_id
JOIN teams ON teams.team_id = players.team_id
JOIN stadiums ON teams.stadium_id = stadiums.stadium_id
JOIN towns ON towns.town_id = stadiums.town_id
WHERE team_name != "Devify"
GROUP BY town_name
ORDER BY max_speed desc, town_name;


-- You need to extract detailed information on the amount of all salaries given to football players by the criteria of the country in which they played.
-- If there are no players in a country, display NULL. Order the results by total count of players in descending order, then by country name alphabetically.

SELECT country_name, COUNT(players.player_id) as count_of_players , SUM(salary) total_salary_for_the_country FROM countries
LEFT JOIN towns ON towns.country_id = countries.country_id
LEFT JOIN stadiums ON towns.town_id = stadiums.town_id
LEFT JOIN teams ON stadiums.stadium_id = teams.stadium_id
LEFT JOIN players ON teams.team_id = players.team_id
GROUP BY country_name
ORDER BY count_of_players DESC, country_name











