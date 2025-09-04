-- 1. Currency
INSERT INTO Currency (Name, Symbol, ISO_Code)
VALUES 
    ('US Dollar', '$', 'USD'),
    ('Euro', '€', 'EUR'),
    ('British Pound', '£', 'GBP');
    
-- 2. Country
INSERT INTO Country (Name, ISO_Code, Currency_ID)
VALUES
    ('United States', 'US', 1),  -- USD
    ('Spain', 'ES', 2),          -- EUR
    ('United Kingdom', 'GB', 3); -- GBP
    
-- 3. User Status
INSERT INTO User_Status (Status_ID, Name, Description)
VALUES
    ('A', 'Active', 'Active user account'),
    ('S', 'Suspended', 'Suspended user account'),
    ('B', 'Banned', 'Banned user account');

-- 4. Language
INSERT INTO Language (Name, ISO_Code)
VALUES
    ('English', 'en-US'),
    ('Spanish', 'es-ES'),
    ('French', 'fr-FR');
    
-- 5. Payment method
INSERT INTO Payment_Method (Name, Payment_Type)
VALUES
    ('Visa', 'Card'),
    ('PayPal', 'Wallet'),
    ('Crypto', 'Crypto');
    
    
-- 6. Payment status
INSERT INTO Payment_Status (Name, Description)
VALUES
    ('Pending', 'Payment is pending'),
    ('Completed', 'Payment successfully completed'),
    ('Failed', 'Payment failed'),
    ('Refunded', 'Payment was refunded');

-- 7. Game category
INSERT INTO Game_Category (Name, Description)
VALUES
    ('Slots', 'Slot machines'),
    ('Table Games', 'Blackjack, Roulette, etc.'),
    ('Live Dealer', 'Live-streamed casino games');
    
-- 8. Game provider
INSERT INTO Game_Provider (Name, Website_URL, Contact_Info)
VALUES
    ('IEGameDev', 'https://www.iegamedev.com', 'support@ie.com'),
    ('Playtech', 'https://www.playtech.com', 'support@playtech.com');
    
-- 9. Game level
INSERT INTO Game_Level (Name, Win_Threshold, Description)
VALUES
    ('Easy', 75.00, 'Games with high chance of winning'),
    ('Medium', 50.00, 'Moderate chance of winning'),
    ('Hard', 25.00, 'Games with low chance of winning');
    

-- 10. Games
INSERT INTO Game (Name, Description, Release_Date, RTP, Min_Bet, Max_Bet, Active_Flag, Category_ID, Provider_ID, Level_ID)
VALUES
    ('Lucky Slots', 'High RTP slot machine', '2022-01-15', 96.50, 0.50, 50.00, TRUE, 1, 1, 1),   -- Slots, IEGameDev, Easy
    ('Roulette Royale', 'Classic European Roulette', '2021-06-10', 94.30, 1.00, 100.00, TRUE, 2, 2, 2), -- Table Games, Playtech, Medium
    ('Blackjack Pro', 'Advanced Blackjack table game', '2020-09-25', 97.80, 5.00, 500.00, TRUE, 2, 1, 3); -- Table Games, IEGameDev, Hard
    
-- 11. Users
INSERT INTO User (Username, Email, Password_Hash, Registration_Date, Status_ID)
VALUES
    ('G_barrage', 'ghalia_barrage@gmail.com', 'hash1', '2023-01-10 12:00:00', 'A'),
    ('daniel_noun', 'daniel_noun@gmail.com', 'hash2', '2023-02-15 14:30:00', 'A'),
    ('soph_kh', 'sophie_khalil@gmail.com', 'hash3', '2023-03-20 09:45:00', 'A'),
    ('sharizzle', 'sharif_kanaan@gmail.com', 'hash4', '2023-04-05 17:25:00', 'A'),
    ('maria_lopez', 'maria_lopez@gmail.com', 'hash5', '2023-05-18 11:15:00', 'A');


-- 12. User profile
INSERT INTO User_Profile (User_ID, First_Name, Last_Name, DOB, Gender, Language_ID, Country_ID)
VALUES
    (1, 'Ghalia', 'Barrage', '1990-05-12', 'Female', 1, 1), -- United States
    (2, 'Daniel', 'Noun', '1985-09-03', 'Male', 2, 2),      -- Spain
    (3, 'Sophie', 'Khalil', '1992-12-08', 'Female', 3, 3),  -- UK
    (4, 'Sharif', 'Kanaan', '1988-07-22', 'Male', 1, 1),    -- United States
    (5, 'Maria', 'Lopez', '1995-03-15', 'Female', 2, 2);    -- Spain
    
    
