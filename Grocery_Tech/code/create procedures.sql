DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `addPayment`(IN usename VARCHAR(64),IN paymentname VARCHAR(64), IN accountnum VARCHAR(64), IN routingnum VARCHAR(64),IN isdefault VARCHAR(16))
BEGIN
	INSERT INTO payments
    VALUES(username,paymentname,accountnum,routingnum); 
    UPDATE buyer
    SET default_payment = (SELECT payment_name FROM payments 
    WHERE isdefault = 'yes');
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `addToCart`(IN itemname VARCHAR(64),IN itemquantity INT)
BEGIN
	DROP VIEW IF EXISTS cart;
    CREATE VIEW cart AS(
	SELECT item_name,description, listed_price, 0 as cartquantity,
    CASE 
		WHEN item_id IN (SELECT item_id FROM soldat WHERE store_id = storeid) THEN 'yes'
        ELSE 'no'
	END AS 'InStock'
    FROM item);
    UPDATE cart 
    SET cartquantity = itemquantity;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `BuyerRegisteration`(IN usertypeinput VARCHAR(16), IN usernameinput VARCHAR(64), IN firstnameinput VARCHAR(64),
IN lastnameinput VARCHAR(64), IN passwordinput VARCHAR(64), IN emailinput VARCHAR(256),IN phone VARCHAR(16),
IN state VARCHAR(16), IN city VARCHAR(64),IN street VARCHAR(256), IN housenum VARCHAR(64), IN zipcode VARCHAR(16))
BEGIN
	INSERT INTO userr
	VALUES(usernameinput,passwordinput,usertypeinput,emailinput,firstnameinput,lastnameinput);
	# Insert into Address table
    SET @addressid = (SELECT MAX(id)+1 FROM address);
	INSERT INTO address
	VALUES(@addressid,housenum,street,city,state,zipcode);
    # if the user type is a buyer
	INSERT INTO buyer
	VALUES(username,phone,@addressid);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `checkOrderQuantity`(IN itemname varchar(64))
BEGIN
	SELECT 
	CASE WHEN 
    EXISTS(
	SELECT quantity, itemquantity 
    FROM item as a INNER JOIN cart as c
    ON a.item_name = c.item_name
    WHERE itemquantity > quantity) THEN 0
    ELSE 1
    END;
    
   
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `deductInventory`(IN itemname INT(2))
BEGIN
    SET @quantity = (SELECT quantity - itemquantity FROM cart as c INNER JOIN item as i WHERE i.item_name = c.item_name AND i.item_name = 'lemon juice') ;
    
    UPDATE item
    SET quantity = @quantity
    WHERE item_name = itemname;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `DeleteBuyerAccount`(IN busername VARCHAR(64))
BEGIN
	DELETE 
    FROM userr
    WHERE userr.username = busername AND userr.user_type = 'buyer'
    ;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `DeleteDelivererAccount`(IN dusername VARCHAR(64) )
BEGIN
	DELETE 
	FROM userr
	WHERE userr.username = dusername AND userr.user_type = 'deliverer'
	;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `DeleteManagerAccount`(IN musername VARCHAR(64) )
BEGIN
	DELETE 
	FROM userr
	WHERE userr.username = musername AND userr.user_type = 'manager'
	;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `DelivererCheck`(IN confirmation VARCHAR(64))
BEGIN
	SELECT 
	CASE
		WHEN confirmation = (SELECT DISTINCT user_codes FROM systeminformation WHERE system_id = 1 ) THEN 1 
        ELSE 0
	END;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `delivererRegisteration`(IN usertypeinput VARCHAR(16), IN usernameinput VARCHAR(64), IN firstnameinput VARCHAR(64),
IN lastnameinput VARCHAR(64), IN passwordinput VARCHAR(64), IN emailinput VARCHAR(256))
BEGIN 
	INSERT INTO userr
	VALUES(usernameinput,passwordinput,usertypeinput,emailinput,firstnameinput,lastnameinput);

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `DelivererUpdateOrderStatus`(IN orderid INT(8))
BEGIN
	UPDATE deliveredby
	SET deliveredby.is_delivered = 1
	WHERE deliveredby.order_id = orderid 
	;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `findItems`(IN storeid INT(2), IN foodgroup VARCHAR(64))
