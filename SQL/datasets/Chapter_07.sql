-- 7장
use mydata;

select *
from dataset3;

-- 가장 많이 팔린 상품 2개
select
	*
from(    
	select
		*
		, row_number() over(order by qty desc) rnk
	from(
		select
			stockcode
			, sum(quantity) qty
		from dataset3
		group by 1
	) a
) a
where rnk <=2;

select
	stockcode
from(    
	select
		*
		, row_number() over(order by qty desc) rnk
	from(
		select
			stockcode
			, sum(quantity) qty
		from dataset3
		group by 1
	) a
) a
where rnk <=2;

-- 가장 많이 판매된 2개 상품을 모두 구매한 구매자가 구매한 상품
create table bu_list as
select
	customerid
from dataset3
group by 1
having max(case when stockcode = '84077' then 1 else 0 end) = 1
	and max(case when stockcode = '85123A' then 1 else 0 end) = 1;
    
select customerid, stockcode
from dataset3
where customerid in (select customerid from bu_list) and stockcode not in ('84077', '85123a');

-- 국가별, 상품별 구매 지표 추출 200p
-- a고객 : 2018년, 2019년 / b고객 : 2018년 / c고객 : 2017년, 2019년에 구매
select
	a.country
    , substr(a.invoicedate, 1, 4) as yy
    , count(distinct b.customerid) / count(distinct a.customerid) r_rate
from (select distinct country, invoicedate, customerid from dataset3) a
left join (select distinct country, invoicedate, customerid from dataset3) b
on substr(a.invoicedate, 1, 4) = substr(b.invoicedate, 1, 4) - 1
and a.country = b.country
and a.customerid = b.customerid
group by 1, 2
order by 1, 2;

-- 코호트 분석 (Retention)
-- 디지털 마케팅 : 코호트 분석 (Retention) 정의, SQL 쿼리
-- google analytics에서 자동으로 만들어줌
-- 코호트 분석을 통해 특정 기간에 구매한 또는 가입한 고객들의 이후 구매액 및 리텐션
-- GA, SQL, Python(R), 엑셀(스프레드시트)

-- 고객별로 첫 구매일
select
	customerid
    , min(invoicedate) mndt
from dataset3
group by 1;

-- 각 고객의 주문일, 구매액
select
	customerid
    , invoicedate
    , UnitPrice*Quantity sales
from dataset3;

-- 코호트 분석을 위한 테이블 생성
select *
from (select customerid, min(invoicedate) mndt from dataset3 group by 1) a
left join (select customerid, invoicedate, UnitPrice*Quantity sales from dataset3) b
on a.customerid = b.customerid;

select
	substr(mndt, 1, 7) mm
    , timestampdiff(month, mndt, invoicedate) datediff
    , count(distinct a.customerid) bu
    , sum(sales) sales
from
	(select customerid, min(invoicedate) mndt from dataset3 group by 1) a
	left join (select customerid, invoicedate, UnitPrice*Quantity sales from dataset3) b
	on a.customerid = b.customerid
group by 1, 2;

-- p.206
use mydata;

-- RFM : 가치있는 고객을 추출하는 방법론, 고객 세그먼트
-- p.207
-- R - Rencency : 최근 구매일
-- F - Frequency : 구매 횟수
-- M : Monetary : 구매 금액 합계
select * from dataset3;

-- Recency : 계산해보자, 거래의 최근성을 나타내는 지표
select
	customerid
    , max(invoicedate) mxdt
from dataset3
group by 1;

-- 최근 거래날짜로부터 2011-12-02까지의 날짜차이 계산
select
	customerid
    , datediff('2011-12-02', mxdt) recency
from(
	select
		customerid
		, max(invoicedate) mxdt
	from dataset3
	group by 1
) a;

-- frequency, moneytary 계산
select
	customerid
    , count(distinct invoiceno) frequency
    , sum(quantity * unitprice) moneytary
from dataset3
group by 1;

select
	customerid
    , datediff('2011-12-02', mxdt) recency
    , frequency
    , moneytary
from (
	select
		customerid
		, max(invoicedate) mxdt
		, count(distinct invoiceno) frequency
		, sum(quantity * unitprice) moneytary
	from dataset3
	group by 1
) a;

-- 동일한 상품을 2개 연도에 걸쳐 구매한 고객과 그렇지 않은 고객을 segment로 나눔
-- 데이터가 없어도 기획력만 좋으면 파생변수로 얻는다
select
	customerid
    , stockcode
    , count(distinct substr(invoicedate, 1, 4)) unique_yy
from dataset3
group by 1, 2;

-- unique_yy가 2이상인 고객과 그렇지 않은 고객으로 구분
select
	customerid
    , max(unique_yy) mx_unique_yy
from(
	select
		customerid
		, stockcode
		, count(distinct substr(invoicedate, 1, 4)) unique_yy
	from dataset3
	group by 1, 2
) a
group by 1
order by 2 desc;

-- 문제 mx_unique_yy가 2이상이면 1 아니면 0
select
	customerid
    , case when mx_unique_yy >= 2 then 1 else 0 end repurchase_segment
from(
	select
		customerid
		, max(unique_yy) mx_unique_yy
	from(
		select
			customerid
			, stockcode
			, count(distinct substr(invoicedate, 1, 4)) unique_yy
		from dataset3
		group by 1, 2
	) a
	group by 1
) a
order by 1;

-- p213
-- 일자별 첫 구매자 수
-- 일자별 첫 구매자 수를 계산한다. -> 목적이 신규 유저를 확인하는 것
-- 예) 2006-01-01에 첫 구매한 고객수는 몇 명인지 

-- 고객 별 첫 구매일
select
	customerid
    , min(invoicedate) mndt
from dataset3
group by 1;

-- 첫 구매일별로 신규 고객 수를 count
select
	mndt
    , count(distinct customerid) bu
from(
	select
		customerid
		, min(invoicedate) mndt
	from dataset3
	group by 1
) a
group by 1;

-- p219
-- 첫 구매 후 이탈하는 고객의 비중

-- 고객 별 구매일자의 수
select
	customerid
    , count(distinct invoicedate) f_date
from dataset3
group by 1;

-- 숫자 1의 의미는 첫 구매 후 이탈한 고객
select
	customerid
	,case when f_date = 1 then 1 else 0 end b_cnt
from(
	select
		customerid
		, count(distinct invoicedate) f_date
	from dataset3
	group by 1
) a;

select
	sum(case when f_date = 1 then 1 else 0 end) / count(*) bounc_rate
from(
	select
		customerid
		, count(distinct invoicedate) f_date
	from dataset3
	group by 1
) a;

select
	customerid
	, country
	, count(distinct invoicedate) f_date
from dataset3
group by 1, 2;

select
	country
	, sum(case when f_date = 1 then 1 else 0 end) / count(*) bounc_rate
from(
	select
		customerid
		, country
		, count(distinct invoicedate) f_date
	from dataset3
	group by 1, 2
) a
group by 1
order by 1;