-- 13. user_device
INSERT INTO User_Device (User_ID, Device_Type, OS, Browser, Last_Login)
VALUES
    (1, 'Mobile', 'iOS', 'Safari', '2023-08-01 09:00:00'),
    (2, 'Desktop', 'Windows', 'Chrome', '2023-08-02 10:15:00'),
    (3, 'Tablet', 'Android', 'Firefox', '2023-08-03 11:30:00');

-- 14. Session
INSERT INTO Session (User_ID, Start_Time, End_Time, Device_ID, IP_Address)
VALUES
    (1, '2024-08-01 09:00:00', '2024-08-01 09:30:00', 1, '192.168.1.1'),
    (2, '2024-08-02 10:15:00', '2024-08-02 10:50:00', 2, '192.168.1.2'),
    (3, '2024-08-03 11:30:00', '2024-08-03 12:15:00', 3, '192.168.1.3'),
    (4, '2024-09-05 13:00:00', '2024-09-05 13:45:00', 1, '192.168.1.4'),
    (5, '2024-09-06 14:30:00', '2024-09-06 15:20:00', 2, '192.168.1.5');



-- 15. bet_status
INSERT INTO Bet_Status (Name, Description)
VALUES
    ('Placed', 'Bet has been placed and awaiting result'),
    ('Won', 'Bet was successful and paid out'),
    ('Lost', 'Bet was unsuccessful'),
    ('Cancelled', 'Bet was cancelled by user or system');


-- 16. bets
INSERT INTO Bet (User_ID, Session_ID, Game_ID, Bet_Amount, Win_Amount, Bet_Date, Status_ID)
VALUES
    (1, 1, 1, 10.00, 20.00, '2024-08-01 15:30:00', 2), -- Won
    (1, 1, 1, 5.00, 0.00, '2024-08-02 18:10:00', 3),   -- Lost
    (2, 2, 2, 25.00, 50.00, '2024-08-05 12:00:00', 2), -- Won

    (3, 3, 3, 50.00, 0.00, '2024-09-08 19:30:00', 3),  -- Lost
    (4, 4, 1, 5.00, 10.00, '2024-09-11 10:00:00', 2),  -- Won
    (5, 5, 1, 10.00, 0.00, '2024-09-13 15:30:00', 3),  -- Lost

    (1, 1, 1, 15.00, 30.00, '2024-10-03 20:45:00', 2), -- Won
    (2, 2, 2, 20.00, 0.00, '2024-10-06 14:00:00', 3),  -- Lost
    (3, 3, 3, 100.00, 200.00, '2024-10-09 21:10:00', 2), -- Won

    (4, 4, 2, 20.00, 0.00, '2024-12-12 13:45:00', 3),  -- Lost
    (5, 5, 1, 15.00, 30.00, '2024-12-14 18:00:00', 2), -- Won

    (1, 1, 1, 10.00, 0.00, '2025-01-05 16:00:00', 3),  -- Lost
    (2, 2, 2, 30.00, 60.00, '2025-01-07 18:30:00', 2), -- Won

    (3, 3, 3, 75.00, 0.00, '2025-02-10 23:15:00', 3),  -- Lost
    (4, 4, 1, 8.00, 16.00, '2025-02-15 09:20:00', 2),  -- Won

    (5, 5, 1, 12.00, 0.00, '2025-03-13 17:40:00', 3),  -- Lost
    (1, 1, 1, 20.00, 40.00, '2025-03-18 14:50:00', 2), -- Won

    (2, 2, 2, 50.00, 0.00, '2025-05-05 13:15:00', 3),  -- Lost
    (3, 3, 3, 90.00, 180.00, '2025-05-09 21:10:00', 2), -- Won

    (4, 4, 1, 6.00, 12.00, '2025-06-02 11:10:00', 2),  -- Won
    (5, 5, 1, 15.00, 0.00, '2025-06-05 14:30:00', 3);  -- Lost
    