BEGIN
	DROP TABLE IF EXISTS cart;
    CREATE TABLE cart AS (
	SELECT item_name, `description`,exp_date, listed_price, 0 AS itemquantity,
    CASE 
		WHEN item_id IN (SELECT item_id FROM soldat WHERE store_id = storeid) THEN 'yes'
        ELSE 'no'
	END AS 'Instock'
    FROM item
    WHERE item_id IN (SELECT item_id FROM item WHERE food_group = foodgroup)) ;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `getOrderHistory`(IN usernameinput VARCHAR(64))
BEGIN
	SELECT store_name,order_id,order_placed_date,SUM(quantity*listed_price),SUM(quantity),isdelivered
    FROM orderfrom INNER JOIN orderr ON orderfrom.order_id = orderr.order_id
    INNER JOIN selectitem ON selectitem.order_id = orderr.order_id
    INNER JOIN item ON selectitem.item_id = item.item_id
    INNER JOIN deliveredby ON orderr.order_id = deliveredby.order_id AND username = usernameinput;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `getReceipt`(IN orderid INT(2), IN payname VARCHAR(64))
BEGIN
	SELECT order_id, payment_name,first_name,last_name,SUM(cartquantity) totalItem, order_placed_time, delivery_time
    FROM orderr INNER JOIN orderedby ON oderr.order_id = oderedby.order_id AND payment_name = payname
    INNER JOIN userr ON uerr.username = orderedby.username 
    INNER JOIN selectitem ON selectitem.order_id = orderedby.order_id;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `Inventory`(IN musername VARCHAR(64))
BEGIN

	SELECT item.food_group `FoodGroup`
		, item.item_name `ItemName`
		, item.Description
		, item.Quantity
		, item.listed_price `RetailPrice`
		, item.wholesale_price `WholesalePrice`
		, item.exp_date `ExpirationDate`
	FROM manages
	JOIN address 
		ON manages.store_address = address.id
	JOIN grocerystore 
		ON address.id = grocerystore.address_id
	JOIN soldat
		ON soldat.store_id = grocerystore.store_id
	JOIN item 
		ON soldat.item_id = item.item_id
	WHERE manages.username = musername
    
;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `InventoryTotalItems`(IN musername INT(2))
BEGIN
    
    SELECT SUM(item.quantity) `TotalNumberofItems` 
	FROM manages
	JOIN address 
		ON manages.store_address = address.id
	JOIN grocerystore 
		ON address.id = grocerystore.address_id
	JOIN soldat
		ON soldat.store_id = grocerystore.store_id
	JOIN item 
		ON soldat.item_id = item.item_id
	WHERE manages.username = musername
    
;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ListOfStores`()
BEGIN
	SELECT store_name
		, CONCAT(house_number,' ',street,' ',city,', ',state,' ',zip_code) Address
        , Phone
        , CONCAT(opening_time,' - ',closing_time) Hours 
    FROM grocerystore
    INNER JOIN address
		ON grocerystore.address_id = address.id
;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `Login`(IN userinput VARCHAR(64), IN passwordinput VARCHAR(64))
BEGIN
	SELECT 
	CASE
		WHEN passwordinput = (SELECT `password` FROM userr WHERE username = userinput) THEN 1 
        ELSE 0
	END;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ManagerCheck`(IN confirmation VARCHAR(64))
BEGIN
	SELECT 
	CASE
		WHEN confirmation = (SELECT DISTINCT user_codes FROM systeminformation WHERE system_id = 0 ) THEN 1 
        ELSE 0
	END;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ManagerRegisteration`(IN usertypeinput VARCHAR(16), IN usernameinput VARCHAR(64), IN firstnameinput VARCHAR(64),
IN lastnameinput VARCHAR(64), IN passwordinput VARCHAR(64), IN emailinput VARCHAR(256), IN storeaddressid INT(2))
BEGIN 
	INSERT INTO userr
	VALUES(usernameinput,passwordinput,usertypeinput,emailinput,firstnameinput,lastnameinput);
    
    INSERT INTO manages
    VALUES(usernameinput, storeaddressid);
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ManagerViewOrders`(IN musername VARCHAR(64))
BEGIN

