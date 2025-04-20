CREATE DATABASE project;
USE project;

CREATE TABLE Finance1(
	id INT NOT NULL,
	member_id INT,
	loan_amnt INT,
	funded_amnt INT,
	funded_amnt_inv INT,
    term VARCHAR(25),
    int_rate VARCHAR(10),
    installment INT,
    grade VARCHAR(10),
    sub_grade VARCHAR(10),
    emp_title VARCHAR(300),
    emp_length VARCHAR(255),
    home_ownership VARCHAR(50),
    annual_inc INT,
    verification_status VARCHAR(50),
    issue_d VARCHAR(10),
    loan_status VARCHAR(50),
    pymnt_plan VARCHAR(50),
    `desc` VARCHAR(5000),
    purpose VARCHAR (50),
    title VARCHAR(555),
    zip_code VARCHAR(6),
    addr_state VARCHAR(50),
    dti DECIMAL(2.0),
    
    PRIMARY KEY(id)
);

LOAD DATA INFILE 'D:\\Data Analyst\\Project\\Working_Dataset\\Finance_1.csv'
INTO TABLE Finance1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Finance1;
SELECT COUNT(*) FROM Finance1;


CREATE TABLE Finance2(
	id INT ,
    delinq_2yrs INT,
    earliest_cr_line VARCHAR(50),
    inq_last_6mths INT,
    mths_sience_last_delinq VARCHAR(50),
	mths_sience_last_record VARCHAR(50),
    open_acc INT,
    pub_rec INT,
    revol_bal INt,
    revol_util VARCHAR(50),
    total_acc INT,
    initial_list_status VARCHAR(50),
    out_prncp INT,
    out_prncp_inv INT,
    total_pymnt INt,
    total_pymnt_inv INT,
    total_rec_prncp INT,
    total_rec_int INT,
    total_rec_late_fee INT,
    recoveries INT,
    collection_rec_fee INT,
    last_pymnt_d VARCHAR(10),
    last_pymnt_amnt INT,
    next_pymnt_d VARCHAR(10),
    last_credit_pull_d varchar(20)
);

LOAD DATA INFILE 'D:\\Data Analyst\\Project\\Working_Dataset\\Finance_2.csv'
INTO TABLE Finance2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Finance2;
SELECT COUNT(*) FROM Finance2;


#########################################################################################################################################################
################################################						KPI's					#########################################################
#########################################################################################################################################################

##### KPI 1 (YEAR WISE LOAN AMOUNT STATS) #####
select year(issue_d) as Year, sum(loan_amnt) as Total_Loan_amnt 
from Finance1 group by Year order by year;


##### KPI 2 (GRADE AND SUB GRADE WISE REVOL_BAL) #####
select grade, sub_grade,sum(revol_bal) as total_revol_bal
from Finance1 F1 inner join  Finance2 F2 
on(F1.id = F2.id) 
group by grade,sub_grade
order by grade;


##### KPI 3 (Total Payment for Verified Status Vs Total Payment for Non Verified Status) #####
select verification_status, sum(total_pymnt) as Total_payment
from Finance1 F1 inner join  Finance2 F2 
on(F1.id = F2.id) 
where verification_status in('Verified', 'Not Verified')
group by verification_status;


##### KPI 4 (State wise and last_credit_pull_d wise loan status) #####
select addr_state as "State", max(last_credit_pull_d) as "Last Date" ,loan_status, count(loan_status) as "No of Loans"
from Finance1 F1 inner join  Finance2 F2 
on(F1.id = F2.id)
group by addr_state, loan_status
order by addr_state;


##### KPI 5 (Home ownership Vs last payment date stats) #####
Select home_ownership, max(last_pymnt_d) as "Last Payment Date", sum(loan_amnt) as 'Payment Amount'
from  Finance2 F2 join Finance1 F1
on(F1.id=F2.id)
group by home_ownership
order by home_ownership;