USE master
GO
--1. Create database named AZBank.
IF EXISTS (SELECT * FROM sys.databases WHERE Name='AZ_bank')
DROP DATABASE AZ_bank
GO
CREATE DATABASE AZ_bank
GO
USE AZ_bank
GO
--2. In the AZBank database, create tables with constraints as design above.
Create table Customer(
	CustomerID int not null primary key,
	Name nvarchar(50) null,
	City nvarchar(50) null,
	Country nvarchar(50) null,
	Phone nvarchar(15) null,
	Email nvarchar(50) null
	);
Create table CustomerAccount(
	AccountNumber char(9) not null primary key,
	CustomerId int not null,
	Balance money not null,
	MinAccount money null,
	Constraint FK_CustomerAcc 
	Foreign key (CustomerID)
	References Customer(CustomerID)
	);
Create table CustomerTransaction(
	TransactionID int not null primary key,
	AccountNumber char(9),
	TransactionDate smalldatetime null,
	Amount money null,
	DepositorWithdraw bit null,
	Constraint fk_CustomerTran 
	Foreign key (AccountNumber) 
	References CustomerAccount(AccountNumber)
	);

	--3. Insert into each table at least 3 records.
	Insert into Customer values('1','NAM','hanoi','Vietnam','091247762','NAM125@gmail.com');
	Insert into Customer values('2','TUNG','beijing','China','01562756','TUNG135@gmail.com');
	Insert into Customer values('3','SON','seoul','Korea','0933347762','SON5@gmail.com');

	Insert into CustomerAccount values('365214786','1','3000000','10000');
	Insert into CustomerAccount values('365214722','2','2000000','5000');
	Insert into CustomerAccount values('365214435','3','1500000','3000');

	Insert into CustomerTransaction values('678','365214786','2022-02-02','15000','1');
	Insert into CustomerTransaction values('679','365214722','2022-02-03','55000','1');
	Insert into CustomerTransaction values('680','365214435','2022-02-04','5000','1');
	
	--4. Write a query to get all customers from Customer table who live in ‘Hanoi’.
	Select * From Customer Where Customer.City='hanoi';

	--5. Write a query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance).
	Select Customer.Name,Customer.Phone,Customer.Email,CustomerAccount.AccountNumber,CustomerAccount.Balance from Customer full join CustomerAccount 
	on Customer.CustomerID=CustomerAccount.CustomerId

	--6. A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be over $1000000 (One million USDs). Create a CHECK constraint on Amount column of
	--CustomerTransaction table to check that each transaction amount is greater than 0 and less than or equal $1000000.
	Alter table customertransaction add constraint ck_deposit check (Amount > 0 and Amount < 1000000);

	--7. Create a view named vCustomerTransactions that display Name, AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer, CustomerAccount and CustomerTransaction tables.
	Create view vCustomerTransactions as
	Select Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount, CustomerTransaction.DepositorWithdraw 
	From (Customer join CustomerAccount on Customer.CustomerID=CustomerAccount.CustomerId) join CustomerTransaction on CustomerAccount.AccountNumber=CustomerTransaction.AccountNumber;

	Select * From vCustomerTransactions;