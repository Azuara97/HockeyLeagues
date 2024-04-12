--Create tables
CREATE TABLE UserData(
userID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_UserDataID PRIMARY KEY,
pass VARCHAR(20) NOT NULL,
userFullName VARCHAR(80) NOT NULL,
email VARCHAR(80) NOT NULL,
registerDate DATETIME NOT NULL CONSTRAINT DF_RegisterDate DEFAULT (getDate()),
userAddress VARCHAR(100) NULL,
phoneNumber BIGINT NULL,
department VARCHAR(20) NULL,
userType VARCHAR(20) NOT NULL CONSTRAINT DF_UserType DEFAULT ('User')
);

CREATE TABLE Products(
productID INT IDENTITY(100, 1) NOT NULL CONSTRAINT PK_ProductID PRIMARY KEY,
productName VARCHAR(50) NOT NULL CONSTRAINT DF_ProductName DEFAULT ('Product Unnamed'),
quantity INT NOT NULL CONSTRAINT DF_ProductsQuantity DEFAULT (0)
);

CREATE TABLE OrdersDetail(
orderID INT NOT NULL CONSTRAINT PK_OrderID PRIMARY KEY,
productID INT NOT NULL CONSTRAINT FK_OrderDetail_ProductID FOREIGN KEY REFERENCES dbo.Products (productID),
quantity INT NOT NULL CONSTRAINT DF_OrderDetail_Quantity DEFAULT (1),
shippingAddress VARCHAR(100) NOT NULL,
orderDate DATETIME NOT NULL CONSTRAINT DF_OrdersDetail_Date DEFAULT (getDate()),
amount MONEY NOT NULL
);

CREATE TABLE Orders(
orderID INT NOT NULL CONSTRAINT FK_OrderID FOREIGN KEY REFERENCES dbo.OrdersDetail (orderID),
productID INT NOT NULL CONSTRAINT FK_Orders_ProductID FOREIGN KEY REFERENCES dbo.Products (productID),
amount MONEY NOT NULL,
orderDate DATETIME NOT NULL CONSTRAINT DF_Orders_Date DEFAULT (getDate())
);

CREATE TABLE Teams(
teamID INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_TeamID PRIMARY KEY,
teamName VARCHAR(20) NOT NULL,
creationDate DATETIME NOT NULL,
country VARCHAR(30) NOT NULL,
city VARCHAR(30) NOT NULL
);

CREATE TABLE Players(
playerID INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_PlayerID PRIMARY KEY,
playerName VARCHAR(80) NOT NULL,
bornDate DATETIME NOT NULL,
shots INT NOT NULL CONSTRAINT DF_PlayerShots DEFAULT (0),
goals INT NOT NULL CONSTRAINT DF_PlayerGoals DEFAULT (0),
height FLOAT NOT NULL,
weight FLOAT NOT NULL,
speed FLOAT NULL,
teamID INT NOT NULL CONSTRAINT FK_TeamID FOREIGN KEY REFERENCES dbo.Teams (teamID),
nationality VARCHAR(30) NULL
);

CREATE TABLE Stadiums(
stadiumID INT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_StadiumID PRIMARY KEY,
stadiumName VARCHAR(40) NOT NULL,
capacity INT NOT NULL,
openDate DATETIME NOT NULL,
country VARCHAR(30) NOT NULL,
city VARCHAR(30) NOT NULL
);

--Insert Data

INSERT INTO dbo.UserData (pass, userFullName, email, registerDate, userAddress, phoneNumber, department, userType)
VALUES ('password123', 'Luis Azuara', 'lazuara@mail.com', CONVERT(DATETIME, '2024-03-01'), '273 Boul. Montreal QC', 4780624398, NULL, 'User'),
('password456', 'Ricardo Maldonado', 'rmaldonado@mail.com', CONVERT(DATETIME, '2023-05-15'), '54 Rue. Montreal QC', 5174328945, NULL, 'User'),
('password789', 'Luis Maldonado', 'lumaldonado@mail.com', CONVERT(DATETIME, '2022-12-28'), '67 Avenue. Montreal QC', 5247862389, 'Sales', 'Employee'),
('password135', 'Ricardo Azuara', 'ricazuara@mail.com', CONVERT(DATETIME, '2021-04-03'), '23 Rue. Montreal QC', 4583750218, 'IT', 'Employee');

