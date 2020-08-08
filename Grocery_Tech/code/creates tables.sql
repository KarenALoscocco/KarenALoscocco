-- Create the database
CREATE DATABASE Grocery;

-- Create 8 tables of entities and their composite attributes.

-- Table for both buyer address and store address
CREATE TABLE Grocery.Addresses(
	address_id INT NOT NULL,
	state VARCHAR(50) NOT NULL,
	city VARCHAR(50) NOT NULL,
	street VARCHAR(255) NOT NULL,
	house_number VARCHAR(50) NOT NULL,
	zipcode VARCHAR(5) NOT NULL CHECK(length(Zipcode)=5),
	PRIMARY KEY(address_id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create entity USER; Deliverer and Manager will not have separate tables
CREATE TABLE Grocery.USER(
	username VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL CHECK(REGEXP_LIKE(email,'^[a-zA-Z0-9]@[a-zA-Z0-9]\\.[a-zA-Z0-9]')=1),
	user_type ENUM('Buyer','Deliverer','Manager') NOT NULL,
	PRIMARY KEY(username)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create Table Buyer, it's a subclass of USER
CREATE TABLE Grocery.Buyer(
	username VARCHAR(50) NOT NULL,
	phone VARCHAR(10) NOT NULL CHECK(length(phone)=10) ,
	address INT,
	defaut_payment VARCHAR(50) NOT NULL,
	PRIMARY KEY(username),
	UNIQUE(address),
	CONSTRAINT FK_Username FOREIGN KEY(username)
		REFERENCES USER(username) ON DELETE CASCADE
	    ON UPDATE CASCADE,
	CONSTRAINT FK_BuyerAddress FOREIGN KEY(address)
		REFERENCES Addresses(address_id) ON DELETE SET NULL
	    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create CARD of Buyer, it's a composite attribute of Buyer
CREATE TABLE Grocery.Payment (
	payment_name VARCHAR(50) NOT NULL,
	account_number VARCHAR(50) NOT NULL,
	routing_number VARCHAR(50) NOT NULL,
	username VARCHAR(50) NOT NULL,
	PRIMARY KEY (username,payment_name),
	CONSTRAINT FK_User FOREIGN KEY(username)
		REFERENCES Buyer(username)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create System info
CREATE TABLE Grocery.SystemInformation(
	system_id INT NOT NULL,
	user_codes VARCHAR(50) NOT NULL,
	PRIMARY KEY(system_id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;




-- Create entity Store
CREATE TABLE Grocery.GroceryStore(
	address INT NOT NULL,
	store_name VARCHAR(50) NOT NULL,
	opening_time TIME NOT NULL,
	closing_time TIME NOT NULL,
	phone VARCHAR(10) NOT NULL CHECK(length(phone) = 10),
	PRIMary KEY (address),
	CONSTRAINT FK_StoreAddress FOREIGN KEY(address)
		REFERENCES Addresses(address_id) ON DELETE CASCADE
	    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create entity Item
CREATE TABLE Grocery.Item(
	item_id VARCHAR(50) NOT NULL,
	item_name VARCHAR(50) NOT NULL,
	quantity INT NOT NULL,
	food_group VARCHAR(50) NOT NULL,
	descriptions VARCHAR(255) NOT NULL,
	exp_ate DATE NOT NULL,
	listed_price FLOAT NOT NULL,
	wholesale_price FLOAT NOT NULL,
	PRIMARY KEY(item_id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create entity ORDER
CREATE TABLE Grocery.Order(
	order_id VARCHAR(50) NOT NULL,
	delivery_date DATE NOT NULL,
	delivery_instructions VARCHAR(255),
	PRIMARY KEY (order_id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Now create 6 tables of 6 relations between entities
-- CREATE relation between manager and store
CREATE TABLE Grocery.manages(
	manager_username VARCHAR(50) NOT NULL,
	store_address INT NOT NULL,
	UNIQUE(store_address),
	PRIMARY KEY (manager_username),
	CONSTRAINT FK_Manager FOREIGN KEY(manager_username)
		REFERENCES USER(username)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE,
	CONSTRAINT FK_Store FOREIGN KEY(store_address)
		REFERENCES GroceryStore(address)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;















-- Create relation between GroceryStore and Item
CREATE TABLE Grocery.sold_at(
store_address INT NOT NULL,
item_id VARCHAR(50) NOT NULL,
in_stock BOOLEAN NOT NULL,
PRIMARY KEY(store_address,item_id),
CONSTRAINT FK_Item FOREIGN KEY(item_id)
	REFERENCES Item(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT FK_Store2 FOREIGN KEY(store_address)
	REFERENCES GroceryStore(address)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create relation between ORDER and Item
CREATE TABLE Grocery.select_item(
order_id VARCHAR(50) NOT NULL,
item_id VARCHAR(50) NOT NULL,
quantity INT CHECK (quantity >= 0),
PRIMARY KEY (order_id,item_id),
CONSTRAINT FK_Item2 FOREIGN KEY(item_id)
	REFERENCES Item(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT FK_Store4 FOREIGN KEY(order_id)
	REFERENCES `Order`(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- Create relation between ORDER and GroceryStore
CREATE TABLE Grocery.order_from(
order_id VARCHAR(50) NOT NULL,
store_address INT NOT NULL,
PRIMARY KEY (order_id),
CONSTRAINT FK_Order FOREIGN KEY(order_id)
	REFERENCES `Order`(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT FK_Store3 FOREIGN KEY(store_address)
	REFERENCES GroceryStore(address)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- CREATE relation between ORDER and Buyer
CREATE TABLE Grocery.orderedby(
buyer_username VARCHAR(50) NOT NULL,
order_id VARCHAR(50) NOT NULL,
PRIMARY KEY (order_id),
CONSTRAINT FK_Order2 FOREIGN KEY(order_id)
	REFERENCES `Order`(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT FK_Buyer FOREIGN KEY(buyer_username)
	REFERENCES Buyer(username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;




-- Create relation between DELIVERY and ORDER
CREATE TABLE Grocery.delivered_by(
deliverer_username VARCHAR(50) NOT NULL,
order_id VARCHAR(50) NOT NULL,
isDelivered BOOLEAN NOT NULL,
deliverytime TIME NOT NULL,
PRIMARY KEY(order_id),
CONSTRAINT FK_Order3 FOREIGN KEY(order_id)
	REFERENCES `Order`(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT FK_User2 FOREIGN KEY(deliverer_username)
	REFERENCES USER(username)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8;