-- 17. Payments
INSERT INTO Payment (User_ID, Amount, Payment_Date, Status_ID, Method_ID, Currency_ID)
VALUES
    -- G_barrage (USD)
    (1, 120.00, '2024-08-10 10:20:00', 2, 1, 1),
    (1, 75.00,  '2024-10-05 14:50:00', 2, 2, 1),
    (1, 60.00,  '2025-03-15 09:30:00', 2, 3, 1),

    -- daniel_noun (EUR)
    (2, 180.00, '2024-09-12 11:00:00', 2, 1, 2),
    (2, 220.00, '2025-01-20 17:15:00', 2, 2, 2),
    (2, 90.00,  '2025-05-07 13:10:00', 2, 3, 2),

    -- soph_kh (GBP)
    (3, 250.00, '2024-11-18 12:45:00', 2, 1, 3),
    (3, 300.00, '2025-04-09 15:30:00', 2, 2, 3),

    -- sharizzle (USD)
    (4, 100.00, '2024-08-25 08:50:00', 2, 3, 1),
    (4, 90.00,  '2025-02-14 16:05:00', 2, 2, 1),

    -- maria_lopez (EUR)
    (5, 70.00,  '2024-12-01 18:20:00', 2, 1, 2),
    (5, 110.00, '2025-06-22 10:15:00', 2, 3, 2);
    

-- 18. action_type
INSERT INTO Action_Type (Name, Description)
VALUES
    ('Login', 'User logged into the system'),
    ('Logout', 'User logged out of the system'),
    ('Place Bet', 'User placed a bet'),
    ('Make Payment', 'User completed a payment');
    
-- 19. user_action_log
INSERT INTO User_Action_Log (User_ID, Action_Type_ID, Action_Timestamp, Details)
VALUES
    (1, 1, '2023-08-01 09:00:00', 'IP:192.168.1.1; Browser:Chrome'),
    (1, 3, '2023-08-01 09:05:00', 'Bet on Lucky Slots'),
    (2, 1, '2023-08-02 10:15:00', 'IP:192.168.1.2; Browser:Firefox'),
    (2, 4, '2023-08-02 10:20:00', 'Payment of $200 via Visa'),
    (3, 1, '2023-08-03 11:30:00', 'IP:192.168.1.3; Browser:Safari'),
    (3, 2, '2023-08-03 11:50:00', 'Logout after session');
    
-- 20. tournament_status
INSERT INTO Tournament_Status (Name, Description)
VALUES
    ('Scheduled', 'Tournament is planned but not started'),
    ('Active', 'Tournament is currently running'),
    ('Completed', 'Tournament has finished');
    
-- 21. tournament
INSERT INTO Tournament (Name, Description, Start_Date, End_Date, Entry_Fee, Prize_Pool, Status_ID)
VALUES
    ('Summer Slots Challenge', 'Compete on slots for cash prizes', '2023-06-01', '2023-06-30', 10.00, 5000.00, 3),
    ('Roulette Royale Tournament', 'Top roulette players compete', '2023-07-01', '2023-07-31', 20.00, 8000.00, 3);
    
-- 22. user_tournament
INSERT INTO User_Tournament (User_ID, Tournament_ID, Join_Date)
VALUES
    (1, 1, '2023-06-05 08:00:00'),
    (2, 1, '2023-06-06 10:30:00'),
    (3, 2, '2023-07-02 09:15:00'),
    (4, 2, '2023-07-03 11:00:00');
    
-- 23. game_tournament
INSERT INTO Game_Tournament (Game_ID, Tournament_ID)
VALUES
    (1, 1), -- Lucky Slots in Summer Slots Challenge
    (2, 2); -- Roulette Royale in Roulette Royale Tournament
    
-- 24. leaderboard
INSERT INTO Leaderboard (Tournament_ID, User_ID, Score, Ranking)
VALUES
    (1, 1, 1500.00, 1),
    (1, 2, 1200.00, 2),
    (2, 3, 2000.00, 1),
    (2, 4, 1800.00, 2);
    

-- 25. tournament_prize
INSERT INTO Tournament_Prize (Tournament_ID, Position, Amount)
VALUES
    (1, 1, 2500.00),
    (1, 2, 1500.00),
    (1, 3, 1000.00),
    (2, 1, 4000.00),
    (2, 2, 2500.00),
    (2, 3, 1500.00);
    
    
-- 26. city
INSERT INTO City (Name, Country_ID)
VALUES
    ('New York', 1),
    ('Madrid', 2),
    ('London', 3);
    