INSERT INTO dbo.Products (productName, quantity)
VALUES ('Jersey Canadiens', 50),
('Hat Canadiens', 20),
('Tickets Canadiens vs Hurricanes', 200),
('Tickets Canadiens vs Rangers', 500);

INSERT INTO dbo.OrdersDetail
VALUES (100424, (SELECT p.productID FROM dbo.Products p WHERE p.productName = 'Jersey Canadiens'), 2, '34 Rue. Montreal QC', CONVERT(DATETIME, '2023-11-06'), CONVERT(MONEY, 200.0)),
(090424, (SELECT p.productID FROM dbo.Products p WHERE p.productName = 'Hat Canadiens'), 1, '54 Boul. Montreal QC', CONVERT(DATETIME, '2022-03-13'), CONVERT(MONEY, 150.0)),
(080424, (SELECT p.productID FROM dbo.Products p WHERE p.productName = 'Tickets Canadiens vs Hurricanes'), 2, '45 Avenue. Montreal QC', CONVERT(DATETIME, '2021-11-17'), CONVERT(MONEY, 300.0)),
(070424, (SELECT p.productID FROM dbo.Products p WHERE p.productName = 'Tickets Canadiens vs Rangers'), 4, '123 Boul. Montreal QC', CONVERT(DATETIME, '2020-04-16'), CONVERT(MONEY, 500.0));

INSERT INTO dbo.Orders (orderID, productID, amount, orderDate)
SELECT o.orderID, o.productID, o.amount, o.orderDate FROM dbo.OrdersDetail o;

INSERT INTO dbo.Teams
VALUES('Toronto Maple Leafs', CONVERT(DATETIME, '19171122'), 'Canada', 'Toronto'),
('Boston Bruins', CONVERT(DATETIME, '19241101'), 'United States', 'Boston'),
('New York Rangers', CONVERT(DATETIME, '19260515'), 'United States', 'New York'),
('Montreal Canadiens', CONVERT(DATETIME, '19091204'), 'Canada', 'Montreal'),
('Chicago Blackhawks', CONVERT(DATETIME, '19260925'), 'United States', 'Chicago');

