/*
 * Database Tables
 */

CREATE TABLE CLAN
(
    idClan      number(3) NOT NULL PRIMARY KEY,
    name        varchar(30) NOT NULL,
    region      varchar(30) NOT NULL,
    strength    number(3) NOT NULL,
    coins       number(3) NOT NULL,
    score       number(3) NOT NULL
);

CREATE TABLE  BATTLE
(
    idBattle    number(3) NOT NULL PRIMARY KEY,
    idClan1     number(3) NOT NULL,
    idClan2     number(3) NOT NULL,
    battleDate  date NOT NULL,
    location    varchar(30) NOT NULL,
    coinsPrize  number(3) NOT NULL,

    CONSTRAINT FK_BATTLE_CLAN1 FOREIGN KEY (idClan1) REFERENCES CLAN (idClan),
    CONSTRAINT FK_BATTLE_CLAN2 FOREIGN KEY (idClan2) REFERENCES CLAN (idClan)
);

CREATE TABLE PLAYER
(
    idPlayer    number(3) NOT NULL PRIMARY KEY,
    idClan      number(3) NOT NULL,
    username    varchar(30) NOT NULL,
    address     varchar(90) NOT NULL,
    city        varchar(30) NOT NULL,
    country     varchar(30) NOT NULL,
    birthdate   date NOT NULL,
    weapon      varchar(30) NOT NULL,
    grade       number(3) NOT NULL,
    strength    number(3) NOT NULL,
    health      number(3) NOT NULL,
    coins       number(3) NOT NULL,
    score       number(3) NOT NULL,

    CONSTRAINT FK_PLAYER_CLAN FOREIGN KEY (idClan) REFERENCES CLAN (idClan)
);

CREATE TABLE PLAYERATTACK
(
    idBattle        number(3) NOT NULL,
    idPlayer1       number(3) NOT NULL,
    idPlayer2       number(3) NOT NULL,
    attackDate      date NOT NULL,
    healthRemoved   number(3) NOT NULL,
    scoreGain       number(3) NOT NULL,

    CONSTRAINT FK_PLAYERATTACK_BATTLE FOREIGN KEY (idBattle) REFERENCES BATTLE (idBattle),
    CONSTRAINT FK_PLAYERATTACK_PLAYER1 FOREIGN KEY (idPlayer1) REFERENCES PLAYER (idPlayer),
    CONSTRAINT FK_PLAYERATTACK_PLAYER2 FOREIGN KEY (idPlayer2) REFERENCES PLAYER (idPlayer)
);

/*
 * Test Questions
 */

-- 1
SELECT name AS 'Clã Adversário', 
location AS 'Local da batalha', 
battleDate AS 'Data da batalha'
FROM BATTLE, PLAYERATTACK, PLAYER ME, PLAYER P, CLAN 
WHERE BATTLE.idBattle = PLAYERATTACK.idBattle
AND ME.username = 'Scar Face'
AND PLAYERATTACK.idPlayer2 = ME.idPlayer
AND PLAYERATTACK.idPlayer1 = P.idPlayer
AND P.region = ME.region
AND BATTLE.date BETWEEN '2019-01-01' AND '2019-12-31'
ORDER BY battleDate DESC;

-- 2
SELECT name AS 'Nome do Clã',
username AS 'Nome do jogador', 
battleDate AS 'Data Ataque em que foi morto'
FROM BATTLE, PLAYERATTACK, PLAYER, CLAN 
WHERE BATTLE.idBattle = PLAYERATTACK.idBattle
AND BATTLE.name = 'South Bay'
AND CLAN.idClan = PLAYER.idClan
AND PLAYER.idPlayer = PLAYERATTACK.idPlayer2
AND PLAYERATTACK.healthRemoved = 100
AND PLAYER.grade = 1;

-- 3
SELECT username AS 'Nome do Jogador'
FROM PLAYER, CLAN, BATTLE, PLAYERATTACK
WHERE PLAYER.idClan = CLAN.idClan
AND CLAN.name = 'The Vikings'
AND PLAYER.idPlayer = PLAYERATTACK.idPlayer2
AND BATTLE.name = 'Joshua Hill'
AND BATTLE.idBattle = PLAYERATTACK.idBattle
AND MIN( healthRemoved );

-- 4
DELETE FROM PLAYERATTACK
WHERE idBattle IN (
    SELECT idBattle FROM BATTLE 
    WHERE location = 'South Bay')
AND (
    idPlayer1 = (
        SELECT idPlayer FROM PLAYER 
        WHERE username = 'LandLord') 
    OR idPlayer2 = (
        SELECT idPlayer FROM PLAYER 
        WHERE username = 'LandLord'));

-- 5
ALTER TABLE BATTLE
ADD CONSTRAINT CK_BATTLE_COINSPRIZE CHECK (coinsPrize > 0),
    CONSTRAINT FK_BATTLE_CLAN1 FOREIGN KEY (idClan1) REFERENCES CLAN (idClan),
    CONSTRAINT FK_BATTLE_CLAN2 FOREIGN KEY (idClan2) REFERENCES CLAN (idClan),
    CONSTRAINT PK_BATTLE_idBattle PRIMARY KEY (idBattle);