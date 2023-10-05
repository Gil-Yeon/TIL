use classicmodels;

-- 매출액
-- 주문일자는 orders 테이블에 존재
-- 판매액은 orderdetails에 존재

select
	A.orderdate
    , priceeach * quantityordered
from orders A left join orderdetails B on A.ordernumber = B.ordernumber;

select
	orderdate
    , sum(priceeach * quantityordered) as 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by A.orderdate;

--  월별 매출액 조회
-- substr(칼럼, 위치, 길이)
-- 인덱스가 1부터 시작
select substr('abcde', 2, 2), substr('abcde', 3, 2), substr('abcde', 4, 2);

select substr(A.orderdate, 1, 7) as MM, sum(priceeach * quantityordered) as 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by MM; -- oracle에서는 이렇게 하면 에러 나고 as나 1로 말고 select의 값을 그대로 가져와야 한다.

-- 구매자 수, 구매 건수(일자별, 월별, 연도별)
select
	orderdate
    , customernumber
    , ordernumber
from orders;

select
	count(distinct customernumber) as 구매자수
    , count(orderNumber) as 구매건수
from orders;

select
	orderdate
    , count(customernumber) as 구매자수
    , count(ordernumber) as 구매건수
from orders
group by 1;

select
	A.*
from (
	select
	orderdate
    , count(customernumber) as 구매자수
    , count(ordernumber) as 구매건수
	from orders
	group by 1
) A
where A.구매자수 >= 2;

-- 연도별 구매자수와 매출액
select
	substr(A.orderdate, 1, 4) YY
	, count(A.customernumber) as 구매자수
    , sum(priceEach * quantityOrdered) as 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by 1;

-- 인당 매출액을 구한다.
-- Logic = 매출액 / 구매자수
select
	substr(A.orderdate, 1, 4) YY
	, count(A.customernumber) as 구매자수
    , sum(priceEach * quantityOrdered) as 매출액
    , sum(priceEach * quantityOrdered) / count(A.customernumber) as ATV
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by 1;

select A.*
from(
select
	substr(A.orderdate, 1, 4) YY
	, count(A.customernumber) as 구매자수
    , sum(priceEach * quantityOrdered) as 매출액
    , sum(priceEach * quantityOrdered) / count(A.customernumber) as ATV
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by 1
) A
where A.ATV > 3300;

-- 건당 매출액을 구한다.
select
ordernumber, count(*)
from orderdetails
group by ordernumber;

select
	substr(A.orderdate, 1, 4) YY
	, count(distinct A.ordernumber) as 구매건수
    , sum(priceEach * quantityOrdered) as 매출액
    , sum(priceEach * quantityOrdered) / count(distinct A.ordernumber) as ATV
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
group by 1;

-- 96p
-- 그룹별 구매 지표 구하기
-- 국가별, 도시별 매출액
-- 북미 vs 비북미 매출액 비교
-- 매출 top5 국가 및 매출
-- 국가별 top product 및 매출
select *
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
left join customers C on A.customerNumber = C.customerNumber;

select C.country, C.city, sum(B.priceEach * B.quantityOrdered) as 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
left join customers C on A.customerNumber = C.customerNumber
group by 1, 2
order by 1, 2;

select
	country,
	case when country in ('USA', 'CANADA') then '북미'
	else '비북미'
    end country_grp
from customers;

-- 북미 vs 비북미 매출액 비교
select 
	case when country in ('USA', 'CANADA') then '북미'
	else '비북미'
    end country_grp
	, sum(B.priceEach * B.quantityOrdered) as 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
left join customers C on A.customerNumber = C.customerNumber
group by 1
order by 1;

-- 매출 top5 국가 및 매출
select
	quantityordered
    , rank() over(order by quantityOrdered desc) as 'RANK'
    , dense_rank() over(order by quantityOrdered desc) as 'DENSE RANK'
    , row_number() over(order by quantityOrdered desc) as 'ROW NUMBER'
from orderdetails;

create table stat as
select
	C.country
    , sum(priceeach * quantityordered) 매출액
from orders A left join orderdetails B on A.ordernumber = B.ordernumber
left join customers C on A.customerNumber = C.customerNumber
group by 1
order by 2 desc;

select * from stat;

select
	country
    , 매출액
    , DENSE_RANK() OVER (ORDER BY 매출액 DESC) RNK
from stat;

-- 교재에서는 새로운 테이블 또 생성
-- 여기에서는 서브쿼리로 구현
select A.*
from (
	select
		country
		, 매출액
		, DENSE_RANK() OVER (ORDER BY 매출액 DESC) RNK
	from stat
) A
where RNK between 1 and 5;

-- p.107 서브쿼리
-- p.111 재구매율(retention rate) -> 매우매우매우 중요한 마케팅 기념
-- p.112 (셀프조인)
select
	a.customernumber
    , a.orderdate
    , b.customernumber
    , b.orderdate
from orders a
left join orders b on a.customernumber = b.customerNumber and substr(A.orderdate, 1, 4) = substr(B.orderdate, 1, 4) -1;

-- A 국가 거주 구매자 중 다음 연도에서 구매를 한 구매자의 비중
select
	C.country
    , substr(A.orderdate, 1, 4) YY
    , count(distinct A.customerNumber) BU_1
    , count(distinct B.customerNumber) BU_2
    , count(distinct B.customerNumber) / count(distinct A.customerNumber) 재구매율
from orders a
left join orders b on a.customernumber = b.customerNumber and substr(A.orderdate, 1, 4) = substr(B.orderdate, 1, 4) -1
left join customers c on a.customernumber = c.customernumber
group by 1, 2;