CREATE DATABASE IF NOT EXISTS sec03gr07db;
use sec03gr07db;

DROP TABLE IF EXISTS Redeem;
DROP TABLE IF EXISTS Voucher;
DROP TABLE IF EXISTS Offer;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Reward;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Reward (
    RewardID        INT,         
    Season          NVARCHAR(50) NOT NULL,     
    PointsRequired  INT NOT NULL,     
    ExpirationDate  DATETIME NOT NULL,            
    LevelRequired   INT NOT NULL,    
    CONSTRAINT PK_Reward PRIMARY KEY (RewardID),
    CHECK (LevelRequired >= 1 AND LevelRequired <= 4)
);

CREATE TABLE Voucher (
    RewardID INT, 
    VoucherCode VARCHAR(30) UNIQUE NOT NULL, 
    PercentDiscount INT NOT NULL,
    CONSTRAINT PK_Voucher PRIMARY KEY (RewardID), 
    CONSTRAINT FK_Voucher_Reward FOREIGN KEY (RewardID) REFERENCES Reward(RewardID)  
);

CREATE TABLE Offer (
    RewardID INT,  
    PartnerOrganization NVARCHAR(100) NOT NULL, 
    rDescription NVARCHAR(255) NOT NULL, 
    CONSTRAINT PK_Offer PRIMARY KEY (RewardID),  
    CONSTRAINT FK_Offer_Reward FOREIGN KEY (RewardID) REFERENCES Reward(RewardID)  
);

CREATE TABLE IF NOT EXISTS Customer (
	customerID INT,
    firstName NVARCHAR(100) NOT NULL,
    lastName NVARCHAR(100) NOT NULL,
    emailAddress NVARCHAR(254) NOT NULL,
    phoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (customerID)
);

CREATE TABLE IF NOT EXISTS Members (
	memberID INT,
	customerID INT,
	firstName NVARCHAR(100) NOT NULL,
	lastName NVARCHAR(100) NOT NULL,
	membershipLevel INT NOT NULL,
	memberPoints INT NOT NULL,
	dateOfBirth DATE,
	CONSTRAINT PK_Members PRIMARY KEY (memberID, customerID),
	CONSTRAINT FK_Member_Customer FOREIGN KEY (customerID) REFERENCES customer(customerID),
    CHECK (membershipLevel >= 1 AND membershipLevel <= 4)
);

