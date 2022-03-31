--Part 1

--create view for transactions for each card holder
CREATE VIEW card_holder_transactions AS
SELECT
	credit_card.card_holder_id, 
	COUNT(transaction.amount) AS total_num_transactions
FROM transaction
LEFT JOIN credit_card 
ON transaction.card = credit_card.card
GROUP BY credit_card.card_holder_id;

	
--create view for transactions less than $2.00
CREATE VIEW transactions_less_2 AS
SELECT
	credit_card.card_holder_id,
	COUNT(transaction.amount) AS num_transactions_less_2
FROM transaction
LEFT JOIN credit_card 
ON transaction.card = credit_card.card
WHERE transaction.amount <2
GROUP BY credit_card.card_holder_id;

--create view for combined count of totoal transactions and transactions less than $2
CREATE VIEW number_transactions AS
SELECT 
	card_holder_transactions.card_holder_id,
	card_holder_transactions.total_num_transactions,
	transactions_less_2.num_transactions_less_2,
	(transactions_less_2.num_transactions_less_2 *100/ card_holder_transactions.total_num_transactions)AS percentage
FROM card_holder_transactions
LEFT JOIN transactions_less_2
ON card_holder_transactions.card_holder_id = transactions_less_2.card_holder_id;

CREATE VIEW percentage_of_less_2 AS
SELECT MIN(percentage),
		MAX(percentage),
		AVG(percentage)
FROM number_transactions; 



--create view for Card holder 2 and 18 transactions
CREATE VIEW fraud AS
SELECT 
	        credit_card.card_holder_id,
	        transaction.date, 
	        transaction.amount 
        FROM transaction
        LEFT JOIN credit_card 
        ON transaction.card = credit_card.card
        WHERE credit_card.card_holder_id = 2 OR credit_card.card_holder_id= 18;

--Create view for counting the transactions that are less than $2.00 cardholder 2 and 18.
CREATE VIEW count_less_than_2 AS
	SELECT 
		COUNT(*)
	FROM fraud
	WHERE amount <2
	GROUP BY card_holder_id;

SELECT COUNT(*) FROM fraud
GROUP BY card_holder_id;

--Create view for 100 highest transactions made between 7:00 am and 9:00 am
CREATE VIEW highest_100 AS
	SELECT
		transaction.transation_id,
		credit_card.card_holder_id,
	    transaction.date, 
	    transaction.amount,
		transaction.merchant_id
    FROM transaction
    LEFT JOIN credit_card 
    ON transaction.card = credit_card.card
	WHERE  EXTRACT(HOUR FROM date)>=7
		AND EXTRACT(HOUR FROM date)<9
	ORDER BY amount DESC
	LIMIT 100;	
	
--Create view for merchants of the 100 highest transactions
CREATE VIEW merchants_highest_100 AS
SELECT 
	COUNT(highest_100.transation_id),
	merchant_category.merchant_category_name
FROM highest_100
LEFT JOIN merchant
ON merchant.merchant_id = highest_100.merchant_id
LEFT JOIN merchant_category
ON merchant_category.merchant_category_id = merchant.merchant_category_id
GROUP BY merchant_category.merchant_category_name;

	
	

--Create view for couting total transactions
CREATE VIEW total_transactions AS
SELECT 
	COUNT(*) 
FROM transaction
LEFT JOIN credit_card 
ON transaction.card = credit_card.card;

--Create view for couting transactions between 7:00 am and 9:00 am.
SELECT 
	COUNT(*) 
FROM transaction
LEFT JOIN credit_card 
ON transaction.card = credit_card.card
WHERE EXTRACT(HOUR FROM date)>=7
	AND EXTRACT(HOUR FROM date)<9;

--Create view for top 5 merchants prone to being hacked using small transactions.
CREATE VIEW top_5_hacked_merchants AS
SELECT 
	merchant.merchant_name,
	COUNT(transaction.amount) AS num_of_transactions
FROM transaction
LEFT JOIN merchant
ON transaction.merchant_id = merchant.merchant_id
WHERE amount<2
GROUP BY merchant.merchant_name
ORDER BY num_of_transactions DESC
LIMIT 5;

	