-- Creating tables

-- Creating a database schema statistics of professional teams
-- and players by discipline CS:GO
-- For convenience and to make it short, we will create a "cs" scheme
DROP SCHEMA IF EXISTS cs CASCADE;
CREATE SCHEMA cs;
SET search_path = cs;

-- Table of players
DROP TABLE IF EXISTS cs.player;
CREATE TABLE cs.player (
  player_id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  nickname VARCHAR(255) NOT NULL,
  age INT NOT NULL,
  nationality VARCHAR(255)
);

-- Table of tournaments
DROP TABLE IF EXISTS cs.tournament;
CREATE TABLE cs.tournament (
  tournament_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  location VARCHAR(255),
  format_lan BOOL DEFAULT TRUE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  teams SMALLINT NOT NULL,
  prize_pool INT
);

-- Table of statistics of players in a certain tournament
    -- K_D - Kills/Deaths of player
    -- K_D_Diff - the difference of kills/deaths of player
    -- MVP - Most Valuable Player in tournament (can be only one player)
DROP TABLE IF EXISTS cs.player_stats;
CREATE TABLE cs.player_stats (
  player_id INT NOT NULL,
  tournament_id INT NOT NULL,
  maps_played INT DEFAULT 0,
  rounds INT DEFAULT 0,
  K_D_Diff DECIMAL DEFAULT 0.00,
  K_D INT DEFAULT 0,
  raiting DECIMAL DEFAULT 0.00,
  MVP BOOL DEFAULT FALSE,
  -- Primary Key
  -- Since a player can only have one statistic in a certain tournament
  PRIMARY KEY(player_id, tournament_id),
  FOREIGN KEY (player_id) REFERENCES cs.player(player_id),
  FOREIGN KEY (tournament_id) REFERENCES cs.tournament(tournament_id)
);

-- Table of teams
DROP TABLE IF EXISTS cs.team;
CREATE TABLE cs.team (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  country VARCHAR(255) NOT NULL,
  logo_url VARCHAR(255) NOT NULL UNIQUE ,
  date_of_foundation DATE NOT NULL,
  tournaments_win INT DEFAULT 0
);

-- Table of rosters
    -- Starter - The main player who plays within the specified time range
    -- Benched - A player who remains in the roster of the team, but does not play at the moment
DROP TABLE IF EXISTS cs.roster;
CREATE TABLE cs.roster (
  player_id INT NOT NULL,
  team_id INT NOT NULL,
  status VARCHAR(255) NOT NULL,
  maps_played INT DEFAULT '0',
  valid_from DATE NOT NULL ,
  valid_to DATE DEFAULT '9999-12-31',
  FOREIGN KEY (player_id) REFERENCES cs.player(player_id),
  FOREIGN KEY (team_id) REFERENCES cs.team(team_id)
);

-- Table of statistics of teams in a certain tournament
    -- K_D - Kills/Deaths of team
    -- K_D_Diff - the difference of kills/deaths of team
DROP TABLE IF EXISTS cs.team_stats;
CREATE TABLE cs.team_stats (
  team_id INT NOT NULL,
  tournament_id INT NOT NULL,
  maps_played INT DEFAULT '0',
  raiting DECIMAL DEFAULT 0.00,
  K_D DECIMAL DEFAULT 0.00,
  K_D_Diff INT DEFAULT 0,
  PRIMARY KEY (team_id, tournament_id),
  FOREIGN KEY (team_id) REFERENCES cs.team(team_id),
  FOREIGN KEY (tournament_id) REFERENCES cs.tournament(tournament_id)
);

-- Table of teams ranking
DROP TABLE IF EXISTS cs.team_ranking;
CREATE TABLE cs.team_ranking (
  team_id INT NOT NULL,
  hltv_points INT DEFAULT '0',
  valid_from DATE NOT NULL ,
  valid_to DATE DEFAULT '9999-12-31',
  FOREIGN KEY (team_id) REFERENCES cs.team(team_id)
);

-- Table of maps in CS:GO
DROP TABLE IF EXISTS cs.maps;
CREATE TABLE cs.maps (
  map_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Table of matches
DROP TABLE IF EXISTS cs.match;
CREATE TABLE cs.match (
  winning_team_id INT NOT NULL,
  losing_team_id INT NOT NULL,
  map_id INT NOT NULL,
  tournament_id INT NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (winning_team_id) REFERENCES cs.team(team_id),
  FOREIGN KEY (losing_team_id) REFERENCES cs.team(team_id),
  FOREIGN KEY (map_id) REFERENCES cs.maps(map_id),
  FOREIGN KEY (tournament_id) REFERENCES cs.tournament(tournament_id)
);

