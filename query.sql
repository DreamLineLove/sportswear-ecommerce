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
Objective: Retrieve all members who are older than 25 and whose member level is
greater than 1. 
Display their first and last names, member level, age, and date of birth, sort
in descending order by their age.
*/
SELECT CONCAT(firstName, ' ', lastName) as `Member`, membershipLevel as `Level`,
YEAR(CURDATE())-YEAR(dateOfBirth) as Age, dateOfBirth as `Date of Birth`
FROM Members
WHERE YEAR(CURDATE())-YEAR(dateOfBirth) > 25 and membershipLevel > 1
ORDER BY Age DESC;

-- Query 2: Must have at least one JOIN
/*
Objective: Retrieve the member IDs and member points of all customers.
Display the customer ID, first and last names, member ID, and member points.
*/
SELECT c.customerID as `Customer ID`, CONCAT(c.firstName, ' ', c.lastName) as Name, 
memberID as `Member ID`, memberPoints as `Points`
FROM Customer c INNER JOIN Members m ON c.customerID = m.customerID;

-- Query 3: Must use aggregate functions,

-- Saw Say Hae Khu

/*
Objective: Retrieve customers whose first name or last name starts with J for promotion purposes.
Display first name, last name, and customerID.
*/
SELECT customerID, firstName, lastName
FROM Customer
WHERE firstName LIKE 'P%' OR lastName LIKE 'P%';

-- Query 2: Must have at least one JOIN
/*
Objective: Retrieve orders that were made in April.
Display the customer ID, first name, last name, order ID, purchase time, purchase
status, and company name.
*/
SELECT 
    c.customerID,
    c.firstName,
    c.lastName,
    o.orderID,
    o.purchaseTime,
    o.purchaseStatus,
    o.companyName
FROM Customer AS c
JOIN Orders AS o
    ON c.customerID = o.customerID
WHERE MONTH(o.purchaseTime) = 4;