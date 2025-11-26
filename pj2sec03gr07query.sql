use sec03gr07db;

-- Junrui Mao

/* Objective: Retrieve all members whose MemberPoints are greater than 1000 and 
have MembershipLevel as 'Level 2'. Display MemberID, FirstName, and LastName. */
SELECT MemberID, FirstName, LastName
FROM Members
WHERE MemberPoints > 1000 AND MembershipLevel = 2;

/* Objective: Retrieve all members who have redeemed rewards. Display MemberID, FirstName, 
LastName, RewardID, and ExpirationDate. */
SELECT M.MemberID, M.FirstName, M.LastName, R.RewardID, Re.ExpirationDate
FROM Members M
INNER JOIN Redeem R ON M.MemberID = R.MemberID
INNER JOIN Reward Re ON R.RewardID = Re.RewardID;

-- Zwe Nyan Zaw

-- Query 1: Must have a WHERE clause with at least two or more conditions.
/*
Objective: To retrieve all products whose recycle percentage is at least 50% and whose unit
price is at most 500 baht. (For marketing department)
*/
SELECT productCode, recyclePercentage AS `Recycle Percentage`, unitPrice AS `Unit Price`
FROM Product
WHERE recyclePercentage >= 50 AND unitPrice <= 500;

-- SQL Query 2: Must use SQL built-in functions, for example, string function, numerical function, or date function.
/*
Objective: To display the combined firstname, lastname, member level, and age (where applicable)
of all members, ordered by their name alphabetically.
*/
SELECT CONCAT(firstName, ' ', lastName) AS `Member`, membershipLevel AS `Level`,
YEAR(CURDATE())-YEAR(dateOfBirth) as Age
FROM Members
ORDER BY Member;

-- Query 3: Must use aggregate functions, for example, SUM, AVG, MIN, MAX, with GROUP BY and HAVING
/*
Objective: To display the number of orders each customer has made if the total amount purchased is
at least 3000 baht. 
*/
SELECT c.customerID AS `Customer ID`, COUNT(o.orderID) AS `No. of Orders`,  SUM(p.unitPrice * ca.quantity) AS
`Total Amount`
FROM Orders o
INNER JOIN Cart ca ON o.orderID = ca.orderID
INNER JOIN Customer c ON o.customerID = c.customerID
INNER JOIN Product p ON p.productCode = ca.productCode
GROUP BY c.customerID
HAVING SUM(p.unitPrice * ca.quantity) >= 3000;

-- Query 4: Must have at least one INNER JOIN
/*
Objective: To retrieve all voucher type rewards along with the voucher's season, and required level
to redeem that voucher. Display also the voucherCode, the discount percentage, and expiration date. 
Sort by the expiration date.
*/
SELECT v.rewardID, 
r.season AS `Season`, 
r.levelRequired AS `Level`, 
v.voucherCode AS `Voucher Code`, 
v.percentDiscount AS `% Discount`,
DATE(r.expirationDate) AS `Expires`
FROM Voucher v
INNER JOIN Reward r ON v.rewardID = r.rewardID
ORDER BY Expires;

-- Query 5: Must use any type of OUTER JOIN
/*
Objective: To retrieve all products which have not been purchased so far by anyone. Display the
product code, type, unit price, and orderID (no order).
*/
SELECT p.productCode, p.productType, p.unitPrice, c.orderID
FROM Product p
LEFT OUTER JOIN Cart c ON c.productCode = p.productCode
WHERE c.orderID IS NULL;

-- Saw Say Hae Khu

/*
Objective: Retrieve Members who have redeemed a special event A reward (rewardID = 6)successfully
Display memberID, full name, rewardID, Season and redeemedDate.
*/
-- WEHRE CLAUSE
SELECT m.memberID, m.firstName, m.lastName,
       r.RewardID, r.Season, re.redeemedDate
FROM Redeem re
JOIN Members m ON re.MemberID = m.memberID AND re.CustomerID = m.customerID
JOIN Reward r ON r.RewardID = re.RewardID
WHERE re.redeemStatus = 1 and re.RewardID = 6 ;


/*
Objective: Retrieve orders that were made in April.
Display the customer ID, first name, last name, order ID, purchase time, and purchase
status.
*/
-- BUILT-IN FUNCTIONS
SELECT c.customerID,c.firstName,c.lastName,o.orderID,    o.purchaseTime,o.purchaseStatus
FROM Customer AS c
JOIN Orders AS o
ON c.customerID = o.customerID
WHERE MONTH(o.purchaseTime) = 4;

/*
Objective: Retrieve members who never made orders.
Display memberID, full name.
*/
-- LEFT OUTER JOIN
SELECT m.memberID, m.firstName, m.lastName
FROM Members m
LEFT JOIN Orders o ON m.customerID = o.customerID
WHERE o.orderID IS NULL;

/*
Objective: Retrieve members whose points are above average membership points.
Display memberID, full name and membership points.
*/
-- AGGREGATE FUNCTION

SELECT memberID, firstName, lastName, memberPoints
FROM Members
WHERE memberPoints > (
    SELECT AVG(memberPoints) FROM Members
)
ORDER BY memberPoints DESC;

/*
Objective: Retrieve orders which are still in the process of delivery.
Display  deliveryID, orderID, customer’s full name, estimatedDeliveryDate, deliveryStatus.
*/
--  INNER JOIN

SELECT d.deliveryID, o.orderID, c.firstName, c.lastName, d.estimatedDeliveryDate, d.deliveryStatus
FROM Delivery d
JOIN Orders o ON d.orderID = o.orderID
JOIN Customer c ON o.customerID = c.customerID
WHERE d.deliveryStatus = "Pending"
ORDER by d.estimatedDeliveryDate;



