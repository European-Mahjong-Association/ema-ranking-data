CREATE TABLE players (
	id VARCHAR NOT NULL, 
	last_name VARCHAR NOT NULL, 
	first_name VARCHAR NOT NULL, 
	nationality VARCHAR NOT NULL, 
	status VARCHAR NOT NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE cities (
	id INTEGER NOT NULL, 
	name VARCHAR NOT NULL, 
	country VARCHAR NOT NULL, 
	latitude FLOAT NOT NULL, 
	longitude FLOAT NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_ville_nom_pays UNIQUE (name, country)
);

CREATE TABLE championship_series (
	id INTEGER NOT NULL, 
	slug VARCHAR NOT NULL, 
	name VARCHAR NOT NULL, 
	rules VARCHAR NOT NULL, 
	country VARCHAR NOT NULL, 
	description VARCHAR, 
	PRIMARY KEY (id), 
	UNIQUE (slug)
);

CREATE INDEX ix_serie_championnat_pays ON championship_series (country);

CREATE TABLE country_memberships (
	id INTEGER NOT NULL, 
	country VARCHAR NOT NULL, 
	year INTEGER NOT NULL, 
	count INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_membership_country_year UNIQUE (country, year)
);

CREATE INDEX ix_membership_country ON country_memberships (country);

CREATE TABLE tournaments (
	id INTEGER NOT NULL, 
	ema_id INTEGER, 
	is_mers BOOLEAN NOT NULL, 
	rules VARCHAR NOT NULL, 
	name VARCHAR NOT NULL, 
	city_id INTEGER, 
	country VARCHAR NOT NULL, 
	start_date DATE NOT NULL, 
	end_date DATE NOT NULL, 
	nb_players INTEGER NOT NULL, 
	coefficient FLOAT NOT NULL, 
	tournament_type VARCHAR NOT NULL, 
	status VARCHAR NOT NULL, 
	approval VARCHAR, 
	website VARCHAR, 
	registration_open DATE, 
	created_at DATETIME, 
	obs_report_path VARCHAR, 
	obs_observer VARCHAR, 
	obs_player_id VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(city_id) REFERENCES cities (id), 
	FOREIGN KEY(obs_player_id) REFERENCES players (id)
);

CREATE UNIQUE INDEX uq_tournoi_ema_regles ON tournaments (ema_id, rules) WHERE ema_id IS NOT NULL;

CREATE TABLE nationality_changes (
	id INTEGER NOT NULL, 
	player_id VARCHAR NOT NULL, 
	nationality_before VARCHAR NOT NULL, 
	nationality_after VARCHAR NOT NULL, 
	change_date DATE NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (player_id, change_date), 
	FOREIGN KEY(player_id) REFERENCES players (id)
);

CREATE TABLE championships (
	id INTEGER NOT NULL, 
	series_id INTEGER NOT NULL, 
	year INTEGER NOT NULL, 
	name VARCHAR, 
	formula VARCHAR NOT NULL, 
	params VARCHAR NOT NULL, 
	champion_id VARCHAR, 
	champion_name VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(series_id) REFERENCES championship_series (id), 
	FOREIGN KEY(champion_id) REFERENCES players (id)
);

CREATE TABLE ranking_history (
	id INTEGER NOT NULL, 
	week DATE NOT NULL, 
	rules VARCHAR NOT NULL, 
	player_id VARCHAR NOT NULL, 
	position INTEGER NOT NULL, 
	score FLOAT NOT NULL, 
	nb_tournaments INTEGER, 
	nb_gold INTEGER, 
	nb_silver INTEGER, 
	nb_bronze INTEGER, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_classement_semaine UNIQUE (week, rules, player_id), 
	FOREIGN KEY(player_id) REFERENCES players (id)
);

CREATE INDEX ix_classement_joueur ON ranking_history (player_id, rules, week);

CREATE INDEX ix_classement_semaine ON ranking_history (week, rules);

CREATE TABLE referees (
	id INTEGER NOT NULL, 
	name VARCHAR NOT NULL, 
	country VARCHAR NOT NULL, 
	rules VARCHAR NOT NULL, 
	seminar_year INTEGER, 
	seminar_location VARCHAR, 
	seminar_city_id INTEGER, 
	player_id VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(seminar_city_id) REFERENCES cities (id), 
	FOREIGN KEY(player_id) REFERENCES players (id)
);

CREATE TABLE results (
	id INTEGER NOT NULL, 
	tournament_id INTEGER NOT NULL, 
	player_id VARCHAR NOT NULL, 
	position INTEGER NOT NULL, 
	points INTEGER NOT NULL, 
	mahjong INTEGER NOT NULL, 
	ranking INTEGER NOT NULL, 
	nationality VARCHAR, 
	PRIMARY KEY (id), 
	FOREIGN KEY(tournament_id) REFERENCES tournaments (id), 
	FOREIGN KEY(player_id) REFERENCES players (id)
);

CREATE TABLE anonymous_results (
	id INTEGER NOT NULL, 
	tournament_id INTEGER NOT NULL, 
	position INTEGER NOT NULL, 
	nationality VARCHAR, 
	last_name VARCHAR, 
	first_name VARCHAR, 
	points INTEGER, 
	mahjong INTEGER, 
	ranking INTEGER, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_anon_tournoi_position UNIQUE (tournament_id, position), 
	FOREIGN KEY(tournament_id) REFERENCES tournaments (id)
);

CREATE TABLE championship_tournaments (
	id INTEGER NOT NULL, 
	championship_id INTEGER NOT NULL, 
	tournament_id INTEGER NOT NULL, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_champ_tournoi UNIQUE (championship_id, tournament_id), 
	FOREIGN KEY(championship_id) REFERENCES championships (id), 
	FOREIGN KEY(tournament_id) REFERENCES tournaments (id)
);

CREATE INDEX ix_championnat_tournoi_tournoi ON championship_tournaments (tournament_id);

CREATE TABLE tournament_referees (
	id INTEGER NOT NULL, 
	tournament_id INTEGER NOT NULL, 
	referee_id INTEGER, 
	player_id VARCHAR, 
	name VARCHAR NOT NULL, 
	PRIMARY KEY (id), 
	FOREIGN KEY(tournament_id) REFERENCES tournaments (id), 
	FOREIGN KEY(referee_id) REFERENCES referees (id), 
	FOREIGN KEY(player_id) REFERENCES players (id)
);
