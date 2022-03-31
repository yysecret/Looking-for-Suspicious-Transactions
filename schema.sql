CREATE TABLE card_holder
	(card_holder_id INT PRIMARY KEY,
	card_holder_name VARCHAR);

SELECT * FROM card_holder;

CREATE TABLE credit_card(
	card VARCHAR(20) PRIMARY KEY,
	card_holder_id INT,
	FOREIGN KEY (card_holder_id) REFERENCES card_holder (card_holder_id)
);

SELECT * FROM credit_card;

CREATE TABLE merchant_category(
	merchant_category_id INT PRIMARY KEY,
	merchant_category_name VARCHAR);

SELECT * FROM merchant_category;
	

CREATE TABLE merchant(
	merchant_id INT PRIMARY KEY,
	merchant_name VARCHAR,
	merchant_category_id INT,
	FOREIGN KEY (merchant_category_id) REFERENCES merchant_category(merchant_category_id)
);

SELECT * FROM merchant;

CREATE TABLE transaction(
	transation_id INT PRIMARY KEY,
	date TIMESTAMP,
	amount DECIMAL,
	card VARCHAR(20),
	merchant_id INT,
	FOREIGN KEY (card) REFERENCES credit_card(card),
	FOREIGN KEY (merchant_id) REFERENCES merchant(merchant_id)
);

SELECT * FROM transaction;


