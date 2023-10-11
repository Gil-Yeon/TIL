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
from(
	select customerid, min(invoicedate) mndt from dataset3 group by 1) a
	left join (select customerid, invoicedate, UnitPrice*Quantity sales from dataset3) b
	on a.customerid = b.customerid
group by 1, 2;