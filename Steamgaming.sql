
-- 5
-- Autumn 2024

-- Sonukumari Rathore
-- sonukumari.Rathore@student.uts.edu.au
-- 25208188

-- Data inspired by (https://store.steampowered.com/)
-- SteamGaming Database
--
-- This database is designed to store information related to an online game
-- store called SteamGaming. It includes tables for storing user data, game
-- details, developer information, shopping carts, wishlists, purchases,
-- reviews, and game screenshots.
--
-- The database is structured to support various operations such as user
-- account management, browsing and purchasing games, adding games to
-- wishlists and shopping carts, leaving reviews and ratings, and managing
-- game and developer information.
--
-- Tables:
--
-- Users: Stores user account information such as username, email, password,
--        account balance, and personal details.
--
-- Shopping_Cart: Tracks items added to users' shopping carts and their quantities.
--
-- Games: Contains details about games available on the platform, such as
--         game name, description, genre, release date and developers.
--
-- Developers: Stores information about game developers, including their
--             name, description, and headquarters location.
--
-- Game_Screenshots: Stores URLs of screenshots for each game.
--
-- Wishlist: Tracks games added to users' wishlists.
--
-- Game_Purchases: Records game purchases made by users and their prices.
--
-- Game_Review: Stores user reviews and ratings for games.


DROP VIEW CounterStrikeUsers CASCADE;
DROP VIEW gameRatings CASCADE;

DROP TABLE Users CASCADE;
DROP TABLE Shopping_Cart CASCADE;
DROP TABLE Game_Screenshots CASCADE;
DROP TABLE Game_Purchases CASCADE;
DROP TABLE Game_Review CASCADE;
DROP TABLE Games CASCADE;
DROP TABLE Developers CASCADE;
DROP TABLE Wishlist CASCADE;




--Table creation




Create table Developers
(
	developerID      INTEGER NOT NULL,
    developerName    VARCHAR (255) NOT NULL,
    developerDescription       VARCHAR (255),
    headquartersLocation     VARCHAR (255),
    
	CONSTRAINT Developers_ProjectPK PRIMARY KEY (developerID)
    
    
);




Create table Games
(
	gameID      INTEGER NOT NULL,
    gameName    VARCHAR (255) NOT NULL,
	gameDescription     VARCHAR (255),
    gameGenre       VARCHAR (255),
    releaseDate     DATE NOT NULL,
    developerID     INTEGER NOT NULL,
    
	CONSTRAINT Games_ProjectPK PRIMARY KEY (gameID),
    CONSTRAINT Games_developerIDFK FOREIGN KEY (developerID) 
        REFERENCES Developers
        ON DELETE CASCADE
        ON UPDATE CASCADE
    
);




Create table Users
(
	userID      INTEGER NOT NULL,
	userName    VARCHAR (255) NOT NULL,
    email       VARCHAR (255) NOT NULL,
    password    VARCHAR (255) NOT NULL,
    accountBalance      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    firstName       VARCHAR (255) NOT NULL,
    lastName        VARCHAR (255),
    country         VARCHAR (255),
    birthDate       DATE,
    refferedUserId INTEGER,
    

	CONSTRAINT USERS_ProjectPK PRIMARY KEY (userID),
    CONSTRAINT USERS_PasswordLENGTH CHECK (CHAR_LENGTH(password) >= 8),
    CONSTRAINT SP_Username UNIQUE (userName),
    CONSTRAINT SP_Email UNIQUE (email),
    CONSTRAINT CHK_UserIdNotReferredUserId CHECK (userID <> refferedUserId)

);




Create table Shopping_Cart
(
	shoppingCartID      INTEGER NOT NULL,
    userID      INTEGER NOT NULL,
	gameID      INTEGER NOT NULL,
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    
	CONSTRAINT Shopping_Cart_ProjectPK PRIMARY KEY (shoppingCartID),
    CONSTRAINT Shopping_Cart_UsersFK FOREIGN KEY (userID) 
        REFERENCES Users
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Shopping_Cart_GamesFK FOREIGN KEY (gameID) 
        REFERENCES Games
        ON DELETE RESTRICT
        ON UPDATE RESTRICT

    
);




Create table Game_Screenshots
(
	screenshotID      INTEGER NOT NULL,
    gameID      INTEGER NOT NULL,
    screenshotURL      VARCHAR (255),
    
	CONSTRAINT Game_Screenshots_ProjectPK PRIMARY KEY (screenshotID),
    CONSTRAINT Game_Screenshots_gameIDFK FOREIGN KEY (gameID) 
        REFERENCES Games 
        ON DELETE CASCADE
        ON UPDATE CASCADE
    
);




Create table Wishlist
(
	wishlistID      INTEGER NOT NULL,
    userID      INTEGER NOT NULL,
    gameID      INTEGER NOT NULL,
    addedDate       DATE NOT NULL,
    
	CONSTRAINT Wishlist_ProjectPK PRIMARY KEY (wishlistID),
    CONSTRAINT Wishlist_userIDFK FOREIGN KEY (userID) 
        REFERENCES Users
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Wishlist_gameIDFK FOREIGN KEY (gameID) 
        REFERENCES Games
        ON DELETE RESTRICT
        ON UPDATE RESTRICT

);




Create table Game_Purchases
(
	purchaseID      INTEGER NOT NULL,
    gameID      INTEGER NOT NULL,
    userID      INTEGER NOT NULL,
    purchaseDate     DATE NOT NULL,
    purchasePrice       DECIMAL(9,2),
    
	CONSTRAINT Game_Purchases_ProjectPK PRIMARY KEY (purchaseID),
    CONSTRAINT Game_Purchases_userIDFK FOREIGN KEY (userID) 
        REFERENCES Users
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT Game_Purchases_gameIDFK FOREIGN KEY (gameID) 
        REFERENCES Games 
        ON DELETE CASCADE
        ON UPDATE CASCADE

);




Create table Game_Review
(
	gameReviewID      INTEGER NOT NULL,
    gameID      INTEGER NOT NULL,
    userID      INTEGER NOT NULL,
    rating      INTEGER,
    review      VARCHAR (255),
    reviewDate      DATE,
    
	CONSTRAINT Game_Review_ProjectPK PRIMARY KEY (gameReviewID),
    CONSTRAINT Game_Review_userIDFK FOREIGN KEY (userID) 
        REFERENCES Users
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Game_Review_gameIDFK FOREIGN KEY (gameID) 
        REFERENCES Games 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Game_Review_rating CHECK (rating >= 0 AND rating <= 5)

);


CREATE VIEW CounterStrikeUsers AS
    SELECT DISTINCT u.userName
    FROM Users u
    JOIN Game_Purchases gp ON u.userID = gp.userID
    JOIN Games g ON gp.gameID = g.gameID
    JOIN Developers d ON g.developerID = d.developerID
    WHERE g.gameName = 'Counter strike';


CREATE VIEW gameRatings AS
    SELECT g.gameName, 
           ROUND(AVG(gr.rating), 1) AS average_rating
    FROM Games g
    LEFT JOIN Game_Review gr ON g.gameID = gr.gameID
    GROUP BY g.gameName;




INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (1, 'Rockstar Games', 'Rockstar Games is an American video game publisher and developer responsible for the Grand Theft Auto series, headquartered in New York City.','America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (2, 'Ubisoft', 'Ubisoft is a French video game company known for franchises like Assassins Creed, with a major studio in Montreal.','France');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (3, 'Square Enix', 'Square Enix is a Japanese video game company known for popular franchises like Final Fantasy, Dragon Quest, and Kingdom Hearts.','Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (4, 'Gameloft', 'Gameloft is a French video game company that develops and publishes mobile games across a variety of genres.','France');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (5, 'Tencent', 'Tencent is a Chinese multinational conglomerate that specializes in internet-related services and products, including one of the largest video game companies in the world.','China');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (6, 'Electronic Arts', 'Electronic Arts (EA) is a major American video game company responsible for popular game franchises such as Madden NFL, FIFA, Battlefield, The Sims, and more.','America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (7, 'Activision Blizzard', 'Activision Blizzard is a leading American video game company known for popular franchises like Call of Duty, World of Warcraft, Overwatch, and more.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (8, 'Bandai Namco Entertainment', 'Bandai Namco Entertainment is a Japanese video game company known for franchises like Tekken, Soulcalibur, Pac-Man, and Dark Souls.', 'Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (9, 'CD Projekt Red', 'CD Projekt Red is a Polish video game developer and publisher best known for the critically acclaimed The Witcher series and Cyberpunk 2077.', 'Poland');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (10, 'Bethesda Softworks', 'Bethesda Softworks is an American video game publisher and developer known for popular franchises like The Elder Scrolls, Fallout, and Dishonored.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (11, 'Capcom', 'Capcom is a leading Japanese video game developer and publisher known for franchises like Street Fighter, Resident Evil, Monster Hunter, and Devil May Cry.', 'Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (12, 'Konami', 'Konami is a Japanese entertainment company that has been a prominent developer and publisher of video games, known for franchises like Metal Gear, Silent Hill, and Castlevania.', 'Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (13, 'Nintendo', 'Nintendo is a Japanese multinational corporation and one of the world''s largest video game companies, known for iconic franchises like Mario, The Legend of Zelda, and Pokémon.', 'Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (14, 'Sega', 'Sega is a Japanese multinational video game developer and publisher, known for franchises like Sonic the Hedgehog, Yakuza, and Total War.', 'Japan');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (15, 'Valve Corporation', 'Valve Corporation is an American video game developer and digital distribution company, known for games like Half-Life, Counter-Strike, and the Steam platform.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (16, 'Epic Games', 'Epic Games is an American video game and software developer and publisher, known for creating the Unreal Engine and games like Fortnite and Gears of War.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (17, 'Naughty Dog', 'Naughty Dog is an American video game developer owned by Sony Interactive Entertainment, known for acclaimed franchises like Uncharted and The Last of Us.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (18, 'Bungie', 'Bungie is an American video game developer best known for creating the Halo and Destiny franchises.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (19, 'Obsidian Entertainment', 'Obsidian Entertainment is an American video game developer known for role-playing games like Fallout: New Vegas, The Outer Worlds, and Pillars of Eternity.', 'America');
INSERT INTO Developers (developerID, developerName, developerDescription, headquartersLocation) VALUES (20, 'Paradox Interactive', 'Paradox Interactive is a Swedish video game publisher and developer known for strategy games like Europa Universalis, Crusader Kings, and Cities: Skylines.', 'Sweden');




INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (1, 'Counter strike', 'For more than two decades, Counter-Strike has provided an exceptional competitive experience shaped by millions of players from around the world.', 'Action', '2013-08-12', 4);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (2, 'Palworld - Mystery', 'Fight, farm, create, and collaborate with mysterious creatures known as "Pals" in this all-new multiplayer, open-world survival and crafting game!', 'Action', '2010-05-01', 2);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (3, 'Witcher', 'You are Geralt of Rivia, the mercenary monster slayer. Before you is a war-torn, monster-infested continent that you can freely explore.', 'Action', '2009-04-04', 3);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (4, 'Grand Theft Auto V', 'Grand Theft Auto V for PC allows players to explore the award-winning world of Los Santos and Blaine County in resolutions of up to 4k and beyond, as well as play the game at 60 frames per second.', 'Action', '2019-02-11', 1);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (5, 'Far Cry', 'Enter the fast-paced world of a modern-day guerilla movement. With stunning environments, visceral gunplay, and a wide range of gameplay experiences, theres never been a better time to join the war.', 'Action', '2015-10-19', 6);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (6, 'Assassins Creed Valhalla', 'Become a legendary Viking on his quest for greatness. Raid your opponents, expand your settlement, and gain political power.', 'Action', '2005-03-27', 2);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (7, 'Cyberpunk 2077', 'Cyberpunk 2077 is an open-world action-adventure RPG set in the dark future of Night City, a violent megalopolis obsessed with power, glamour, and constant bodily modification.', 'Action', '2020-12-09', 4);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (8, 'Diablo IV', 'Join the struggle for Sanctuary in Diablo IV, the ultimate action-RPG experience. Enjoy the critically acclaimed campaign and fresh seasonal content.', 'Action', '1998-05-09', 5);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (9, 'The Last of Us Part I', 'The Last of Us, which won over 200 Game of the Year awards, features emotive storytelling and fascinating characters.', 'Action', '2006-08-23', 1);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (10, 'Red Dead Redemption 2', 'RDR2, winner of over 175 Game of the Year Awards and over 250 flawless scores, tells the epic story of outlaw Arthur Morgan and the infamous Van der Linde gang, who are on the run throughout America during the dawn of the modern era.', 'Action', '2017-12-11', 3);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (11, 'Elden Ring', 'Rise, Tarnished, and be guided by grace to brandish the power of the Elden Ring and become an Elden Lord in the Lands Between.', 'Action RPG', '2022-02-25', 11);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (12, 'Apex Legends', 'Conquer with character in Apex Legends, a free-to-play battle royale game where legendary characters battle for glory, fame, and fortune on the fringes of the Frontier.', 'Battle Royale', '2019-02-04', 6);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (13, 'Dota 2', 'Every day, millions of players worldwide enter the battle as one of over 100 Dota heroes in a 5v5 team clash. Dota is the deepest multi-player action RTS game ever created.', 'MOBA', '2013-07-09', 15);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (14, 'Stray', 'Stray is a third-person cat adventure game set amidst the detailed neon-lit alleys of a decaying cybercity and the murky environments of its seedy underbelly.', 'Adventure', '2022-07-19', 4);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (15, 'Hogwarts Legacy', 'Experience a new story set at Hogwarts in the 1800s. Your character is a student who holds the key to an ancient secret that threatens to tear the wizarding world apart.', 'Action RPG', '2023-02-10', 6);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (16, 'Call of Duty: Modern Warfare II', 'Call of Duty: Modern Warfare II is the sequel to 2019''s blockbuster Modern Warfare. Featuring the return of the iconic, team-based gameplay, and a world-renowned multiplayer experience.', 'First-Person Shooter', '2022-10-28', 7);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (17, 'Valorant', 'Valorant is a free-to-play multiplayer tactical shooter game developed by Riot Games. In Valorant, two teams of five players compete to plant or defuse a bomb on a map.', 'Tactical Shooter', '2020-06-02', 13);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (18, 'Minecraft', 'Minecraft is a game about placing blocks and going on adventures. Explore randomly generated worlds and build amazing things from the simplest of homes to the grandest of castles.', 'Sandbox', '2011-11-18', 15);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (19, 'Rocket League', 'A futuristic sports-action game where players pilot rocket-powered vehicles to score goals on an intense pitch. Combine soccer and driving for a unique gaming experience!', 'Sports', '2015-07-07', 16);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (20, 'Total War: Warhammer III', 'The final part of the quintessential Total War: Warhammer trilogy combines an epic narrative campaign with a vast, living fantasy world brimming with magic and endless replayability.', 'Strategy', '2022-02-17', 20);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (21, 'Terraria', 'Dig, fight, explore, build! Nothing is inevitable in the world of Terraria. Explore vast worlds and battle against bosses with hundreds of weapons and armor types.', 'Sandbox', '2011-05-16', 9);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (22, 'Phasmophobia', 'Phasmophobia is a 4-player online co-op psychological horror game where you and your team members are tasked with locating and identifying a ghost.', 'Horror', '2020-09-18', 17);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (23, 'Hades', 'Defy the god of death as you hack and slash your way out of the Underworld in this rogue-like dungeon crawler from the creators of Bastion and Transistor.', 'Roguelike', '2020-09-17', 18);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (24, 'Factorio', 'Factorio is a game about building and managing factories to produce resources and automate production lines. Craft increasingly complex machines and structures to solve puzzles.', 'Simulation', '2020-08-14', 19);
INSERT INTO Games (gameID, gameName, gameDescription, gameGenre, releaseDate, developerID) VALUES (25, 'Civilization VI', 'Civilization VI is a turn-based strategy game in which you attempt to build an empire to stand the test of time. Become the leader of a civilization and guide it through the ages.', 'Strategy', '2016-10-21', 6);




INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (1, 'Raja', 'raja@gmail.com', 'password123', 100.00,'Raja','Sharma','America', '1997-12-10', 4);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (2, 'Pooja', 'pooja@outlook.com', 'poojatiwari123', 1.00,'Pooja','Kapoor','India', '2004-09-07', 7);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (3, 'Anirudh', 'anirudh@gmail.com', 'piyushbansal123', 1000.00,'Anirudh','Chopra','London', '2001-09-05', 2);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (4, 'Neha', 'neha@yahoo.com', 'sonurathore123', 2000.00,'Neha','Verma','Australia', '2001-10-10', 7);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (5, 'Nisha', 'nisha@gmail.com', 'krithika123', 200.00,'Nisha','Agarwal','India', '2002-01-14', 6);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (6, 'Rahul', 'Rahul@yahoo.com', 'sanju123', 5000.00,'Rahul','Malhotra','UK', '1997-10-19', 30);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (7, 'Amit', 'amit@outlook.com', 'sanjaysingh123', 1000000.00,'Amit','Sharma','USA', '1995-01-05', 24);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (8, 'Raman', 'raman@example.com', 'lucas123', 500.00, 'Raman', 'Gupta', 'Mexico', '1990-06-15', 27);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (9, 'Raj', 'raj@example.com', 'sophia456', 250.00, 'Raj', 'Patel', 'Spain', '1985-11-20', 11);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (10, 'Aadhav', 'aadhav@example.com', 'johndoe123', 750.00, 'Aadhav', 'Reddy', 'Canada', '1992-03-01', 19);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (11, 'Priya', 'priya@example.com', 'emily789', 1000.00, 'Priya', 'Chaudhary', 'China', '1998-09-12', 17);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (12, 'Kiran', 'kiran@example.com', 'david101', 100.00, 'Kiran', 'Mehta', 'Argentina', '1980-05-25', 28);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (13, 'Isha', 'isha@example.com', 'lisa1123', 300.00, 'Isha', 'Acharya', 'Ireland', '1995-07-08', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (14, 'Arjun', 'arjun@example.com', 'michael123', 800.00, 'Arjun', 'Bhatia', 'South Korea', '1988-12-03', 4);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (15, 'Riya', 'riya@example.com', 'sarah456', 400.00, 'Riya', 'Chopra', 'Singapore', '1993-04-22', 8);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (16, 'Nikhil', 'nikhil@example.com', 'james789', 600.00, 'Nikhil', 'Gupta', 'China', '1987-09-30', 15);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (17, 'Faizan', 'faizan@example.com', 'olivia101', 150.00, 'Faizan', 'Khan', 'Mexico', '1991-02-14', 12);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (18, 'Ananya', 'ananya@example.com', 'alexander112', 900.00, 'Ananya', 'Sharma', 'Vietnam', '1990-08-18', 21);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (19, 'Sneha', 'sneha@example.com', 'emma1234', 200.00, 'Sneha', 'Agarwal', 'United Kingdom', '1996-11-27', 22);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (20, 'Pinky', 'pinky@example.com', 'jacob456', 700.00, 'Pinky', 'Chopra', 'China', '1994-05-09', 30);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (21, 'Sanjay', 'sanjay@example.com', 'isabelle789', 350.00, 'Sanjay', 'Patel', 'Spain', '1989-03-21', 23);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (22, 'Krishna', 'krishna@example.com', 'luke1012', 450.00, 'Krishna', 'Sharma', 'South Korea', '1992-06-02', 25);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (23, 'Nitin', 'nitin@example.com', 'emily112', 550.00, 'Nitin', 'Agarwal', 'United States', '1997-08-29',27);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (24, 'Aryaman', 'aryaman@example.com', 'ryan1234', 650.00, 'Aryaman', 'Chopra', 'Singapore', '1991-12-14', 5);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (25, 'Suzanna', 'suzanna@example.com', 'julia456', 250.00, 'Suzanna', 'Malhotra', 'United Kingdom', '1993-04-05', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (26, 'Akshat', 'akshat@example.com', 'daniel789', 750.00, 'Akshat', 'Gupta', 'Mexico', '1988-09-23', 2);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (27, 'Simran', 'Simran@example.com', 'sarah101', 450.00, 'Simran', 'Sharma', 'China', '1995-06-18', 3);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (28, 'Preeti', 'preeti@example.com', 'matthew112', 550.00, 'Preeti', 'Chopra', 'South Korea', '1990-11-07', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (29, 'Sahil', 'sahil@example.com', 'ava123456', 350.00, 'Sahil', 'Patel', 'Spain', '1992-03-15', 9);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (30, 'Mahir', 'mahir@yahoo.com', 'jackson456', 650.00, 'Mahir', 'Gupta', 'China', '1994-08-02', 16);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (31, 'Shreya', 'shreya@example.com', 'oliver123', 300.00, 'Shreya', 'Singh', 'India', '1998-07-20', 7);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (32, 'Aarav', 'aarav@example.com', 'harry456', 400.00, 'Aarav', 'Sharma', 'Canada', '1995-02-15', 12);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (33, 'Tanvi', 'tanvi@example.com', 'charlie789', 500.00, 'Tanvi', 'Patel', 'USA', '1992-11-10', 8);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (34, 'Yash', 'yash@example.com', 'thomas101', 600.00, 'Yash', 'Verma', 'Australia', '1990-06-25', 16);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (35, 'Aanya', 'aanya@example.com', 'samuel112', 700.00, 'Aanya', 'Malhotra', 'UK', '1994-03-12', 22);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (36, 'Vihaan', 'vihaan@example.com', 'daniel123', 800.00, 'Vihaan', 'Gupta', 'Spain', '1988-12-28', 25);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (37, 'Ishita', 'ishita@example.com', 'jack4567', 900.00, 'Ishita', 'Sharma', 'South Korea', '1993-09-05', 3);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (38, 'Arnav', 'arnav@example.com', 'noah7899', 1000.00, 'Arnav', 'Kumar', 'Mexico', '1991-04-18', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (39, 'Aashi', 'aashi@example.com', 'ethan101', 1100.00, 'Aashi', 'Chopra', 'Singapore', '1989-01-01', 5);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (40, 'Viha', 'viha@example.com', 'logan112', 1200.00, 'Viha', 'Sinha', 'China', '1986-08-14', 30);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (41, 'Aarush', 'aarush@example.com', 'joseph123', 1300.00, 'Aarush', 'Singh', 'India', '1997-05-27', 7);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (42, 'Anika', 'anika@example.com', 'noah4567', 1400.00, 'Anika', 'Kaur', 'Canada', '1994-02-10', 12);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (43, 'Advik', 'advik@example.com', 'william789', 1500.00, 'Advik', 'Shah', 'USA', '1991-09-23', 8);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (44, 'Saisha', 'saisha@example.com', 'mason101', 1600.00, 'Saisha', 'Jain', 'Australia', '1990-04-06', 16);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (45, 'Shaurya', 'shaurya@example.com', 'alexander112', 1700.00, 'Shaurya', 'Nair', 'UK', '1993-11-19', 22);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (46, 'Aadhya', 'aadhya@example.com', 'jayden123', 1800.00, 'Aadhya', 'Gupta', 'Spain', '1988-06-02', 25);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (47, 'Atharv', 'atharv@example.com', 'daniel456', 1900.00, 'Atharv', 'Yadav', 'South Korea', '1993-01-15', 3);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (48, 'Anvi', 'anvi@example.com', 'logan789', 2000.00, 'Anvi', 'Iyer', 'Mexico', '1991-08-28', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (49, 'Rudra', 'rudra@example.com', 'william101', 2100.00, 'Rudra', 'Rao', 'Singapore', '1989-03-12', 5);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (50, 'Myra', 'myra@example.com', 'joseph112', 2200.00, 'Myra', 'Vyas', 'China', '1986-10-25', 30);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (51, 'Advait', 'advait@example.com', 'oliver123', 2300.00, 'Advait', 'Gandhi', 'India', '1998-07-20', 7);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (52, 'Aaradhya', 'aaradhya@example.com', 'harry456', 2400.00, 'Aaradhya', 'Rathore', 'Canada', '1995-02-15', 12);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (53, 'Vivaan', 'vivaan@example.com', 'charlie789', 2500.00, 'Vivaan', 'Mehra', 'USA', '1992-11-10', 8);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (54, 'Ravan', 'ravan2@example.com', 'thomas101', 2600.00, 'Ravan', 'Kumar', 'Australia', '1990-06-25', 16);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (55, 'Amal', 'amal2@example.com', 'samuel112', 2700.00, 'Amal', 'Rajput', 'UK', '1994-03-12', 22);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (56, 'Ahmad', 'ahmad2@example.com', 'daniel123', 2800.00, 'Ahmad', 'Singh', 'Spain', '1988-12-28', 25);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (57, 'Ezar', 'ezar2@example.com', 'jack4567', 2900.00, 'Ezar', 'Mukherjee', 'South Korea', '1993-09-05', 3);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (58, 'Reggie', 'raggie2@example.com', 'noah7899', 3000.00, 'Reggie', 'Rastogi', 'Mexico', '1991-04-18', 1);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (59, 'She', 'she2@example.com', 'she111101', 3100.00, 'She', 'Tiwari', 'Singapore', '1989-01-01', 5);
INSERT INTO Users (userId, userName, email, password, accountBalance, firstName, lastName, country, birthDate, refferedUserId) VALUES (60, 'Atlas', 'atlas2@example.com', 'logan112', 3200.00, 'Atlas', 'Chauhan', 'China', '1986-08-14', 30);




INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (1, 1, 1, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (2, 2, 2, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (3, 4, 4, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (4, 6, 6, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (5, 21, 8, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (6, 30, 10, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (7, 24, 3, 5);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (8, 14, 5, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (9, 15, 7, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (10, 20, 9, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (11, 13, 2, 6);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (12, 9, 4, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (13, 7, 6, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (14, 5, 8, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (15, 8, 10, 5);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (16, 10, 5, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (17, 11, 3, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (18, 18, 7, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (19, 17, 9, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (20, 19, 10, 6);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (21, 22, 13, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (22, 23, 15, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (23, 24, 19, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (24, 25, 20, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (25, 26, 18, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (26, 27, 17, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (27, 28, 12, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (28, 29, 11, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (29, 30, 10, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (30, 21, 9, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (31, 22, 8, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (32, 23, 7, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (33, 24, 6, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (34, 25, 5, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (35, 26, 4, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (36, 27, 3, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (37, 28, 2, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (38, 29, 1, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (39, 30, 20, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (40, 21, 19, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (41, 22, 18, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (42, 23, 17, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (43, 24, 16, 4);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (44, 25, 15, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (45, 26, 14, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (46, 27, 13, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (47, 28, 12, 2);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (48, 29, 11, 3);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (49, 30, 10, 1);
INSERT INTO Shopping_Cart (shoppingCartID, userID, gameID, quantity) VALUES (50, 21, 9, 4);




INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (1, 2, 1, '2009-10-10');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (2, 4, 3, '2010-10-01');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (3, 6, 5, '2011-10-02');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (4, 8, 7, '2012-10-03');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (5, 10, 9, '2013-10-04');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (6, 12, 2, '2014-10-05');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (7, 14, 4, '2015-10-06');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (8, 16, 6, '2016-10-07');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (9, 18, 8, '2017-10-08');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (10, 20, 10, '2018-10-09');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (11, 22, 9, '2019-10-11');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (12, 24, 7, '2020-10-12');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (13, 26, 5, '2021-10-13');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (14, 28, 3, '2022-10-14');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (15, 30, 1, '2023-10-15');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (16, 27, 10, '2009-10-16');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (17, 25, 8, '2014-10-17');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (18, 23, 6, '2012-10-18');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (19, 21, 4, '2011-10-19');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (20, 19, 2, '2022-10-20');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (21, 17, 20, '2015-10-21');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (22, 15, 18, '2016-10-22');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (23, 13, 16, '2017-10-23');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (24, 11, 14, '2018-10-24');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (25, 9, 12, '2019-10-25');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (26, 7, 10, '2020-10-26');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (27, 5, 8, '2021-10-27');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (28, 3, 6, '2022-10-28');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (29, 1, 4, '2023-10-29');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (30, 28, 20, '2024-10-30');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (31, 26, 18, '2014-10-31');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (32, 24, 16, '2012-11-01');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (33, 22, 14, '2010-11-02');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (34, 20, 12, '2008-11-03');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (35, 18, 10, '2006-11-04');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (36, 16, 8, '2004-11-05');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (37, 14, 6, '2002-11-06');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (38, 12, 4, '2000-11-07');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (39, 10, 2, '1998-11-08');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (40, 8, 1, '1996-11-09');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (41, 6, 3, '2013-11-10');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (42, 4, 5, '2011-11-11');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (43, 2, 7, '2009-11-12');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (44, 30, 9, '2007-11-13');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (45, 29, 11, '2005-11-14');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (46, 28, 13, '2003-11-15');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (47, 27, 15, '2001-11-16');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (48, 26, 17, '2014-11-17');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (49, 25, 19, '2016-11-18');
INSERT INTO Wishlist (wishlistID, userID, gameID, addedDate) VALUES (50, 24, 20, '2018-11-19');




INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(1, 2, 1, '2010-03-20', 49.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(2, 4, 11, '2020-03-20', 50.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(3, 3, 21, '2011-03-20', 12.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(4, 6, 30, '2012-03-20', 10.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(5, 5, 20, '2013-03-20', 55.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(6, 8, 10, '2014-03-20', 67.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(7, 7, 5, '2015-03-20', 34.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(8, 10, 15, '2016-03-20', 24.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(9, 9, 25, '2017-03-20', 54.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(10, 3, 2, '2008-03-20', 32.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(11, 2, 12, '2009-03-20', 20.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(12, 1, 22, '2018-03-20', 22.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(13, 5, 8, '2019-03-20', 42.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(14, 8, 18, '2020-03-20', 43.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(15, 7, 28, '2021-03-20', 48.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(16, 6, 4, '2022-03-20', 36.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(17, 9, 14, '2023-03-20', 39.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(18, 11, 24, '2024-03-20', 49.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(19, 13, 3, '2025-03-20', 29.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(20, 15, 13, '2026-03-20', 19.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(21, 17, 23, '2027-03-20', 59.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(22, 19, 7, '2028-03-20', 49.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(23, 20, 17, '2029-03-20', 44.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(24, 1, 27, '2030-03-20', 37.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(25, 3, 19, '2031-03-20', 25.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(26, 5, 9, '2032-03-20', 33.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(27, 7, 29, '2033-03-20', 38.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(28, 9, 2, '2034-03-20', 47.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(29, 11, 12, '2035-03-20', 53.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(30, 13, 22, '2036-03-20', 19.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(31, 15, 8, '2037-03-20', 29.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(32, 17, 18, '2038-03-20', 45.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(33, 19, 28, '2039-03-20', 50.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(34, 20, 4, '2040-03-20', 40.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(35, 2, 14, '2041-03-20', 32.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(36, 4, 24, '2042-03-20', 27.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(37, 6, 3, '2043-03-20', 37.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(38, 8, 13, '2044-03-20', 42.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(39, 10, 23, '2045-03-20', 48.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(40, 12, 7, '2046-03-20', 55.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(41, 14, 17, '2047-03-20', 59.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(42, 16, 27, '2048-03-20', 39.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(43, 18, 19, '2049-03-20', 47.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(44, 1, 9, '2050-03-20', 50.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(45, 3, 29, '2051-03-20', 32.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(46, 5, 14, '2052-03-20', 22.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(47, 7, 24, '2053-03-20', 36.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(48, 9, 4, '2054-03-20', 40.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(49, 11, 13, '2055-03-20', 46.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(50, 13, 23, '2056-03-20', 52.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(51, 15, 3, '2057-03-20', 57.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(52, 17, 13, '2058-03-20', 62.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(53, 19, 23, '2059-03-20', 66.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(54, 20, 4, '2060-03-20', 70.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(55, 2, 14, '2061-03-20', 34.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(56, 4, 24, '2062-03-20', 37.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(57, 6, 4, '2063-03-20', 40.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(58, 8, 14, '2064-03-20', 44.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(59, 10, 24, '2065-03-20', 48.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(60, 12, 5, '2066-03-20', 51.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(61, 14, 15, '2067-03-20', 54.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(62, 16, 25, '2068-03-20', 58.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(63, 18, 8, '2069-03-20', 61.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(64, 1, 18, '2070-03-20', 64.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(65, 3, 28, '2071-03-20', 67.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(66, 5, 9, '2072-03-20', 70.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(67, 7, 19, '2073-03-20', 72.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(68, 9, 29, '2074-03-20', 76.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(69, 11, 11, '2075-03-20', 80.99);
INSERT INTO Game_Purchases (purchaseID, gameID, userID, purchaseDate, purchasePrice) VALUES(70, 13, 21, '2076-03-20', 84.99);




INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(1, 1, 1, 5, 'Great game', '2021-02-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(2, 2, 4, 5, 'Excellent game', '2022-03-24');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(3, 3, 3, 1, 'Poor game', '2023-04-26');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(4, 5, 2, 1, 'Not up to the mark', '2022-03-15');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(5, 6, 5, 5, 'Good game', '2009-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(6, 7, 7, 5, 'Awesome game', '2008-01-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(7, 8, 9, 3, 'Can be better', '2019-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(8, 9, 10, 5, 'Loved lucas character', '2018-02-20');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(9, 10,12, 5, 'Best graphics', '2020-03-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(10, 1, 13, 3, 'Please, add more levels', '2022-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(11, 2, 21, 2, 'Settings not working', '2012-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(12, 3, 2, 1, 'High scope of improvement', '2011-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(13, 4, 13, 3, 'Please, provide new skins', '2010-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(14, 5, 18, 3, 'Too many ads', '2015-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(15, 6, 20, 2, 'Not working in my apple mobile', '2014-03-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(16, 7, 25, 2, 'Xbox connectivity issue', '2013-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(17, 8, 30, 5, 'Best game ever', '2022-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(18, 9, 22, 3, 'Please provide updates for lower end graphics', '2016-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(19, 10, 11, 5, 'Live streaming is good', '2022-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(20, 1, 10, 0, 'Disppoting game', '2017-03-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(21, 2, 14, 0, 'Unfinished game', '2018-03-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(22, 3, 16, 5, 'Masterpiece game', '2020-03-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(23, 4, 18, 1, 'Avoid the game', '2024-01-25');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(24, 5, 24, 1, 'Poor server game', '2009-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(25, 6, 18, 4, 'Really nice game', '2008-03-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(26, 7, 20, 3, 'All well except the momements of the game', '2021-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(27, 8, 3, 5, 'Loved the game', '2022-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(28, 9, 1, 5, 'Gem of a game', '2023-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(29, 10, 6, 5, 'Good experience', '2009-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(30, 1, 9, 5, 'Most realistic', '2008-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(31, 2, 4, 3, 'Games is crashing after the latest updates', '2007-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(32, 3, 22, 2, 'Please improve the terrain level', '2015-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(33, 4, 29, 5, 'Outstanding', '2016-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(34, 5, 27, 5, 'Loved it', '2017-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(35, 6, 5, 5, 'I have been a loyal fan of this game since forever', '2018-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(36, 7, 30, 5, 'Could not ask for more', '2019-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(37, 8, 24, 3, 'Ping level is very high', '2020-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(38, 9, 23, 3, 'Game is too costly', '2021-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(39, 10, 21, 5, 'This game deserves a shoutout', '2022-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(40, 1, 19, 5, 'Definitely gonna recommend to other', '2020-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(41, 2, 17, 4, 'Interesting storyline', '2019-03-03');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(42, 3, 15, 3, 'Needs more character development', '2018-02-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(43, 4, 13, 2, 'Too many bugs', '2017-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(44, 5, 11, 4, 'Great graphics, but lacking in gameplay', '2016-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(45, 6, 9, 3, 'Controls are a bit clunky', '2015-11-11');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(46, 7, 7, 4, 'Enjoyable multiplayer experience', '2014-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(47, 8, 5, 2, 'Disappointed with the ending', '2013-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(48, 9, 3, 5, 'One of the best games I''ve played', '2012-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(49, 10, 1, 3, 'Too repetitive', '2011-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(50, 1, 2, 4, 'Good value for money', '2010-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(51, 2, 4, 5, 'Addictive gameplay', '2009-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(52, 3, 6, 3, 'Could use more variety in quests', '2008-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(53, 4, 8, 4, 'Impressive graphics', '2007-03-03');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(54, 5, 10, 2, 'Unbalanced difficulty curve', '2006-02-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(55, 6, 12, 5, 'A classic', '2005-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(56, 7, 14, 3, 'Not as good as the hype', '2004-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(57, 8, 16, 4, 'Solid gameplay mechanics', '2003-11-11');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(58, 9, 18, 2, 'Feels incomplete', '2002-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(59, 10, 20, 5, 'Hours of fun', '2001-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(60, 1, 22, 4, 'Great replay value', '2000-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(61, 2, 24, 3, 'Mediocre at best', '1999-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(62, 3, 26, 5, 'Worth every penny', '1998-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(63, 4, 28, 2, 'Overrated', '1997-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(64, 5, 30, 4, 'Keeps you coming back for more', '1996-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(65, 6, 1, 3, 'Needs better optimization', '1995-03-03');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(66, 7, 3, 5, 'Must-play for any gamer', '1994-02-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(67, 8, 5, 2, 'Could have been better', '1993-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(68, 9, 7, 4, 'Solid entry in the franchise', '1992-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(69, 10, 9, 3, 'Not bad, but not exceptional either', '1991-11-11');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(70, 1, 11, 5, 'Best game of the year', '1990-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(71, 2, 13, 4, 'A fun experience overall', '1989-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(72, 3, 15, 3, 'Average at best', '1988-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(73, 4, 17, 5, 'Simply amazing', '1987-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(74, 5, 19, 2, 'Disappointing', '1986-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(75, 6, 21, 4, 'Great for casual gamers', '1985-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(76, 7, 23, 3, 'Decent storyline', '1984-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(77, 8, 25, 5, 'Fantastic game mechanics', '1983-03-03');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(78, 9, 27, 4, 'Great multiplayer experience', '1982-02-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(79, 10, 29, 3, 'Has its moments', '1981-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(80, 1, 2, 5, 'Addictive gameplay', '1980-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(81, 2, 4, 3, 'Could be better optimized', '1979-11-11');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(82, 3, 6, 4, 'Good graphics', '1978-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(83, 4, 8, 3, 'Decent gameplay mechanics', '1977-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(84, 5, 10, 5, 'Great multiplayer component', '1976-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(85, 6, 12, 3, 'Needs more content', '1975-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(86, 7, 14, 4, 'Satisfying progression system', '1974-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(87, 8, 16, 2, 'Lacks innovation', '1973-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(88, 9, 18, 5, 'Exceptional storytelling', '1972-04-04');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(89, 10, 20, 4, 'Solid single-player campaign', '1971-03-03');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(90, 1, 22, 3, 'Repetitive gameplay', '1970-02-02');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(91, 2, 24, 5, 'Best game of the decade', '1969-01-01');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(92, 3, 26, 4, 'Great character customization', '1968-12-12');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(93, 4, 28, 2, 'Needs better optimization', '1967-11-11');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(94, 5, 30, 5, 'The ultimate gaming experience', '1966-10-10');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(95, 6, 1, 4, 'Great for parties', '1965-09-09');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(96, 7, 3, 3, 'Decent graphics', '1964-08-08');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(97, 8, 5, 5, 'A masterpiece', '1963-07-07');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(98, 9, 7, 4, 'Innovative gameplay mechanics', '1962-06-06');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(99, 10, 9, 2, 'Not worth the price', '1961-05-05');
INSERT INTO Game_Review (gameReviewID, gameID, userID, rating, review, reviewDate) VALUES(100, 1, 11, 5, 'Highly recommended', '1960-04-04');



\! echo
\! echo 'Counter strike'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (1, 1, 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/ss_796601d9d67faf53486eeb26d0724347cea67ddc.600x338.jpg?t=1698860631');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (2, 1, 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/ss_d830cfd0550fbb64d80e803e93c929c3abb02056.600x338.jpg?t=1698860631');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (3, 1, 'https://cdn.cloudflare.steamstatic.com/steam/apps/730/ss_13bb35638c0267759276f511ee97064773b37a51.600x338.jpg?t=1698860631');


\! echo
\! echo 'Palworld - Mystery'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (4, 2, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1623730/ss_a9fa84f0c21bc536f00925ab4586e8c4f587c2b7.600x338.jpg?t=1707904340');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (5, 2, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1623730/ss_b3cea7c9f04a67d784d4c6a0c157a11d6268b189.600x338.jpg?t=1707904340');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (6, 2, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1623730/ss_06e27c15c7b4b10233c937b887cf6a6925c83009.600x338.jpg?t=1707904340');


\! echo
\! echo 'Witcher'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (7, 3, 'https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_5710298af2318afd9aa72449ef29ac4a2ef64d8e.600x338.jpg?t=1710411171');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (8, 3, 'https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_0901e64e9d4b8ebaea8348c194e7a3644d2d832d.600x338.jpg?t=1710411171');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (9, 3, 'https://cdn.cloudflare.steamstatic.com/steam/apps/292030/ss_112b1e176c1bd271d8a565eacb6feaf90f240bb2.600x338.jpg?t=1710411171');


\! echo
\! echo 'Grand Theft Auto V'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (10, 4, 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_32aa18ab3175e3002217862dd5917646d298ab6b.1920x1080.jpg?t=1711059470');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (11, 4, 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_2744f112fa060320d191a50e8b3a92441a648a56.1920x1080.jpg?t=1711059470');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (12, 4, 'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/ss_da39c16db175f6973770bae6b91d411251763152.1920x1080.jpg?t=1711059470');


\! echo
\! echo 'Far Cry'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (13, 5, 'https://cdn.cloudflare.steamstatic.com/steam/apps/2369390/ss_195eb286dad05d3b9e56f22eafacce7efe9c9ebf.1920x1080.jpg?t=1706823201');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (14, 5, 'https://cdn.cloudflare.steamstatic.com/steam/apps/2369390/ss_65c6467467795423bb959aa2c76ad2659f6553cd.1920x1080.jpg?t=1706823201');


\! echo
\! echo 'Assassins Creed Valhalla'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (15, 6, 'https://cdn.cloudflare.steamstatic.com/steam/apps/812140/ss_0ef33c0f230da6ebac94f5959f0e0a8bbc48cf8a.600x338.jpg?t=1692034673');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (16, 6, 'https://cdn.cloudflare.steamstatic.com/steam/apps/812140/ss_3f8f4a09fb1d69648a8c20aae19ca2924ba275bd.600x338.jpg?t=1692034673');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (17, 6, 'https://cdn.cloudflare.steamstatic.com/steam/apps/812140/ss_6dc9f95cfb6d264c3535b53ce08f36ee07066550.600x338.jpg?t=1692034673');


\! echo
\! echo 'Cyberpunk 2077'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (18, 7, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_7924f64b6e5d586a80418c9896a1c92881a7905b.600x338.jpg?t=1706698946');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (19, 7, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_4eb068b1cf52c91b57157b84bed18a186ed7714b.600x338.jpg?t=1706698946');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (20, 7, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/ss_b529b0abc43f55fc23fe8058eddb6e37c9629a6a.600x338.jpg?t=1706698946');


\! echo
\! echo 'Diablo IV'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (21, 8, 'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/ss_89bab75878a11679207200584db2204596442d93.600x338.jpg?t=1710280608');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (22, 8, 'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/ss_45b8645d8f0f96b4ec9f01dcbcf308319de6ae88.600x338.jpg?t=1710280608');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (23, 8, 'https://cdn.cloudflare.steamstatic.com/steam/apps/2344520/ss_ac73795f99b8df62080ee968467e68f2654ab29e.600x338.jpg?t=1710280608');


\! echo
\! echo 'The Last of Us Part I'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (24, 9, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1888930/ss_c2853eee7ca824c42e008e83f3f45ad42d9e8547.600x338.jpg?t=1705640438');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (25, 9, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1888930/ss_abc373417afe2172ddf7b6d91442a14366a46975.600x338.jpg?t=1705640438');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (26, 9, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1888930/ss_0330e4473e70f6c0850f38204d712d5aa66e6223.600x338.jpg?t=1705640438');


\! echo
\! echo 'Red Dead Redemption 2'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (27, 10, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_66b553f4c209476d3e4ce25fa4714002cc914c4f.600x338.jpg?t=1695140956');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (28, 10, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_bac60bacbf5da8945103648c08d27d5e202444ca.600x338.jpg?t=1695140956');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (29, 10, 'https://cdn.cloudflare.steamstatic.com/steam/apps/1174180/ss_668dafe477743f8b50b818d5bbfcec669e9ba93e.600x338.jpg?t=1695140956');


\! echo
\! echo 'Elden Ring'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (30, 11, 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/ss_c97bcad291f4f45d4be4594f34bd78921d961099.116x65.jpg?t=1710261394');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (31, 11, 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/ss_7bef8e5fb78ee8bd396c5ff17af10731edf52c5f.116x65.jpg?t=1710261394');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (32, 11, 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/ss_8234a34c918d101fa0b15f73ca2aed5ac7232dbb.600x338.jpg?t=1710261394');


\! echo
\! echo 'Apex Legends'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (33, 12, 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/ss_b5051a24edf949582756c313eebf6f61582ce25f.600x338.jpg?t=1712869091');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (34, 12, 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/ss_ed4087e1f7e85905df637304ac4e511def7943e7.600x338.jpg?t=1712869091');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (35, 12, 'https://cdn.akamai.steamstatic.com/steam/apps/1172470/ss_a47a8c9b09393bd4cddfeb2891beb4d1eafb2897.600x338.jpg?t=1712869091');


\! echo
\! echo 'Dota 2'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (36, 13, 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_ad8eee787704745ccdecdfde3a5cd2733704898d.116x65.jpg?t=1713902421');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (37, 13, 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_7ab506679d42bfc0c0e40639887176494e0466d9.600x338.jpg?t=1713902421');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (38, 13, 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_c9118375a2400278590f29a3537769c986ef6e39.600x338.jpg?t=1713902421');


\! echo
\! echo 'Stray'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (39, 14, 'https://cdn.akamai.steamstatic.com/steam/apps/990080/ss_df93b5e8a183f7232d68be94ae78920a90de1443.600x338.jpg?t=1708720689');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (40, 14, 'https://cdn.akamai.steamstatic.com/steam/apps/990080/ss_94058497bf0f8fabdde17ee8d59bece609a60663.600x338.jpg?t=1708720689');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (41, 14, 'https://cdn.akamai.steamstatic.com/steam/apps/990080/ss_8e08976236d29b1897769257ac3c64e9264792a5.600x338.jpg?t=1708720689');


\! echo
\! echo 'Hogwarts Legacy'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (42, 15, 'https://cdn.akamai.steamstatic.com/steam/apps/1332010/ss_88e209a90c2039fa76bca6fa08c641365be38d50.600x338.jpg?t=1709318461');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (43, 15, 'https://cdn.akamai.steamstatic.com/steam/apps/1332010/ss_e8f0cbd5efdba352e89c4cfcee3fe991a1e1be8a.600x338.jpg?t=1709318461');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (44, 15, 'https://cdn.akamai.steamstatic.com/steam/apps/1332010/ss_2221af260c64362fdc835a9dca65f6f1d1192b25.600x338.jpg?t=1709318461');


\! echo
\! echo 'Call of Duty: Modern Warfare II'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (45, 16, 'https://cdn.akamai.steamstatic.com/steam/apps/311210/ss_ca7376d838d5714f916936f0070824c27c4c5641.116x65.jpg?t=1646763462');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (46, 16, 'https://cdn.akamai.steamstatic.com/steam/apps/311210/ss_150874824f4fff0915e63ea2ade5410e576a2b70.600x338.jpg?t=1646763462');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (47, 16, 'https://cdn.akamai.steamstatic.com/steam/apps/311210/ss_4b270e7a32d3a93a8119e7bcc3d8dcaa784f84f1.600x338.jpg?t=1646763462');


\! echo
\! echo 'Valorant'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (48, 17, 'https://cdn.akamai.steamstatic.com/steam/apps/824270/ss_e2af5cbe8431d914d26a5752a8e569a140f15528.600x338.jpg?t=1708127801');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (49, 17, 'https://cdn.akamai.steamstatic.com/steam/apps/824270/ss_839bf1b17c080da1f2ff2da373a229981f79c38b.600x338.jpg?t=1708127801');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (50, 17, 'https://cdn.akamai.steamstatic.com/steam/apps/824270/ss_51c0137792bd7204f1eb55c0247ac858bd3d1558.600x338.jpg?t=1708127801');


\! echo
\! echo 'Minecraft'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (51, 18, 'https://cdn.akamai.steamstatic.com/steam/apps/1672970/ss_46ee31494b5d144d5ef6670cb5a1564abbc26fab.600x338.jpg?t=1697014975');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (52, 18, 'https://cdn.akamai.steamstatic.com/steam/apps/1672970/ss_73b488e696e3ae45f5d0a5750de524c231dab8a2.600x338.jpg?t=1697014975');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (53, 18, 'https://cdn.akamai.steamstatic.com/steam/apps/1672970/ss_9cb3efba6636610ec78eddd550147ed5ee7be3a0.600x338.jpg?t=1697014975');


\! echo
\! echo 'Rocket League'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (54, 19, 'https://cdn.akamai.steamstatic.com/steam/apps/1324350/ss_fb7c2ae20d5310055d362edafed047007d64e808.116x65.jpg?t=1712240032');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (55, 19, 'https://cdn.akamai.steamstatic.com/steam/apps/1324350/ss_1f2c59e45bce912339758832e72294404248cb36.116x65.jpg?t=1712240032');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (56, 19, 'https://cdn.akamai.steamstatic.com/steam/apps/1324350/ss_89ad6344423b7e83374bb5e43c783f1af71ac8b5.116x65.jpg?t=1712240032');


\! echo
\! echo 'Total War: Warhammer III'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (57, 20, 'https://cdn.akamai.steamstatic.com/steam/apps/1142710/ss_6149b0570c42cda0e40b4de71e6f48bbe5c4c577.116x65.jpg?t=1712754521');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (58, 20, 'https://cdn.akamai.steamstatic.com/steam/apps/1142710/ss_320f5373c16e33f50c0ee2ccc822344c0e0d5f8d.600x338.jpg?t=1712754521');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (59, 20, 'https://cdn.akamai.steamstatic.com/steam/apps/1142710/ss_4afac709f1bfe992122e315852cf6ea2f58b28ba.116x65.jpg?t=1712754521');


\! echo
\! echo 'Terraria'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (60, 21, 'https://cdn.akamai.steamstatic.com/steam/apps/105600/ss_8c03886f214d2108cafca13845533eaa3d87d83f.116x65.jpg?t=1666290860');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (61, 21, 'https://cdn.akamai.steamstatic.com/steam/apps/105600/ss_ae168a00ab08104ba266dc30232654d4b3c919e5.116x65.jpg?t=1666290860');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (62, 21, 'https://cdn.akamai.steamstatic.com/steam/apps/105600/ss_9edd98caaf9357c2f40758f354475a56e356e8b0.116x65.jpg?t=1666290860');


\! echo
\! echo 'Phasmophobia'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (63, 22, 'https://cdn.akamai.steamstatic.com/steam/apps/739630/ss_c88170bed9bf8690963323d20e3f9e836cb9aed9.116x65.jpg?t=1702309974');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (64, 22, 'https://cdn.akamai.steamstatic.com/steam/apps/739630/ss_f0377c02897de8831a5f032f13a6dc0f994516d5.116x65.jpg?t=1702309974');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (65, 22, 'https://cdn.akamai.steamstatic.com/steam/apps/739630/ss_ce1062b9312afbc12000f980087ede8fa718445d.116x65.jpg?t=1702309974');


\! echo
\! echo 'Hades'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (66, 23, 'https://cdn.akamai.steamstatic.com/steam/apps/1145360/ss_c0fed447426b69981cf1721756acf75369801b31.116x65.jpg?t=1702510146');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (67, 23, 'https://cdn.akamai.steamstatic.com/steam/apps/1145360/ss_8a9f0953e8a014bd3df2789c2835cb787cd3764d.116x65.jpg?t=1702510146');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (68, 23, 'https://cdn.akamai.steamstatic.com/steam/apps/1145360/ss_68300459a8c3daacb2ec687adcdbf4442fcc4f47.116x65.jpg?t=1702510146');


\! echo
\! echo 'Factorio'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (69, 24, 'https://cdn.akamai.steamstatic.com/steam/apps/427520/ss_171f398a8e347fad650a9c1b6c3b77c612781510.116x65.jpg?t=1694021968');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (70, 24, 'https://cdn.akamai.steamstatic.com/steam/apps/427520/ss_36e4d8e5540805f5ed492d24d784ed9ba661752b.116x65.jpg?t=1694021968');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (71, 24, 'https://cdn.akamai.steamstatic.com/steam/apps/427520/ss_0bf814493f247b6baa093511b46c352cf9e98435.116x65.jpg?t=1694021968');


\! echo
\! echo 'Civilization VI'
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (72, 25, 'https://cdn.akamai.steamstatic.com/steam/apps/289070/ss_6c4a3cfb61f1a9677cf2ac549c2816a4e651f741.116x65.jpg?t=1708651986');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (73, 25, 'https://cdn.akamai.steamstatic.com/steam/apps/289070/ss_b2bf12299c38214fe520af0f724a6349d17ed330.116x65.jpg?t=1708651986');
INSERT INTO Game_Screenshots (screenshotID, gameID, screenshotURL) VALUES (74, 25, 'https://cdn.akamai.steamstatic.com/steam/apps/289070/ss_7f598198526afc260d939a98af4d76d95f5349e4.116x65.jpg?t=1708651986');


\! echo 
\! echo 'select * from Users order by userName;'
\! echo 'select developerName, headquartersLocation from Developers;'
\! echo "select gameName from Games where gameGenre = 'Action';"
\! echo "select * from Game_Review where gameID = 1;"


SELECT * FROM Users;
