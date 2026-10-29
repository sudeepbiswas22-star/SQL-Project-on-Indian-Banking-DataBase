CREATE DATABASE IndianBankingDB

use IndianBankingDB
go

create table Branches 
(
 BranchID int Primary Key,
 Branch_Name Varchar(50) not null,
 IFSC_CODE Varchar(50) unique,
 City varchar(50) not null,
 State varchar(50) not null,
 )
 select * from Branches 

 insert into Branches (BranchID,Branch_Name,IFSC_CODE,City,State)
 values 
 (1,'SBI Alkapuri branch','SBIN0001234','VADODARA','GUJARAT'),
 (2,'HDFC BANK Sayajigunj branch','HDFC0002345','VADODARA','GUJARAT'),
 (3,'ICICI BANK Andheri', 'ICICI0003456','Mumbai','Maharastra'),
 (4,'Axis Bank Connaught Place','UTIB0004567','Delhi','Delhi'),
 (5,'SBI Salt Lake Branch', 'SBIN0005678', 'Kolkata', 'West Bengal')

 create table Customers
 (
 CustomerID INT Primary Key,
 CustomerName Varchar (50) Not Null,
 Mobile_NO Varchar not null,
 Email Varchar(50),
 City Varchar (50),
 State Varchar(50)
 )
 Alter Table Customers
 Alter Column Mobile_NO Varchar(20)

 insert into Customers (CustomerID,CustomerName,Mobile_NO,Email,City,State)
 values 
 (101,'Rahul Sharma','9824173059','rahul123@gmail.com','Vadodara','Gujarat'),
 (102,'Priya Patel', '8750291436', 'priya123@gmail.com','Ahmedabad','Gujarat'),
 (103,'Amit Verma', '7018362945','amit123@gmail.com','Mumbai','Maharastra'),
 (104,'Sneha Mehta','9163048217','sneha123@gmail.com','Delhi','Delhi'),
 (105,'Rohan Das','6392415870', 'rohan123@gmail.com','Kolkata','West Bengal'),
 (106,'Neha Shah','9909012345', 'neha@gmail.com', 'Vadodara', 'Gujarat')
 INSERT INTO Customers
VALUES
(107, 'Vikram Singh', '9810012345', 'vikram@gmail.com', 'Delhi', 'Delhi'),
(108, 'Anjali Joshi', '9879012345', 'anjali@gmail.com', 'Ahmedabad', 'Gujarat');

 select * from Customers

 create table Accounts 
 (
 AccountID Int Primary Key,
 CustomerID Int,
 BranchID Int,
 Account_Type Varchar(50) Not null,
 Balance Decimal(12,2) Default 0,
 Opening_date Date,
 
 Foreign Key (CustomerID) References Customers(CustomerID),
 Foreign Key (BranchID) references Branches(BranchID),
 )

 insert into Accounts (AccountID,CustomerID,BranchID,Account_Type,Balance,Opening_date)
 values
 (1001, 101, 1, 'Savings', 75000.00, '2022-05-10'), 
(1002, 102, 2, 'Savings', 45000.00, '2023-01-15'), 
(1003, 103, 3, 'Current', 125000.00, '2021-08-20'), 
(1004, 104, 4, 'Savings', 62000.00, '2022-11-05'), 
(1005, 105, 5, 'Salary', 38000.00, '2024-02-12'), 
(1006, 106, 1, 'Savings', 95000.00, '2023-06-18'),
insert into Accounts
values
(1007, 107, 4, 'Current', 175000.00, '2020-09-25'), 
(1008, 108, 2, 'Savings', 52000.00, '2024-07-11')


select * from Accounts
select * from Customers
select * from Branches

CREATE TABLE Transactions
 ( 
 TransactionID INT PRIMARY KEY, 
 AccountID INT, 
 TransactionType VARCHAR(30),
 Amount DECIMAL(12,2), 
 TransactionDate DATE, 

 FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) 
 )

insert into Transactions(TransactionID,AccountID,TransactionType,Amount,TransactionDate)
values
(5001, 1001, 'UPI', 5000.00, '2026-09-01'),
 (5002, 1001, 'Deposit', 15000.00, '2026-09-03'), 
(5003, 1002, 'UPI', 2500.00, '2026-09-04'), 
(5004, 1003, 'NEFT', 30000.00, '2026-09-05'), 
(5005, 1004, 'Withdrawal', 5000.00, '2026-09-06'), 
(5006, 1005, 'Salary Credit', 45000.00, '2026-09-07'), 
(5007, 1006, 'UPI', 3500.00, '2026-09-08'),
 (5008, 1007, 'IMPS', 20000.00, '2026-09-09'),
 (5009, 1008, 'Deposit', 10000.00, '2026-09-10'), 
(5010, 1003, 'UPI', 7500.00, '2026-09-11')

select * from Transactions

create table loan
(
 LoanId int Primary Key,
 CustomerID Int,
 LoanType Varchar(50),
 LoanAmount Decimal(12,2),
 InterestRate DECIMAL(5,2),
 LoanStatus Varchar(50),

FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

insert into loan(LoanId,CustomerID,LoanType,LoanAmount,InterestRate,LoanStatus)
values 
(9001, 101, 'Home Loan', 2500000.00, 8.50, 'Active'),
(9002, 102, 'Personal Loan', 500000.00, 11.25, 'Active'),
(9003, 103, 'Car Loan', 800000.00, 9.25, 'Closed'),
(9004, 104, 'Education Loan', 600000.00, 8.75, 'Active'),
(9005, 106, 'Home Loan', 3500000.00, 8.40, 'Active'),
(9006, 107, 'Business Loan', 5000000.00, 10.50, 'Active')

select * from Customers


SELECT
    c.CustomerName,
    a.AccountID,
    a.Account_Type,
    a.Balance,
    b.Branch_Name,
    b.City
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
INNER JOIN Branches b
    ON a.BranchID = b.BranchID;

---Procedure 1 to Get Customer Account
CREATE PROCEDURE GetCustomerAccount
    @CustomerID INT
AS
BEGIN

    SELECT
        c.CustomerID,
        c.CustomerName,
        c.Mobile_NO,
        a.AccountID,
        a.Account_Type,
        a.Balance
    FROM Customers c
    INNER JOIN Accounts a
        ON c.CustomerID = a.CustomerID
    WHERE c.CustomerID = @CustomerID;

END;
---execute(search) via CustomerID 
EXEC GetCustomerAccount 106;

---Procedure 2 — Get Transaction History

CREATE PROCEDURE GetTransactionHistory
    @AccountID INT
AS
BEGIN

    SELECT
        t.TransactionID,
        t.AccountID,
        t.TransactionType,
        t.Amount,
        t.TransactionDate
    FROM Transactions t
    WHERE t.AccountID = @AccountID
    ORDER BY t.TransactionDate DESC;

END;

select * from Transactions

---Execute(search) via Account ID
EXEC GetTransactionHistory 1001;

---Procedure 3 — Get Loan Report
CREATE PROCEDURE GetLoanReports
    @LoanStatus VARCHAR(30)
AS
BEGIN

    SELECT
        c.CustomerName,
        l.LoanType,
        l.LoanAmount,
        l.InterestRate,
        l.LoanStatus
    FROM Loan l
    INNER JOIN Customers c
        ON l.CustomerID = c.CustomerID
    WHERE l.LoanStatus = @LoanStatus
    ORDER BY l.LoanAmount DESC;

END;

select * from loan

---Execute(search) via Loan Status 
EXEC GetLoanReports 'closed';







 

