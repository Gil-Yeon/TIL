use classicmodels;

-- select 
SELECT customernumber, phone FROM customers;

-- count : 행의 갯수, 각 칼럼의 값의 갯수 파악
select count(checknumber) from payments;
select count(*) from payments;

-- 테이블 정의서로 테이블의 형태 파악
select sum(amount) from payments;

select productname, productline
from products;

-- 컬럼명 변경
select count(productcode) as n_products
from products;

-- 교재 31p
-- distinct 중복 제외하고 데이터 조회!
select distinct ordernumber
from orderdetails;

select count(ordernumber) as 중복포함, count(distinct ordernumber) as 중복제거
from orderdetails;

-- where, between
select *
from orderdetails
where priceeach between 30 and 50;

-- where, 대소관계 연산자
select *
from orderdetails
where priceeach < 30;

select *
from orderdetails
where orderNumber = 10110;

-- where, in
select customernumber, country
from customers
where country in ('USA');

-- where, is null
select employeenumber
from employees
where reportsto is null;

select employeenumber
from employees
where reportsto is not null;

-- where, like
-- %는 문자를 의미
select addressline1
from customers
where addressline1 like '%st%';

select addressline1
from customers
where addressline1 like '%st_';

-- group by
SELECT country, city, count(customernumber) AS n_customers
FROM customers
GROUP BY country, city;

select customernumber, checknumber, sum(amount)
from payments
group by customernumber, checknumber;

use instarcart;
use classicmodels;

-- case when : if 조건문
-- p.46, USA 거주자의 수 계산, 그 비중을 구하자

select sum(case when country = 'USA' then 1 else 0 end) N_USA
from customers;

select count(*)
from customers
where country = 'USA';

select country, case when country = 'USA' then 1 else 0 end N_USA
from customers;

select
	sum(case when country = 'USA' then 1 else 0 end) n_usa,
    count(*),
    sum(case when country = 'USA' then 1 else 0 end) / count(*) as usa_portion
from customers;

-- join
-- 실무에서는 erd를 그림을 보면서, 어떻게 join 할 것인지 계획을 짬
select A.customernumber, A.ordernumber, B.country
from orders A left join customers B on A.customernumber = B.customernumber;

select *
from orders A left join customers B on A.customernumber = B.customernumber
where B.country = 'USA';

select *
from orders A inner join customers B on A.customernumber = B.customernumber
where B.country = 'USA';

-- Full join
select *
from orders A full join customers B on A.customernumber = B.customernumber;

-- 58p
-- 윈도우 함수 : Rank, Dense_Rank, Row_Number
-- 중요함!
select
	buyprice,
	row_number() over(order by buyprice) rownumber,
    rank() over(order by buyprice) rnk,
    dense_rank() over(order by buyprice) denserank
from products;

select
	productline,
	buyprice,
	row_number() over(partition by productline order by buyprice) rownumber,
    rank() over(partition by productline order by buyprice) rnk,
    dense_rank() over(partition by productline order by buyprice) denserank
from products;

-- 62p
-- SubQuerey : 실무에서 매우 중요!!!!
-- 쿼리 안에 또 다른 쿼리 사용(갯수는 무제한)