INSERT INTO dbo.Players
VALUES ('Connor McDavid', CONVERT(DATETIME, '19970113'), 250, 40, 6.1, 193, 34.2, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Toronto Maple Leafs'), 'Canadian'),
('Sidney Crosby', CONVERT(DATETIME, '19870807'), 220, 35, 5.11,	200, 33.5, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Toronto Maple Leafs'), 'Canadian'),
('Mitchell Marner', CONVERT(DATETIME, '1997-05-05'), 210, 30, 6, 175, 34.8,	(SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Toronto Maple Leafs'), 'Canadian'),
('Auston Matthews', CONVERT(DATETIME, '1997-09-17'), 240, 35, 6.3, 220, 34.5, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Toronto Maple Leafs'), 'American'),
('David Pastrnak', CONVERT(DATETIME, '1996-05-25'),	230, 35, 6,	194, 35, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Boston Bruins'), 'Czech'),
('Brad Marchand', CONVERT(DATETIME, '1988-05-11'),	200, 30, 5.9, 181, 35.2, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Boston Bruins'), 'Canadian'),
('Charlie McAvoy', CONVERT(DATETIME, '1997-12-21'),	190, 20, 6, 208, 34.9, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Boston Bruins'), 'American'),
('Tuukka Rask',	CONVERT(DATETIME, '1987-03-10'), 0,	0, 6.2, 176, 0,	(SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Boston Bruins'), 'Finnish'),
('Artemi Panarin', CONVERT(DATETIME, '1991-10-30'),	210, 25, 6, 168, 35.5, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'New York Rangers'), 'Russian'),
('Mika Zibanejad', CONVERT(DATETIME, '1993-04-18'),	220, 30, 6.2, 208, 33.9, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'New York Rangers'), 'Swedish'),
('Adam Fox', CONVERT(DATETIME, '1998-02-17'), 180, 15, 5.11, 181, 35.4,	(SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'New York Rangers'), 'American'),
('Igor Shesterkin',	CONVERT(DATETIME, '1995-12-30'), 0,	0, 6.2,	182, 0,	(SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'New York Rangers'), 'Russian'),
('Carey Price',	CONVERT(DATETIME, '1987-08-16'), 0,	0, 6.3,	226, 0,	(SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Montreal Canadiens'), 'Canadian'),
('Shea Weber', CONVERT(DATETIME, '1985-08-14'),	190, 20, 6.4, 232, 31.8, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Montreal Canadiens'), 'Canadian'),
('Nick Suzuki', CONVERT(DATETIME, '1999-08-10'), 200, 25, 6.1, 201,	34.6, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Montreal Canadiens'), 'Canadian'),
('Cole Caufield', CONVERT(DATETIME, '2001-01-02'), 180,	20,	5.7, 65, 36, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Montreal Canadiens'), 'American'),
('Jonathan Toews', CONVERT(DATETIME, '1988-04-29'),	230, 30, 6.2, 201, 33.2, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Chicago Blackhawks'), 'Canadian'),
('Patrick Kane', CONVERT(DATETIME,'1988-11-19'), 250, 40, 5.11,	177, 35.2, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Chicago Blackhawks'), 'American'),
('Alex DeBrincat', CONVERT(DATETIME, '1997-12-18'),	220, 30, 5.7, 165, 35.9, (SELECT t.teamID FROM dbo.Teams t WHERE t.teamName = 'Chicago Blackhawks'), 'American');

INSERT INTO dbo.Stadiums
VALUES ('Scotiabank Arena',	19000, CONVERT(DATETIME, '1999-02-20'), 'Canada', 'Toronto'),
('TD Garden', 17565, CONVERT(DATETIME, '1995-09-30'), 'United States', 'Boston'),
('Madison Square Garden', 18104, CONVERT(DATETIME, '1968-02-11'), 'United States', 'New York'),
('Bell Centre', 21273, CONVERT(DATETIME, '1996-03-16'), 'Canada', 'Montreal'),
('United Center', 19717, CONVERT(DATETIME, '1994-08-18'), 'United States', 'Chicago');

--Create Procedures
CREATE PROCEDURE dbo.Register(@password VARCHAR(20),
@name VARCHAR(80),
@email VARCHAR(80),
@address VARCHAR(100),
@phoneNumber BIGINT,
@department VARCHAR(20),
@type VARCHAR(20))
AS
BEGIN
	INSERT INTO dbo.UserData (pass, userFullName, email, registerDate, userAddress, phoneNumber, department, userType)
	VALUES (@password, @name, @email, GETDATE(), @address, @phoneNumber, @department, @type);
END

CREATE PROCEDURE dbo.UserLogin(@email VARCHAR(80), @password VARCHAR(20), @outputBit BIT OUTPUT)
AS
BEGIN
	DECLARE @ID INT, @userEmail VARCHAR(80), @userPass VARCHAR(20);

	SELECT @ID = u.userID FROM dbo.UserData u WHERE u.email = @email AND u.pass = @password;

	IF @ID != 0
		SET @outputBit = 1;
	ELSE
		SET @outputBit = 0;
END

CREATE PROCEDURE dbo.UpdateProfile(@id INT,
@password VARCHAR(20),
@name VARCHAR(80),
@email VARCHAR(80),
@address VARCHAR(100),
@phoneNumber BIGINT,
@department VARCHAR(20),
@type VARCHAR(20))
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION
	IF @password != NULL
		UPDATE us SET us.pass = @password FROM dbo.UserData us WHERE us.userID = @id;

	IF @name != NULL
		UPDATE us SET us.userFullName = @name FROM dbo.UserData us WHERE us.userID = @id;

	IF @email != NULL
		UPDATE us SET us.email = @email FROM dbo.UserData us WHERE us.userID = @id;

	UPDATE us SET us.userAddress = @address FROM dbo.UserData us WHERE us.userID = @id;
	UPDATE us SET us.phoneNumber = @phoneNumber FROM dbo.UserData us WHERE us.userID = @id;
	UPDATE us SET us.department = @department FROM dbo.UserData us WHERE us.userID = @id;
	UPDATE us SET us.userType = @type FROM dbo.UserData us WHERE us.userID = @id;

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_LINE()
	PRINT ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END

CREATE PROCEDURE dbo.AddStorage(@productName VARCHAR(50),@quantity INT)
AS
BEGIN
	INSERT INTO dbo.Products (productName, quantity)
	VALUES (@productName, @quantity)
END

CREATE PROCEDURE dbo.UpdateStorage(@id INT, @productName VARCHAR(50), @quantity INT)
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION
	UPDATE p SET p.productName = @productName FROM dbo.Products p WHERE p.productID = @id;
	UPDATE p SET p.quantity = @quantity FROM dbo.Products p WHERE p.productID = @id;
COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_LINE()
	PRINT ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH
END

CREATE PROCEDURE dbo.CreateOrder(@id INT,
@productID INT,
@quantity INT,
@shippingAddress VARCHAR(100),
@amount MONEY)
AS
BEGIN
	DECLARE @date DATETIME;
	SET @date = GETDATE();

	INSERT INTO dbo.OrdersDetail
	VALUES (@id, @productID, @quantity, @shippingAddress, @date, @amount);

	INSERT INTO dbo.Orders
	VALUES (@id, @productID, @amount, @date);
END

CREATE PROCEDURE dbo.CalculateAccuracy(@playerID INT, @pct FLOAT OUTPUT)
AS
BEGIN
	SELECT @pct = (p.goals / CAST(p.shots AS FLOAT))
	FROM dbo.Players p
	WHERE p.playerID = @playerID;
END

CREATE PROCEDURE dbo.GetPlayerInfo(@playerID INT, @info VARCHAR(MAX) OUTPUT)
AS
BEGIN
	SELECT @info = CONCAT(p.playerName, ',', p.bornDate, ',', p.shots, ',', p.goals, ',', p.height, ',', p.weight, ',', p.speed, ',', p.nationality)
	FROM dbo.Players p
	WHERE p.playerID = @playerID
END

CREATE PROCEDURE dbo.CalculatePlayerAge(@playerID INT, @age INT OUTPUT)
AS
BEGIN
	SELECT @age = DATEDIFF(HOUR, p.bornDate, GETDATE()) / 8766
	FROM dbo.Players p
	WHERE p.playerID = @playerID
END

CREATE PROCEDURE dbo.GetStadiumInfo(@stadiumID INT, @info VARCHAR(MAX) OUTPUT)
AS
BEGIN
	SELECT @info = CONCAT(s.stadiumName, ',', s.capacity, ',', s.openDate, ',', s.country, ',', s.city)
	FROM dbo.Stadiums s
	WHERE s.stadiumID = @stadiumID
END

CREATE PROCEDURE dbo.CalculateStadiumAge(@stadiumID INT, @age INT OUTPUT)
AS
BEGIN
	SELECT @age = DATEDIFF(HOUR, s.openDate, GETDATE()) / 8766
	FROM dbo.Stadiums s
	WHERE s.stadiumID = @stadiumID
END

CREATE PROCEDURE dbo.GetTeamsInfo(@teamID INT, @info VARCHAR(MAX) OUTPUT)
AS
BEGIN
	SELECT @info = CONCAT(t.teamName, ',', t.creationDate, ',', t.country, ',', t.city)
	FROM dbo.Teams t
	WHERE t.teamID = @teamID
END

CREATE PROCEDURE dbo.CalculateTeamAge(@teamID INT, @age INT OUTPUT)
AS
BEGIN
	SELECT @age = DATEDIFF(HOUR, t.creationDate, GETDATE()) / 8766
	FROM dbo.Teams t
	WHERE t.teamID = @teamID
END