SELECT grocerystore.store_name `StoreName`
	, CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) AS `StoreAddress`
    , orderr.order_id `OrderId`
    , orderr.order_placed_date `OrderPlacedDate`
    , SUM(selectitem.quantity * item.listed_price) `TotalPrice`
	, SUM(selectitem.quantity) `TotalNumberOfItems`
    , buyerinfo.DeliveryAddress
#select *
FROM manages
JOIN address 
	ON manages.store_address = address.id
JOIN grocerystore 
	ON address.id = grocerystore.address_id
JOIN orderfrom 
	ON orderfrom.store_address_id = grocerystore.store_id
JOIN orderr
	ON orderfrom.order_id = orderr.order_id
JOIN selectitem 
	ON selectitem.order_id = orderr.order_id
JOIN item
	ON selectitem.item_id = item.item_id
JOIN deliveredby
	ON orderr.order_id = deliveredby.order_id
JOIN (SELECT orderedby.order_id
			, CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) `DeliveryAddress`
        FROM orderedby
		JOIN buyer
			ON buyer.username = orderedby.buyer_username
		JOIN address 
			ON address.id = buyer.address_id
	) buyerinfo
		ON orderr.order_id = buyerinfo.order_id
WHERE manages.username = musername
GROUP BY grocerystore.store_name
	, CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) 
    , orderr.order_id 
    , orderr.order_placed_date 
    , buyerinfo.DeliveryAddress
;


END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `placeOrder`(IN username VARCHAR(64),IN storeid INT(2),IN orderquantity INT,
IN deliverytime VARCHAR(16),IN deliveryinstructions VARCHAR(256),IN itemname INT(2))
BEGIN
	CREATE VIEW checkout AS (SELECT item_name,listed_price,itemquantity FROM cart);
    
    SET @neworderid = max(order_id)+1;
    INSERT INTO orderr
    VALUES(neworderid,deliveryinstructions,deliverytime,SUBSTRING(NOW(),1,10), SUBSTRING(NOW(),11,5));
    
    SET @deliverer = (SELECT username from userr ORDER BY RAND() LIMIT 1);
    INSERT INTO deliveredby
    VALUES(@neworderid,@deliverer,'pending',null,null);
    
    INSERT INTO orderedby
    VALUES(@neworderid,username);
    
    INSERT INTO orderfrom
    VALUES(storeid,@neworderid);
    
    SET @itemid = (SELECT item_id FROM item WHERE item_name = itemname);
    SET @itemquantity = (SELECT itemquantity FROM cart WHERE item_name = itemname);
    INSERT INTO selectitem
    VALUES(@itemid,@itemquantity,@neworderid);
    
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `RevenueReport`(IN musername VARCHAR(64))
BEGIN

	SELECT grocerystore.store_name `StoreName`
		, SUM(selectitem.quantity * item.listed_price) `TotalProfit`
		, SUM(selectitem.quantity) `NumberOfItemsSold`
	FROM manages
	JOIN address 
		ON manages.store_address = address.id
	JOIN grocerystore 
		ON address.id = grocerystore.address_id
	JOIN orderfrom 
		ON orderfrom.store_address_id = grocerystore.store_id
	JOIN orderr
		ON orderfrom.order_id = orderr.order_id
	JOIN selectitem 
		ON selectitem.order_id = orderr.order_id
	JOIN item
		ON selectitem.item_id = item.item_id
	JOIN deliveredby
		ON orderr.order_id = deliveredby.order_id
	JOIN (SELECT orderedby.order_id
				, CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) `DeliveryAddress`
			FROM orderedby
			JOIN buyer
				ON buyer.username = orderedby.buyer_username
			JOIN address 
				ON address.id = buyer.address_id
		) buyerinfo
			ON orderr.order_id = buyerinfo.order_id
	WHERE manages.username = musername
		AND (YEAR(orderr.order_placed_date) = 2018 OR YEAR(orderr.order_placed_date) = 2019)
	GROUP BY grocerystore.store_name
	;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `showPayments`(IN usernameinput VARCHAR(64))
BEGIN
	SELECT payment_name, account_number,routing_number,
    CASE WHEN payment_name in (SELECT default_payment FROM buyer) THEN 'yes'
    ELSE 'no'
    END
    FROM payments
    where username = usernameinput;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `Store_Address`()
BEGIN

SELECT grocerystore.store_name `Grocery Store`
    , CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) AS `Grocery Store Address`
