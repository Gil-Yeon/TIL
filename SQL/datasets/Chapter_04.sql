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

-- p.115
-- 국가별 Top Product 및 매출
-- 미국의 연도별 Top5 차량 모델 추출 --> 매출액 기준
-- order, orderdetails, customers 테이블 지금까지 사용
-- products 테이블 추가 필요
USE classicmodels;
create table product_sales as
select
	D.productname
    , SUM(quantityordered * priceeach) as sales
from orders A
left join customers B on A.customernumber = B.customernumber
left join orderdetails C on A.ordernumber = C.ordernumber
left join products D on C.productcode = D.productcode
where B.country = 'USA'
group by 1;

select *
from product_sales;

SELECT * 
FROM (
	SELECT *
    , ROW_NUMBER() OVER(ORDER BY sales DESC) RNK
    FROM product_sales) A
WHERE RNK <= 5
ORDER BY RNK;

-- [Churn Rate(%)]
-- 이탈고객
-- max(구매일,접속일) 이후 일정기간 구매, 접속하지 않은 상태
select
	MAX(orderdate) mx_order -- 마지막 구매일
    , MIN(orderdate) mn_order -- 최초 구매일
from orders;

-- 2005-06-01일 기준으로 각 고객의 마지막 구매일이 며칠 소요되는가?
select
	customernumber
    , MIN(orderdate) '최초 구매일' -- 최초 구매일
	, MAX(orderdate) '마지막 구매일' -- 마지막 구매일
from orders
group by 1
order by 1;

-- DATADIFF 사용(date1, date2)
select
	customernumber
    , MAX(orderdate) MX_ORDER -- 이 테이블의 마지막 구매일(전 고객 기준)
							  -- group by 마지막 구매일(각 고객 기준)
from orders
group by 1;

select
	customernumber
    , MX_ORDER
    , '2005-06-01'
    , DATEDIFF('2005-06-01', MX_ORDER) DIFF
from(
select
	customernumber
    , MAX(orderdate) MX_ORDER 
from orders
group by 1) BASE;


-- p.119 하단
-- 조건 DIFF가 90일 이상이면 Churn이라고 가정한다.
select
	customernumber
    , MX_ORDER
    , '2005-06-01'
    , DATEDIFF('2005-06-01', MX_ORDER) DIFF
from(
select
	customernumber
    , MAX(orderdate) MX_ORDER 
from orders
group by 1) BASE;

select
	*
	,case when DIFF >= 90 then 'Churn'
	else 'Non Churn'
    end CHURN_TYPE
from(
	select
		customernumber
		, MX_ORDER
		, '2005-06-01'
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF
	from(
		select
			customernumber
			, MAX(orderdate) MX_ORDER 
		from orders
		group by 1) BASE1
) BASE2;

-- CHURN Rate
select
	case when DIFF >= 90 then 'Churn'
	else 'Non Churn'
    end CHURN_TYPE
    , count(distinct customernumber) N_CUS
from(
	select
		customernumber
		, MX_ORDER
		, '2005-06-01'
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF
	from(
		select
			customernumber
			, MAX(orderdate) MX_ORDER 
		from orders
		group by 1) BASE1
) BASE2
group by 1;

select 69/(69+29);

-- CHURN 고객이 가장 많이 구매한 productline
CREATE TABLE churn_list AS 
SELECT 
	CASE WHEN DIFF >= 90 THEN 'CHURN ' ELSE 'NON-CHURN' END CHURN_TYPE
    , customernumber
FROM 
	(
		SELECT 
			customernumber
			, mx_order
			, '2005-06-01' END_POINT
			, DATEDIFF('2005-06-01', mx_order) DIFF
		FROM
			(
				SELECT 
					customernumber
					, max(orderdate) mx_order
				FROM orders
				GROUP BY 1
			) BASE
    ) BASE
;

select *
from churn_list;

select * 
from productlines;

-- p.122
select
	D.churn_type
	, C.productline
    , count(distinct B.customernumber) BU
from orderdetails A
left join orders B on A.ordernumber = B.ordernumber
left join products C on A.productcode = C.productcode
left join churn_list D on B.customernumber = D.customernumber
group by 1, 2;

select *
from payments;