CREATE TABLE Redeem (
    RewardID INT, 
    MemberID INT,
    CustomerID INT,
    redeemStatus BIT NOT NULL,
    redeemedDate DATETIME,
    CONSTRAINT PK_Redeem PRIMARY KEY (RewardID, MemberID, CustomerID),  
    CONSTRAINT FK_Redeem_Reward FOREIGN KEY (RewardID) REFERENCES Reward(RewardID),
    CONSTRAINT FK_Redeem_Members FOREIGN KEY (MemberID, CustomerID) REFERENCES Members(MemberID, CustomerID),
    CONSTRAINT FK_Redeem_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Orders (
	orderID INT PRIMARY KEY,
	customerID INT,
	phoneNumber VARCHAR(20) NOT NULL,
	emailAddress NVARCHAR(254) NOT NULL,
	purchaseTime DATETIME NOT NULL,
	purchaseStatus BIT NOT NULL,
	companyName NVARCHAR(100),
	TaxID NVARCHAR(20),
	CONSTRAINT FK_Orders_Customer FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Product (
	productCode VARCHAR(20),
    productType NVARCHAR(64) NOT NULL,
    weight INT,
    recyclePercentage INT,
    size varchar(20) NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY (productCode)
);

CREATE TABLE Cart (
	orderID INT,
    productCode VARCHAR(20),
    quantity INT NOT NULL,
    CONSTRAINT PK_Cart PRIMARY KEY (orderID, productCode),
    CONSTRAINT FK_Cart_Orders FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    CONSTRAINT FK_Cart_Product FOREIGN KEY (productCode) REFERENCES Product(productCode)
);

CREATE TABLE Review (
	reviewID INT PRIMARY KEY,
    customerID INT,
    productCode VARCHAR(20),
    reviewTitle NVARCHAR(127) NOT NULL,
    commentText NVARCHAR(255) NOT NULL,
    submissionDate DATETIME NOT NULL,
    rating INT NOT NULL,
    CONSTRAINT FK_Review_Customer FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    CONSTRAINT FK_Review_Product FOREIGN KEY (productCode) REFERENCES Product(productCode),
    CHECK (rating >= 1 AND rating <= 5)
);

CREATE TABLE Delivery (
	deliveryID INT PRIMARY KEY,
    orderID INT,
    deliveryStatus NVARCHAR(63) NOT NULL,
    deliveredTime DATETIME NULL,
    estimatedDeliveryDate DATETIME NOT NULL,
    deliveryFee DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Delivery_Orders FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE Payment (
	paymentID INT PRIMARY KEY,
    orderID INT,
    cardNumber VARCHAR(20) NOT NULL,
    cardholderName NVARCHAR(255) NOT NULL,
    expirationDate DATE NOT NULL,
    CVCCVV VARCHAR(4) NOT NULL,
    zipCode VARCHAR(20) NOT NULL,
    province NVARCHAR(63) NOT NULL,
    city NVARCHAR(63) NOT NULL,
    addressLine NVARCHAR(255) NOT NULL,
    CONSTRAINT FK_Payment_Orders FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

-- Master Tables
INSERT INTO Reward (RewardID, Season, PointsRequired, ExpirationDate, LevelRequired) VALUES
(1, 'Summer 2025', 150, '2025-09-30 23:59:59', 1),
(2, 'Winter 2025', 300, '2025-12-31 23:59:59', 2),
(3, 'Spring 2026', 200, '2026-04-30 23:59:59', 1),
(4, 'Fall 2025', 500, '2025-10-31 23:59:59', 3),
(5, 'New Year 2026', 600, '2026-01-15 23:59:59', 4),
(6, 'Special Event A', 250, '2025-11-20 23:59:59', 1),
(7, 'Special Event B', 350, '2025-12-20 23:59:59', 2),
(8, 'Anniversary', 450, '2026-05-01 23:59:59', 3),
(9, 'Flash Promo', 120, '2025-08-15 23:59:59', 1),
(10, 'VIP Exclusive', 800, '2026-02-28 23:59:59', 4);

INSERT INTO Voucher (RewardID, VoucherCode, PercentDiscount) VALUES
(1, 'SUM2025-15', 15),
(2, 'WIN2025-25', 25),
(5, 'NY2026-30', 30),
(9, 'FLASH15', 15),
(10, 'VIP50', 50),
(3, 'SPR2026-10', 10),
(4, 'FALL2025-20', 20),
(6, 'SPCA2025-12', 12),
(7, 'SPCB2025-18', 18),
(8, 'ANNIV2026-25', 25);

INSERT INTO Offer (RewardID, PartnerOrganization, rDescription) VALUES
(3, '7-Eleven Thailand', 'Free drink with purchase over 100 THB'),
(4, 'Central Group', 'Exclusive fall discount at department stores'),
(6, 'Grab Thailand', 'Discounted delivery fee'),
(7, 'Minor Food Group', 'Promo for participating restaurants'),
(8, 'Adidas Official', 'Anniversary special offer'),
(1, 'Tesco Lotus', 'Special welcome deal for new members'),
(2, 'Big C Supercenter', 'Seasonal discount for Level 2 members'),
(5, 'Foodpanda Thailand', 'New Year delivery promo'),
(9, 'Kerry Express', 'Flash redemption discounted shipping'),
(10, 'Adidas VIP Program', 'Exclusive VIP early access benefits');

INSERT INTO Customer (customerID, firstName, lastName, emailAddress, phoneNumber) VALUES
(1, 'Somchai', 'Wongchai', 'somchai.wc@example.com', '081-234-5678'),
(2, 'Anong', 'Siritorn', 'anong.st@example.com', '089-112-3344'),
(3, 'John', 'Smith', 'john.smith@example.com', '091-889-2200'),
(4, 'Emily', 'Turner', 'emily.t@example.com', '080-220-1144'),
(5, 'Kittisak', 'Boonsri', 'kittisak.bs@example.com', '082-998-1122'),
(6, 'Nichapa', 'Suwan', 'nichapa.sw@example.com', '083-774-6622'),
(7, 'Michael', 'Brown', 'michael.b@example.com', '095-443-2211'),
(8, 'Suda', 'Petchdee', 'suda.pd@example.com', '086-312-5522'),
(9, 'David', 'Nguyen', 'david.ng@example.com', '084-222-9055'),
(10, 'Preeda', 'Chanakul', 'preeda.ck@example.com', '089-600-7788');

INSERT INTO Members (memberID, customerID, firstName, lastName, membershipLevel, memberPoints, dateOfBirth) VALUES
(1, 1, 'Somchai', 'Wongchai', 1, 450, '1990-05-12'),       -- Level 1: 450 pts
(2, 2, 'Anong', 'Siritorn', 2, 1800, NULL),                 -- Level 2: 1800 pts
(3, 3, 'John', 'Smith', 1, 700, '1986-03-08'),              -- Level 1: 700 pts
(4, 4, 'Emily', 'Turner', 3, 5200, NULL),                   -- Level 3: 5200 pts
(5, 5, 'Kittisak', 'Boonsri', 2, 2500, '1998-09-22'),        -- Level 2: 2500 pts
(6, 6, 'Nichapa', 'Suwan', 4, 14300, NULL),                 -- Level 4: 14300 pts
(7, 7, 'Michael', 'Brown', 1, 900, '1995-11-15'),            -- Level 1: 900 pts
(8, 8, 'Suda', 'Petchdee', 2, 3200, NULL),                   -- Level 2: 3200 pts
(9, 9, 'David', 'Nguyen', 3, 8800, '1989-07-05'),            -- Level 3: 8800 pts
(10, 10, 'Preeda', 'Chanakul', 4, 15700, NULL);             -- Level 4: 15700 pts

INSERT INTO Product (productCode, productType, weight, recyclePercentage, size, unitPrice) VALUES
('P1001', 'Shoes', 900, 30, '42', 3200.00),
('P1002', 'Shirt', NULL, 40, 'L', 1200.00),
('P1003', 'Shorts', 300, NULL, 'M', 850.00),
('P1004', 'Hat', 150, 20, 'Free', 450.00),
('P1005', 'Socks', 80, 50, 'Free', 200.00),
('P1006', 'Bag', 600, NULL, 'Standard', 1500.00),
('P1007', 'Bottle', 200, 70, '500ml', 350.00),
('P1008', 'Towel', 400, 60, 'XL', 500.00),
('P1009', 'Jacket', 1000, 30, 'XL', 3800.00),
('P1010', 'Sandals', NULL, 20, '40', 700.00);

-- Transaction Tables
INSERT INTO Orders (orderID, customerID, phoneNumber, emailAddress, purchaseTime, purchaseStatus, companyName, TaxID) VALUES
(1, 1, '081-234-5678', 'somchai.wc@example.com', '2023-01-10 09:00:00', 1, NULL, NULL),
(2, 2, '089-112-3344', 'anong.st@example.com', '2023-02-10 10:15:00', 1, 'Thai Bakery Co.', '0123456001'),
(3, 3, '091-889-2200', 'john.smith@example.com', '2023-03-10 11:10:00', 0, NULL, NULL),
(4, 4, '080-220-1144', 'emily.t@example.com', '2023-04-10 12:00:00', 1, NULL, NULL),
(5, 5, '082-998-1122', 'kittisak.bs@example.com', '2023-05-11 08:40:00', 1, 'Bangkok Supplies Ltd.', '0203334445'),
(6, 6, '083-774-6622', 'nichapa.sw@example.com', '2023-06-11 09:20:00', 0, NULL, NULL),
(7, 7, '095-443-2211', 'michael.b@example.com', '2023-07-11 10:50:00', 1, NULL, NULL),
(8, 8, '086-312-5522', 'suda.pd@example.com', '2023-08-12 11:30:00', 1, NULL, NULL),
(9, 9, '084-222-9055', 'david.ng@example.com', '2023-09-12 13:45:00', 1, 'Siam Retail Group', '0778899001'),
(10, 10, '089-600-7788', 'preeda.ck@example.com', '2023-10-12 14:30:00', 1, NULL, NULL),

(11, 1, '081-234-5678', 'somchai.wc@example.com', '2024-01-13 09:15:00', 0, NULL, NULL),
(12, 2, '089-112-3344', 'anong.st@example.com', '2024-02-13 10:25:00', 1, NULL, NULL),
(13, 3, '091-889-2200', 'john.smith@example.com', '2024-03-13 11:50:00', 1, 'Global Traders', '0345566778'),
(14, 4, '080-220-1144', 'emily.t@example.com', '2024-04-14 12:45:00', 1, NULL, NULL),
(15, 5, '082-998-1122', 'kittisak.bs@example.com', '2024-05-14 14:00:00', 0, NULL, NULL),
(16, 6, '083-774-6622', 'nichapa.sw@example.com', '2024-06-15 08:55:00', 1, NULL, NULL),
(17, 7, '095-443-2211', 'michael.b@example.com', '2024-07-15 09:40:00', 1, 'East Logistics Co.', '0512345678'),
(18, 8, '086-312-5522', 'suda.pd@example.com', '2024-08-15 11:20:00', 1, NULL, NULL),
(19, 9, '084-222-9055', 'david.ng@example.com', '2024-09-16 10:05:00', 0, NULL, NULL),
(20, 10, '089-600-7788', 'preeda.ck@example.com', '2024-10-16 12:25:00', 1, NULL, NULL),

(21, 1, '081-234-5678', 'somchai.wc@example.com', '2025-03-17 13:45:00', 1, NULL, NULL),
(22, 2, '089-112-3344', 'anong.st@example.com', '2025-04-17 14:50:00', 1, NULL, NULL),
(23, 3, '091-889-2200', 'john.smith@example.com', '2025-05-18 15:20:00', 1, NULL, NULL),
(24, 4, '080-220-1144', 'emily.t@example.com', '2025-06-18 16:05:00', 0, NULL, NULL),
(25, 5, '082-998-1122', 'kittisak.bs@example.com', '2025-07-19 09:40:00', 1, 'Somchai Wholesale', '0667788990'),
(26, 6, '083-774-6622', 'nichapa.sw@example.com', '2025-08-19 10:30:00', 1, NULL, NULL),
(27, 7, '095-443-2211', 'michael.b@example.com', '2025-09-20 18:10:00', 1, NULL, NULL),
(28, 8, '086-312-5522', 'suda.pd@example.com', '2025-10-20 19:00:00', 0, NULL, NULL),
(29, 9, '084-222-9055', 'david.ng@example.com', '2025-11-21 10:15:00', 1, NULL, NULL),
(30, 10, '089-600-7788', 'preeda.ck@example.com', '2025-12-21 11:25:00', 1, NULL, NULL);

INSERT INTO Cart (orderID, productCode, quantity) VALUES
(1,'P1001',1),(2,'P1002',2),(3,'P1003',1),(4,'P1004',1),
(5,'P1005',2),(6,'P1006',1),(7,'P1007',1),(8,'P1008',2),
(9,'P1009',1),(10,'P1010',1),(11,'P1001',1),(12,'P1002',1),
(13,'P1003',2),(14,'P1004',1),(15,'P1005',1),(16,'P1006',1),
(17,'P1007',3),(18,'P1008',1),(19,'P1009',2),(20,'P1010',1),
(21,'P1001',2),(22,'P1002',1),(23,'P1003',1),(24,'P1004',2),
(25,'P1005',3),(26,'P1006',1),(27,'P1007',1),(28,'P1008',1),
(29,'P1009',1),(30,'P1010',2);

INSERT INTO Redeem (RewardID, MemberID, CustomerID, redeemStatus, redeemedDate) VALUES
(1,1,1,1,'2025-04-10 09:30:00'),
(2,2,2,0,NULL),
(3,3,3,1,'2025-04-11 10:00:00'),
(4,4,4,0,NULL),
(5,5,5,1,'2025-04-11 11:15:00'),
(6,6,6,1,'2025-04-12 12:00:00'),
(7,7,7,0,NULL),
(8,8,8,1,'2025-04-12 14:20:00'),
(9,9,9,0,NULL),
(10,10,10,1,'2025-04-13 09:10:00'),

(1,2,2,1,'2025-04-13 10:10:00'),
(2,3,3,1,'2025-04-13 11:10:00'),
(3,4,4,0,NULL),
(4,5,5,1,'2025-04-14 09:00:00'),
(5,6,6,0,NULL),
(6,7,7,1,'2025-04-14 10:15:00'),
(7,8,8,1,'2025-04-14 12:00:00'),
(8,9,9,0,NULL),
(9,10,10,1,'2025-04-15 09:30:00'),
(10,1,1,1,'2025-04-15 10:05:00'),

(1,3,3,1,'2025-04-15 11:20:00'),
(2,4,4,1,'2025-04-15 13:40:00'),
(3,5,5,0,NULL),
(4,6,6,1,'2025-04-16 10:10:00'),
(5,7,7,0,NULL),
(6,8,8,1,'2025-04-16 11:35:00'),
(7,9,9,1,'2025-04-16 13:20:00'),
(8,10,10,1,'2025-04-17 09:25:00'),
(9,1,1,0,NULL),
(10,2,2,1,'2025-04-17 11:50:00');

INSERT INTO Review (reviewID, customerID, productCode, reviewTitle, commentText, submissionDate, rating) VALUES
(1,1,'P1001','Great shoes','Very comfortable','2025-04-10 12:30',5),
(2,2,'P1002','Nice shirt','Good quality','2025-04-10 13:00',4),
(3,3,'P1003','Love these shorts','Perfect fit','2025-04-10 14:00',5),
(4,4,'P1004','Good hat','Stylish','2025-04-10 14:45',4),
(5,5,'P1005','Soft socks','Comfy','2025-04-11 09:10',5),
(6,6,'P1006','Durable bag','Holds a lot','2025-04-11 10:20',4),
(7,7,'P1007','Nice bottle','Keeps cold','2025-04-11 12:10',5),
(8,8,'P1008','Great towel','Very absorbent','2025-04-11 14:00',5),
(9,9,'P1009','Warm jacket','Perfect for travel','2025-04-12 08:00',5),
(10,10,'P1010','Good sandals','Comfortable','2025-04-12 09:10',4),
(11,1,'P1002','Shirt quality ok','Not bad','2025-04-12 10:00',3),
(12,2,'P1003','Shorts color faded','After wash','2025-04-12 10:30',2),
(13,3,'P1004','Cap too small','Runs small','2025-04-12 11:00',3),
(14,4,'P1005','Socks thin','Expected thicker','2025-04-12 14:00',2),
(15,5,'P1006','Bag zipper issue','Sometimes stuck','2025-04-13 09:20',3),
(16,6,'P1007','Bottle leaks','When tilted','2025-04-13 11:40',2),
(17,7,'P1008','Towel too rough','Not soft','2025-04-13 13:00',3),
(18,8,'P1009','Jacket size small','Returned','2025-04-13 15:10',2),
(19,9,'P1010','Sandals slippery','Wet floor issue','2025-04-14 08:30',2),
(20,10,'P1001','Shoes ok','Not special','2025-04-14 09:45',3),
(21,1,'P1003','Good fit','Happy with it','2025-04-14 10:30',4),
(22,2,'P1004','Nice hat','Stylish','2025-04-14 12:00',5),
(23,3,'P1005','Warm socks','Soft','2025-04-14 13:20',4),
(24,4,'P1006','Bag useful','Daily carry','2025-04-14 14:00',5),
(25,5,'P1007','Bottle good','Good capacity','2025-04-15 09:10',4),
(26,6,'P1008','Towel soft','Very soft','2025-04-15 10:00',5),
(27,7,'P1009','Warm jacket','Nice','2025-04-15 11:40',5),
(28,8,'P1010','Sandals comfy','Buy again','2025-04-15 12:10',4),
(29,9,'P1001','Shoes faded','Color gone fast','2025-04-15 13:40',2),
(30,10,'P1002','Shirt great','Good cotton','2025-04-15 14:20',5);

INSERT INTO Delivery (deliveryID, orderID, deliveryStatus, deliveredTime, estimatedDeliveryDate, deliveryFee) VALUES
(1,1,'Delivered','2025-04-11 10:00','2025-04-11 10:00',50.00),
(2,2,'Delivered','2025-04-11 11:00','2025-04-11 11:00',45.00),
(3,3,'Pending',NULL,'2025-04-12 15:00',40.00),
(4,4,'Delivered','2025-04-12 16:00','2025-04-12 16:00',55.00),
(5,5,'Delivered','2025-04-13 09:00','2025-04-13 09:00',35.00),
(6,6,'Pending',NULL,'2025-04-13 18:00',40.00),
(7,7,'Delivered','2025-04-14 10:00','2025-04-14 10:00',50.00),
(8,8,'Delivered','2025-04-14 12:00','2025-04-14 12:00',45.00),
(9,9,'Delivered','2025-04-14 14:30','2025-04-14 14:30',60.00),
(10,10,'Delivered','2025-04-15 09:40','2025-04-15 09:40',55.00),
(11,11,'Pending',NULL,'2025-04-15 18:00',40.00),
(12,12,'Delivered','2025-04-16 09:10','2025-04-16 09:10',50.00),
(13,13,'Delivered','2025-04-16 10:10','2025-04-16 10:10',45.00),
(14,14,'Delivered','2025-04-16 11:30','2025-04-16 11:30',50.00),
(15,15,'Pending',NULL,'2025-04-17 14:00',35.00),
(16,16,'Delivered','2025-04-17 09:00','2025-04-17 09:00',40.00),
(17,17,'Delivered','2025-04-17 10:30','2025-04-17 10:30',55.00),
(18,18,'Delivered','2025-04-17 12:00','2025-04-17 12:00',45.00),
(19,19,'Pending',NULL,'2025-04-18 15:00',50.00),
(20,20,'Delivered','2025-04-18 09:50','2025-04-18 09:50',55.00),
(21,21,'Delivered','2025-04-18 11:20','2025-04-18 11:20',45.00),
(22,22,'Delivered','2025-04-18 13:00','2025-04-18 13:00',50.00),
(23,23,'Delivered','2025-04-19 09:30','2025-04-19 09:30',55.00),
(24,24,'Pending',NULL,'2025-04-19 16:00',40.00),
(25,25,'Delivered','2025-04-19 10:40','2025-04-19 10:40',50.00),
(26,26,'Delivered','2025-04-19 11:50','2025-04-19 11:50',55.00),
(27,27,'Delivered','2025-04-20 12:15','2025-04-20 12:15',45.00),
(28,28,'Pending',NULL,'2025-04-20 19:00',40.00),
(29,29,'Delivered','2025-04-21 10:20','2025-04-21 10:20',60.00),
(30,30,'Delivered','2025-04-21 11:30','2025-04-21 11:30',55.00);

INSERT INTO Payment (paymentID, orderID, cardNumber, cardholderName, expirationDate, CVCCVV, zipCode, province, city, addressLine) VALUES
(1,1,'4111111111111111','Somchai Wongchai','2028-05-01','123','10230','Bangkok','Lat Phrao','123 Sukhumvit Rd'),
(2,2,'5500000000000004','Anong Siritorn','2027-10-01','456','10110','Bangkok','Bang Na','88 Rama 2'),
(3,3,'4111111111112222','John Smith','2029-01-01','789','10500','Bangkok','Silom','55 Silom'),
(4,4,'4000123412341234','Emily Turner','2028-08-01','321','10310','Bangkok','Huai Khwang','22 Ratchada'),
(5,5,'5105105105105100','Kittisak Boonsri','2029-05-01','987','10400','Bangkok','Din Daeng','77 Prachasongkroa'),
(6,6,'4111222233334444','Nichapa Suwan','2027-12-01','159','10900','Bangkok','Chatuchak','12 Kaset'),
(7,7,'5555444433332222','Michael Brown','2030-01-01','753','10120','Bangkok','Sathon','19 Narathiwas'),
(8,8,'4012888888881881','Suda Petchdee','2030-04-01','951','10240','Bangkok','Lat Krabang','90 Kingkaew'),
(9,9,'4222222222222','David Nguyen','2028-01-01','258','10540','Bangkok','Phra Khanong','14 Sukhumvit 71'),
(10,10,'4111444466667777','Preeda Chanakul','2029-09-01','654','10330','Bangkok','Pathum Wan','33 Siam Square'),
(11,11,'4444333322221111','Somchai Wongchai','2028-06-01','852','10500','Bangkok','Silom','55 Silom'),
(12,12,'4000555566667777','Anong Siritorn','2031-01-01','147','10900','Bangkok','Chatuchak','12 Kaset'),
(13,13,'4111111111113333','John Smith','2030-01-01','258','10110','Bangkok','Bang Na','88 Rama 2'),
(14,14,'5500000000001111','Emily Turner','2027-09-01','753','10310','Bangkok','Huai Khwang','22 Ratchada'),
(15,15,'5105105105109999','Kittisak Boonsri','2028-12-01','456','10400','Bangkok','Din Daeng','77 Prachasongkroa'),
(16,16,'4111222233331111','Nichapa Suwan','2029-07-01','789','10900','Bangkok','Chatuchak','12 Kaset'),
(17,17,'5555444433338888','Michael Brown','2031-10-01','987','10120','Bangkok','Sathon','19 Narathiwas'),
(18,18,'4012888888881444','Suda Petchdee','2028-03-01','951','10240','Bangkok','Lat Krabang','90 Kingkaew'),
(19,19,'4222222222555','David Nguyen','2030-06-01','123','10540','Bangkok','Phra Khanong','14 Sukhumvit 71'),
(20,20,'4111444466662222','Preeda Chanakul','2029-05-01','321','10330','Bangkok','Pathum Wan','33 Siam Square'),
(21,21,'4444333322225555','Somchai Wongchai','2031-02-01','654','10230','Bangkok','Lat Phrao','123 Sukhumvit'),
(22,22,'4000555566661111','Anong Siritorn','2028-11-01','741','10110','Bangkok','Bang Na','88 Rama 2'),
(23,23,'4111111111116666','John Smith','2029-04-01','159','10500','Bangkok','Silom','55 Silom'),
(24,24,'5500000000002222','Emily Turner','2027-03-01','258','10310','Bangkok','Huai Khwang','22 Ratchada'),
(25,25,'5105105105103333','Kittisak Boonsri','2029-08-01','357','10400','Bangkok','Din Daeng','77 Prachasongkroa'),
(26,26,'4111222233337777','Nichapa Suwan','2031-07-01','951','10900','Bangkok','Chatuchak','12 Kaset'),
(27,27,'5555444433331111','Michael Brown','2030-02-01','654','10120','Bangkok','Sathon','19 Narathiwas'),
(28,28,'4012888888881999','Suda Petchdee','2028-05-01','456','10240','Bangkok','Lat Krabang','90 Kingkaew'),
(29,29,'4222222222777','David Nguyen','2029-09-01','789','10540','Bangkok','Phra Khanong','14 Sukhumvit 71'),
(30,30,'4111444466669999','Preeda Chanakul','2031-01-01','147','10330','Bangkok','Pathum Wan','33 Siam Square');

-- Master tables
SELECT * FROM Reward;
SELECT * FROM Voucher;
SELECT * FROM Offer;
SELECT * FROM Customer;
SELECT * FROM Members;
SELECT * FROM Product;

-- Transaction tables
SELECT * FROM Orders;
SELECT * FROM Cart;
SELECT * FROM Redeem;
SELECT * FROM Review;
SELECT * FROM Delivery;
SELECT * FROM Payment;