FROM grocerystore
LEFT JOIN address
	ON grocerystore.address_id = address.id
;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `updateBuyerAccount`(IN usertypeinput VARCHAR(16), IN usernameinput VARCHAR(64), IN firstnameinput VARCHAR(64),
IN lastnameinput VARCHAR(64), IN emailinput VARCHAR(256),IN phone VARCHAR(16),
IN state VARCHAR(16), IN city VARCHAR(64),IN street VARCHAR(256), IN housenum VARCHAR(64), IN zipcode VARCHAR(16))
BEGIN
	UPDATE `userr`
	SET username = usernameinput, password = passwordinput,user_type = usertypeinput,
    email = emailinput, first_name = firstnameinput,last_name = lastnameinput
    WHERE username = usernameinput;
    
	UPDATE address
	SET house_number = housenum,street = street,city = city,state = state,zip_code = zipcode
    WHERE username = usernameinput;
    
	UPDATE buyer
	SET phone = phone
    WHERE username = usernameinput;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `UpdateDelivererAccount_Email`(IN dusername VARCHAR(64), IN demail VARCHAR(64))
BEGIN

UPDATE userr
SET userr.email = demail
WHERE userr.username = dusername AND userr.user_type = 'deliverer'
;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `UpdateManagerAccount`(IN musername VARCHAR(64), IN memail VARCHAR(64), IN mphone FLOAT, IN mstore VARCHAR(64), IN maddress VARCHAR(64))
BEGIN

UPDATE userr
SET userr.email = memail
WHERE userr.username = musername 
	AND userr.user_type = 'manager'
	AND userr.email != memail
;

UPDATE manages 
LEFT JOIN grocerystore
	ON manages.store_address = grocerystore.address_id
SET grocerystore.Phone = mphone
WHERE manages.username = musername
	AND grocerystore.Phone != mphone
;  

UPDATE manages
LEFT JOIN grocerystore
	ON manages.store_address = grocerystore.address_id
LEFT JOIN address
	ON grocerystore.address_id = address.id
SET grocerystore.store_name = mstore
WHERE manages.username = musername
	AND grocerystore.store_name != mstore
;

END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `viewBuyerAccountInfo`(IN usernameinput VARCHAR(64))
BEGIN
## View Buyer Account Info
SELECT first_name,last_name,username,email FROM userr
WHERE username = usernameinput;

SELECT phone,account_number,routing_number FROM buyer as b
INNER JOIN payments as p
ON b.default_payment = p.payment_name AND b.username = usernameinput;

SELECT store_name FROM buyer as b
INNER JOIN grocerystore as g
ON g.store_id = b.default_store_id
and username = usernameinput;

SELECT street FROM address as a
INNER JOIN grocerystore as g
INNER JOIN buyer as b
ON b.username = usernameinput
AND b.default_store_id = g.store_id 
AND g.address_id=a.id;

SELECT house_number,street,city,state,zip_code FROM address as a
INNER JOIN buyer as b
ON b.username = usernameinput and b.address=a.address_id;
/*
SELECT state FROM addresses as a
INNER JOIN buyer as b
ON b.username = usernameinput and b.address=a.address_id;
SELECT house_number FROM addresses as a
INNER JOIN buyer as b
ON b.username = usernameinput and b.address=a.address_id;
SELECT zipcode FROM addresses as a
INNER JOIN buyer as b
ON b.username = usernameinput and b.address=a.address_id;

*/
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ViewDelivererAccountInfo`(IN dusername VARCHAR(64))
BEGIN

SELECT first_name, last_name, username, email
FROM userr
WHERE userr.username = dusername AND userr.user_type = 'deliverer'
;

END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ViewDelivererAssignmentDetails`(IN orderid INT(8))
BEGIN

