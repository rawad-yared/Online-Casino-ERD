SELECT * From payment;

-- Q1: Which are the top 3 countries with the greatest number of players?
SELECT c.Name AS Country, COUNT(u.User_ID) AS Total_Players
FROM User u
INNER JOIN User_Profile up ON (u.User_ID = up.User_ID)
INNER JOIN Country c ON up.Country_ID = c.Country_ID
GROUP BY c.Name
ORDER BY Total_Players DESC
LIMIT 3;


-- Q2: Which are the top 3 demanding casino games?
SELECT g.Name AS Game, COUNT(b.Bet_ID) AS Total_Bets
FROM Bet b
INNER JOIN Game g ON b.Game_ID = g.Game_ID
GROUP BY g.Name
ORDER BY Total_Bets DESC
LIMIT 3;


-- Q3: Which is the easiest game to win, by number of bets won by players?
SELECT g.Name AS Game,
		   SUM(CASE WHEN bs.Name = 'Won' THEN 1 ELSE 0 END) AS Total_Wins,
		   COUNT(b.Bet_ID) AS Total_Bets,
		   ROUND((SUM(CASE WHEN bs.Name = 'Won' THEN 1 ELSE 0 END) / COUNT(b.Bet_ID)) * 100, 2) AS Win_Ratio_Percentage
FROM Bet b
INNER JOIN Game g ON b.Game_ID = g.Game_ID
INNER JOIN Bet_Status bs ON b.Status_ID = bs.Status_ID
GROUP BY g.Name
ORDER BY Win_Ratio_Percentage DESC
LIMIT 1;



-- Q4: Show a linear graph of revenue for the last 12 months
SELECT YEAR(Payment_Date) AS Year,
		   MONTH(Payment_Date) AS Month,
		   SUM(Amount) AS Total_Revenue
FROM Payment
WHERE Status_ID = 2 -- ID for completed payments
    AND (
		    (YEAR(Payment_Date) = YEAR(CURDATE()) AND MONTH(Payment_Date) < MONTH(CURDATE()))
        OR (YEAR(Payment_Date) = YEAR(CURDATE()) - 1 AND MONTH(Payment_Date) >= MONTH(CURDATE()))
		    )
GROUP BY YEAR(Payment_Date), MONTH(Payment_Date)
ORDER BY Year, Month;
    
    
-- Q5: What is the average bet amount by game?
SELECT g.Name AS Game, AVG(b.Bet_Amount) AS Average_Bet
FROM Bet b
INNER JOIN Game g ON b.Game_ID = g.Game_ID
GROUP BY g.Name
ORDER BY Average_Bet DESC;
