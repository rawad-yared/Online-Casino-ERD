-- Creating the Schema
CREATE SCHEMA IF NOT EXISTS online_casino;

-- 1. Game Management Sub-Model

-- Lookup table: Game Category
CREATE TABLE Game_Category (
    Category_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);

-- Lookup table: Game Provider
CREATE TABLE Game_Provider (
    Provider_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Website_URL VARCHAR(255),
    Contact_Info VARCHAR(255)
);

-- Lookup table: Game Level
CREATE TABLE Game_Level (
    Level_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,
    Win_Threshold DECIMAL(5,2),
    Description VARCHAR(255)
);

-- Main table: Game (no foreign keys yet)
CREATE TABLE Game (
    Game_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Description VARCHAR(500),
    Release_Date DATE,
    RTP DECIMAL(5,2) NOT NULL,
    Min_Bet DECIMAL(10,2) NOT NULL,
    Max_Bet DECIMAL(10,2) NOT NULL,
    Active_Flag BOOLEAN DEFAULT TRUE,
    Category_ID INT NOT NULL,
    Provider_ID INT NOT NULL,
    Level_ID INT NOT NULL,
    CONSTRAINT uq_game UNIQUE (Name, Provider_ID)
);

-- Referential Integrity

-- Game - Game_Category
ALTER TABLE Game
ADD CONSTRAINT fk_game_category
FOREIGN KEY (Category_ID)
REFERENCES Game_Category(Category_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- Game - Game_Provider
ALTER TABLE Game
ADD CONSTRAINT fk_game_provider
FOREIGN KEY (Provider_ID)
REFERENCES Game_Provider(Provider_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- Game - Game_Level
ALTER TABLE Game
ADD CONSTRAINT fk_game_level
FOREIGN KEY (Level_ID)
REFERENCES Game_Level(Level_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;



-- 2. Geography & Localization Sub-Model

-- Lookup table: Currency
CREATE TABLE Currency (
    Currency_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,         -- e.g., Dollar, Euro
    Symbol VARCHAR(10) NOT NULL,               -- e.g., $, €
    ISO_Code CHAR(3) NOT NULL UNIQUE           -- e.g., USD, EUR
);

-- Main table: Country
CREATE TABLE Country (
    Country_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,         -- e.g., United States
    ISO_Code CHAR(2) NOT NULL UNIQUE,          -- e.g., US
    Currency_ID INT NOT NULL                    -- FK later
);

-- Optional table: City (if finer granularity is needed)
CREATE TABLE City (
    City_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country_ID INT NOT NULL,                   -- FK later
    UNIQUE (Name, Country_ID)                  -- Prevent duplicate cities per country
);


-- Referential Integrity

-- Country - Currency
ALTER TABLE Country
ADD CONSTRAINT fk_country_currency
FOREIGN KEY (Currency_ID)
REFERENCES Currency(Currency_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- City - Country
ALTER TABLE City
ADD CONSTRAINT fk_city_country
FOREIGN KEY (Country_ID)
REFERENCES Country(Country_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;



-- 3.User & Account sub-model

-- Lookup table: User Status
CREATE TABLE User_Status (
    Status_ID CHAR(1) PRIMARY KEY, -- A,S,B
    Name VARCHAR(50) NOT NULL UNIQUE, -- Active, Suspended, Banned
    Description VARCHAR(255)
);

-- Lookup table: Language
CREATE TABLE Language (
    Language_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE, -- English, Spanish, etc.
    ISO_Code CHAR(5) UNIQUE -- e.g., en-US
);

-- Main table: User (core login/account details)
CREATE TABLE User (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password_Hash VARCHAR(255) NOT NULL,
    Registration_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status_ID CHAR(1) NOT NULL -- FK later
);

-- Sub-table: User Profile (personal details)
CREATE TABLE User_Profile (
    Profile_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL UNIQUE, -- FK later
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    DOB DATE,
    Gender ENUM('Male', 'Female', 'Other'),
    Language_ID INT NOT NULL, -- FK later
	Country_ID INT NOT NULL -- FK later
);

-- Sub-table: User Devices
CREATE TABLE User_Device (
    Device_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL, -- FK later
    Device_Type ENUM('Mobile', 'Desktop', 'Tablet') NOT NULL,
    OS VARCHAR(50),
    Browser VARCHAR(50),
    Last_Login DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- Referntial Integrity

-- User - User_Status
ALTER TABLE User
ADD CONSTRAINT fk_user_status
FOREIGN KEY (Status_ID)
REFERENCES User_Status(Status_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- User_Profile - User
ALTER TABLE User_Profile
ADD CONSTRAINT fk_user_profile_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- User_Profile - Language
ALTER TABLE User_Profile
ADD CONSTRAINT fk_user_profile_language
FOREIGN KEY (Language_ID)
REFERENCES Language(Language_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- User_Device - User
ALTER TABLE User_Device
ADD CONSTRAINT fk_user_device_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- User_profile - country
ALTER TABLE User_profile
ADD CONSTRAINT fk_user_profile_country FOREIGN KEY (Country_ID)
REFERENCES Country(Country_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;





-- 4. Payments & Transactions

-- Lookup table: Payment Method
CREATE TABLE Payment_Method (
    Method_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,            -- e.g., Visa, PayPal, Crypto
    Payment_Type ENUM('Card', 'Wallet', 'Crypto', 'Bank') NOT NULL
);

-- Lookup table: Payment Status
CREATE TABLE Payment_Status (
    Status_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,            -- Pending, Completed, Failed, Refunded
    Description VARCHAR(255)
);

-- Main table: Payment
CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,                         -- FK later
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0.00),
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status_ID INT NOT NULL,                       -- FK later
    Method_ID INT NOT NULL,                       -- FK later
    Currency_ID INT NOT NULL                      -- FK later (for multi-currency support)
);


-- Referential Integrity

-- Payment - User
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Payment - Payment_Status
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_status
FOREIGN KEY (Status_ID)
REFERENCES Payment_Status(Status_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- Payment - Payment_Method
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_method
FOREIGN KEY (Method_ID)
REFERENCES Payment_Method(Method_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- Payment - Currency
ALTER TABLE Payment
ADD CONSTRAINT fk_payment_currency
FOREIGN KEY (Currency_ID)
REFERENCES Currency(Currency_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;




-- 5. Bets & Session Sub-Model

-- Lookup table: Bet Status
CREATE TABLE Bet_Status (
    Status_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,            -- Placed, Won, Lost, Cancelled
    Description VARCHAR(255)
);

-- Main table: Session
CREATE TABLE Session (
    Session_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,                        -- FK later
    Start_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    End_Time DATETIME,
    Device_ID INT,                               -- FK later
    IP_Address VARCHAR(45)                       -- Supports IPv4 and IPv6
);

-- Main table: Bet
CREATE TABLE Bet (
    Bet_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,                        -- FK later
    Session_ID INT NOT NULL,                     -- FK later
    Game_ID INT NOT NULL,                        -- FK later
    Bet_Amount DECIMAL(10,2) NOT NULL CHECK (Bet_Amount > 0.00),
    Win_Amount DECIMAL(10,2) DEFAULT 0.00,
    Bet_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status_ID INT NOT NULL                       -- FK later
);


-- Referential Integrity

-- Session - User
ALTER TABLE Session
ADD CONSTRAINT fk_session_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Session - User_Device
ALTER TABLE Session
ADD CONSTRAINT fk_session_device
FOREIGN KEY (Device_ID)
REFERENCES User_Device(Device_ID)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- Bet - User
ALTER TABLE Bet
ADD CONSTRAINT fk_bet_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Bet - Session
ALTER TABLE Bet
ADD CONSTRAINT fk_bet_session
FOREIGN KEY (Session_ID)
REFERENCES Session(Session_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Bet - Game
ALTER TABLE Bet
ADD CONSTRAINT fk_bet_game
FOREIGN KEY (Game_ID)
REFERENCES Game(Game_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- Bet - Bet_Status
ALTER TABLE Bet
ADD CONSTRAINT fk_bet_status
FOREIGN KEY (Status_ID)
REFERENCES Bet_Status(Status_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;




-- 6. Online Behaviour

-- Lookup table: Action Type
CREATE TABLE Action_Type (
    Action_Type_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,          -- e.g., Login, Logout, Bet Placed, Payment Made
    Description VARCHAR(255)
);

-- Main table: User Action Log
CREATE TABLE User_Action_Log (
    Log_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,                      -- FK later
    Action_Type_ID INT NOT NULL,               -- FK later
    Action_Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Details VARCHAR(500)                        -- Optional details like IP, browser info, etc.
);


-- Referential Integrity

-- User_Action_Log - User
ALTER TABLE User_Action_Log
ADD CONSTRAINT fk_user_action_log_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- User_Action_Log - Action_Type
ALTER TABLE User_Action_Log
ADD CONSTRAINT fk_user_action_log_action_type
FOREIGN KEY (Action_Type_ID)
REFERENCES Action_Type(Action_Type_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;





-- 7. Tournament

-- Lookup table: Tournament Status
CREATE TABLE Tournament_Status (
    Status_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL UNIQUE,            -- Scheduled, Active, Completed, Cancelled
    Description VARCHAR(255)
);

-- Main table: Tournament
CREATE TABLE Tournament (
    Tournament_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Description VARCHAR(500),
    Start_Date DATETIME NOT NULL,
    End_Date DATETIME NOT NULL,
    Entry_Fee DECIMAL(10,2) DEFAULT 0.00,
    Prize_Pool DECIMAL(12,2) DEFAULT 0.00,
    Status_ID INT NOT NULL,                      -- FK later
    UNIQUE (Name, Start_Date)                    -- Prevent duplicate tournaments with same name and start
);

-- Junction table: User_Tournament (tracks user participation)
CREATE TABLE User_Tournament (
    User_Tournament_ID INT AUTO_INCREMENT PRIMARY KEY,
    User_ID INT NOT NULL,                        -- FK later
    Tournament_ID INT NOT NULL,                  -- FK later
    Join_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (User_ID, Tournament_ID)              -- Prevent duplicate user participation
);

-- Junction table: Game_Tournament (tracks games included)
CREATE TABLE Game_Tournament (
    Game_Tournament_ID INT AUTO_INCREMENT PRIMARY KEY,
    Game_ID INT NOT NULL,                        -- FK later
    Tournament_ID INT NOT NULL,                  -- FK later
    UNIQUE (Game_ID, Tournament_ID)              -- Prevent duplicate game inclusion
);

-- Sub-table: Leaderboard (tracks scores and ranks)
CREATE TABLE Leaderboard (
    Leaderboard_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tournament_ID INT NOT NULL,                  -- FK later
    User_ID INT NOT NULL,                        -- FK later
    Score DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Ranking INT NOT NULL,
    UNIQUE (Tournament_ID, User_ID)              -- Each user has one leaderboard entry per tournament
);

-- Sub-table: Tournament_Prize (tiered payout structure)
CREATE TABLE Tournament_Prize (
    Prize_ID INT AUTO_INCREMENT PRIMARY KEY,
    Tournament_ID INT NOT NULL,                  -- FK later
    Position INT NOT NULL,  -- e.g., 1 = 1st place
    Amount DECIMAL(12,2) NOT NULL,
    UNIQUE (Tournament_ID, Position)             -- Prevent duplicate prize positions
);


-- Referential Integrity

-- Tournament - Tournament_Status
ALTER TABLE Tournament
ADD CONSTRAINT fk_tournament_status
FOREIGN KEY (Status_ID)
REFERENCES Tournament_Status(Status_ID)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- User_Tournament - User
ALTER TABLE User_Tournament
ADD CONSTRAINT fk_user_tournament_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- User_Tournament - Tournament
ALTER TABLE User_Tournament
ADD CONSTRAINT fk_user_tournament_tournament
FOREIGN KEY (Tournament_ID)
REFERENCES Tournament(Tournament_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Game_Tournament - Game
ALTER TABLE Game_Tournament
ADD CONSTRAINT fk_game_tournament_game
FOREIGN KEY (Game_ID)
REFERENCES Game(Game_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Game_Tournament - Tournament
ALTER TABLE Game_Tournament
ADD CONSTRAINT fk_game_tournament_tournament
FOREIGN KEY (Tournament_ID)
REFERENCES Tournament(Tournament_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Leaderboard - Tournament
ALTER TABLE Leaderboard
ADD CONSTRAINT fk_leaderboard_tournament
FOREIGN KEY (Tournament_ID)
REFERENCES Tournament(Tournament_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Leaderboard - User
ALTER TABLE Leaderboard
ADD CONSTRAINT fk_leaderboard_user
FOREIGN KEY (User_ID)
REFERENCES User(User_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- Tournament_Prize - Tournament
ALTER TABLE Tournament_Prize
ADD CONSTRAINT fk_tournament_prize_tournament
FOREIGN KEY (Tournament_ID)
REFERENCES Tournament(Tournament_ID)
ON UPDATE CASCADE
ON DELETE CASCADE;



