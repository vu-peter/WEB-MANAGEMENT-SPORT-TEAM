DROP DATABASE IF EXISTS SPORTS_MANAGEMENT;
CREATE DATABASE IF NOT EXISTS SPORTS_MANAGEMENT;
DROP USER IF EXISTS 'manager'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE
ON SPORTS_MANAGEMENT.*
TO 'manager'@'localhost' IDENTIFIED BY '123456';
USE SPORTS_MANAGEMENT;

CREATE TABLE USERS
(
  USER_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  PASSWORD_HASH varchar(225) COLLATE utf8_unicode_ci NOT NULL,
  EMAIL varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  TYPE varchar(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'U'
);
INSERT INTO USERS VALUES
  ( 1, 'hash-1', 'user1@mail.com', 'U'),
  ( 2, 'hash-2', 'user2@mail.com', 'U'),
  ( 3, 'hash-3', 'user3@mail.com', 'U'),
  ( 4, 'hash-4', 'user4@mail.com', 'U');


CREATE TABLE MANAGER
(
  MANAGER_ID INT(10) UNSIGNED NOT NULL,
  MTEAM_ID INT(10) UNSIGNED NOT NULL,
  MANAGER_NAME VARCHAR(100),

  PRIMARY KEY (MANAGER_ID,  MTEAM_ID),

  CONSTRAINT FOREIGN KEY (MANAGER_ID) REFERENCES USERS(USER_ID)
);
INSERT INTO MANAGER VALUES
  (1, 20, 'Manager-1'),
  (2, 20, 'Manager-2'),
  (3, 20, 'Manager-3');


CREATE TABLE PROFILE 
(
  PROFILE_ID INT(10) UNSIGNED NOT NULL,
  PUSER_ID INT(10) UNSIGNED NOT NULL,
  FIRST_NAME VARCHAR(100),
  LAST_NAME VARCHAR(150) NOT NULL,
  COUNTRY VARCHAR(250),
  ZIPCODE VARCHAR(100),
  CITY VARCHAR(100),
  STREET VARCHAR(100),
  STATE CHAR(10),

  PRIMARY KEY(PROFILE_ID,PUSER_ID ),
  CONSTRAINT FOREIGN KEY (PROFILE_ID) REFERENCES USERS(USER_ID),
  CHECK (ZIPCODE  REGEXP '(?!0{5})(?!9{5})\\d{5}(-(?!0{4})(?!9{4})\\d{4})?'),
  INDEX (LAST_NAME ),
  UNIQUE (FIRST_NAME , LAST_NAME )
);


CREATE TABLE TEAMS
(
  TEAM_ID INT(10) UNSIGNED NOT NULL PRIMARY KEY,
  TEAM_NAME  VARCHAR(100),
  WIN TINYINT(3) UNSIGNED DEFAULT 0,
  LOSS TINYINT(3) UNSIGNED DEFAULT 0,

  CONSTRAINT FOREIGN KEY (TEAM_ID) REFERENCES MANAGER(MANAGER_ID)
);
INSERT INTO TEAMS VALUES
(1, 'Team-A', 2, 3),
(3, 'Team-C', 7, 1);




CREATE TABLE GAMES
(
  GAME_ID INT(10) UNSIGNED NOT NULL PRIMARY KEY,
  START_DAY VARCHAR(100),
  END_DAY VARCHAR(150) NOT NULL,
  SCORE TINYINT(3) UNSIGNED DEFAULT 0
);
INSERT INTO GAMES VALUES
(100, '20180311', '20180311', 50),
(101, '20180315', '20180316', 53);


CREATE TABLE PLAYER
(
  PLAYER_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  FIRST_NAME VARCHAR(100),
  LAST_NAME VARCHAR(150) NOT NULL,
  COUNTRY VARCHAR(250),
  ZIPCODE VARCHAR(10),
  CITY VARCHAR(100),
  STREET VARCHAR(100),
  STATE CHAR(100),
  PLTEAM_ID INT(10) UNSIGNED NOT NULL,

  PRIMARY KEY (PLAYER_ID, PLTEAM_ID),

  CONSTRAINT FOREIGN KEY (PLTEAM_ID) REFERENCES TEAMS(TEAM_ID),

  CHECK (ZipCode REGEXP '(?!0{5})(?!9{5})\\d{5}(-(?!0{4})(?!9{4})\\d{4})?'),
  INDEX (LAST_NAME ),
  INDEX (FIRST_NAME, LAST_NAME)
);


CREATE TABLE STATS
(
  SPLAYER_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  SGAME_ID INT(10) UNSIGNED NOT NULL,
  PLAYINGTIMEMIN TINYINT(2) UNSIGNED DEFAULT 0,
  PLAYINGTIMESEC TINYINT(2) UNSIGNED DEFAULT 0,
  POINTS TINYINT(3) UNSIGNED DEFAULT 0,
  ASSISTS TINYINT(3) UNSIGNED DEFAULT 0,
  REBOUNDS TINYINT(3) UNSIGNED DEFAULT 0,
  THREE_POINTS TINYINT(3) UNSIGNED DEFAULT 0,
  FTA TINYINT(3) UNSIGNED DEFAULT 0,
  STEAL TINYINT(3) UNSIGNED DEFAULT 0,
  FOUL TINYINT(3) UNSIGNED DEFAULT 0,
  BLOCK TINYINT(3) UNSIGNED DEFAULT 0,
  FTM TINYINT(3) UNSIGNED DEFAULT 0,

  PRIMARY KEY(SPLAYER_ID,SGAME_ID),

  CONSTRAINT FOREIGN KEY (SPLAYER_ID) REFERENCES PLAYER(PLAYER_ID),
  CONSTRAINT FOREIGN KEY (SGAME_ID) REFERENCES GAMES(GAME_ID),

  CHECK((PLAYINGTIMEMIN < 40 AND PLAYINGTIMESEC < 60) OR
        (PLAYINGTIMEMIN = 40 AND PLAYINGTIMESEC = 0 ))
);


CREATE TABLE PLAY
(
  PGAME_ID INT(10) UNSIGNED NOT NULL,
  PTEAM_ID INT(10) UNSIGNED NOT NULL,
  PMANAGER_ID INT(10) UNSIGNED NOT NULL,

  PRIMARY KEY(PGAME_ID,PTEAM_ID,PMANAGER_ID),

  CONSTRAINT FOREIGN KEY (PTEAM_ID) REFERENCES TEAMS(TEAM_ID),
  CONSTRAINT FOREIGN KEY (PGAME_ID) REFERENCES GAMES(GAME_ID),
  CONSTRAINT FOREIGN KEY (PMANAGER_ID) REFERENCES MANAGER(MANAGER_ID)
);
INSERT INTO PLAY VALUES
(100, 1, 1),
(100, 3, 1),
(101, 1, 3),
(101, 3, 3);


CREATE TABLE PARTICIPATE
(
  PPPLAYER INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  PPGAME INT(10) UNSIGNED NOT NULL,

  PRIMARY KEY(PPPLAYER,PPGAME),
  CONSTRAINT FOREIGN KEY (PPPLAYER) REFERENCES PLAYER(PLAYER_ID),
  CONSTRAINT FOREIGN KEY ( PPGAME  ) REFERENCES GAMES(GAME_ID)
);