SELECT DISTINCT orderr.order_placed_time `Order Place`
	, CASE WHEN orderr.delivery_time = 'ASAP' 
		   THEN orderr.delivery_time
		   ELSE CONCAT(CAST(orderr.delivery_time AS CHAR), ' hrs')
		   END AS `Delivery Time`
	, CASE WHEN deliveredby.is_delivered = 0 THEN 'Pending'
				WHEN deliveredby.is_delivered = 1 THEN 'Completed'
                ELSE deliveredby.is_delivered
                END AS 'Status'
    , CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) AS `Buyer Address`
	, grocerystore.store_name `Store Name` 
    FROM deliveredby
	LEFT JOIN orderfrom 
		ON orderfrom.order_id = deliveredby.order_id
	LEFT JOIN orderr
		ON orderfrom.order_id = orderr.order_id
	LEFT JOIN grocerystore 
		ON orderfrom.store_address_id = grocerystore.store_id
	LEFT JOIN selectitem 
		ON selectitem.order_id = deliveredby.order_id
	LEFT JOIN item 
		ON selectitem.item_id = item.item_id
	LEFT JOIN orderedby 
		ON orderedby.order_id = orderr.order_id
	LEFT JOIN buyer
		ON buyer.username = orderedby.buyer_username
	LEFT JOIN address 
		ON buyer.address_id = address.id
    
	WHERE orderfrom.order_id = orderid
;

END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ViewDelivererAssignmentItemDetails`(IN orderid INT(8) )
BEGIN

SELECT item.item_name `Item Name`
    , selectitem.Quantity
    FROM deliveredby
	LEFT JOIN orderfrom 
		ON orderfrom.order_id = deliveredby.order_id
	LEFT JOIN orderr 
		ON orderfrom.order_id = orderr.order_id
	LEFT JOIN grocerystore 
		ON orderfrom.store_address_id = grocerystore.store_id
	LEFT JOIN selectitem 
		ON selectitem.order_id = deliveredby.order_id
	LEFT JOIN item 
		ON selectitem.item_id = item.item_id
	LEFT JOIN orderedby 
		ON orderedby.order_id = orderr.order_id
	LEFT JOIN buyer
		ON buyer.username = orderedby.buyer_username
	LEFT JOIN address 
		ON buyer.address_id = address.id
    
	WHERE orderfrom.order_id = orderid
;

END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ViewDelivererAssignments`(IN dusername VARCHAR(64))
BEGIN
	SELECT CASE WHEN deliveredby.is_delivered = 0 THEN 'Pending'
				WHEN deliveredby.is_delivered = 1 THEN 'Completed'
                ELSE deliveredby.is_delivered
                END AS 'Status'
		, grocerystore.store_name `Store Name` 
		, orderfrom.order_id `Order ID`
		, orderr.order_placed_date `Date`
		, orderr.order_placed_time `Time Order Made`
		, CASE WHEN orderr.delivery_time = 'ASAP' 
			   THEN orderr.delivery_time
			   ELSE CONCAT(CAST(orderr.delivery_time AS CHAR), ' hrs')
			   END AS `Time of Delivery`
		, SUM(selectitem.quantity * item.listed_price) `Order Price`
		, SUM(selectitem.quantity) `Total Number Of Items` 
	FROM deliveredby
	LEFT JOIN orderfrom 
		ON orderfrom.order_id = deliveredby.order_id
	LEFT JOIN orderr
		ON orderfrom.order_id = orderr.order_id
	LEFT JOIN grocerystore 
		ON orderfrom.store_address_id = grocerystore.store_id
	LEFT JOIN selectitem 
		ON selectitem.order_id = deliveredby.order_id
	LEFT JOIN item 
		ON selectitem.item_id = item.item_id
	WHERE deliveredby.deliverer_username = dusername
	GROUP BY deliveredby.order_id
    ORDER BY deliveredby.is_delivered
;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`gtadmin`@`%` PROCEDURE `ViewManagerAccountInfo`(IN musername VARCHAR(64))
BEGIN

SELECT userr.first_name `First Name`
	, userr.last_name `Last Name`
    , userr.Username
    , grocerystore.Phone
    , grocerystore.store_name `Managed Grocery Store`
	, CONCAT(address.house_number, ' ', address.street) AS `Grocery Store Address`
    #, CONCAT(address.house_number, ' ', address.street, ' ', address.city, ', ', address.state, ' ', address.zip_code) AS `Grocery Store Address`
	, userr.Email
FROM userr
LEFT JOIN manages 
	ON userr.username = manages.username
LEFT JOIN grocerystore
	ON manages.store_address = grocerystore.address_id
LEFT JOIN address
	ON grocerystore.address_id = address.id
WHERE userr.username = musername AND 
userr.user_type = 'manager'
;

END$$
DELIMITER ;
