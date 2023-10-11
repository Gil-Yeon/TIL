-- 6장
use instacart;

-- 156p
select *
from aisles;

select *
from departments;

select *
from order_products__prior;

select *
from orders;

select *
from products;

-- 전체 주문건수 158
select count(distinct order_id) F
from orders;

select
	b.product_name
    , count(distinct a.order_id) f
from order_products__prior a
left join products b on a.product_id = b.product_id
group by 1
order by 2 desc;

-- 구매자 수 160
select count(distinct user_id) bu
from orders;

-- 상품별 주문 건수 160
select *
from order_products__prior a
left join products b on a.product_id = b.product_id;

select 
	product_name
	, count(distinct order_id) f
from order_products__prior a
left join products b on a.product_id = b.product_id
group by 1;

-- 장바구니에 가장 먼저 넣는 상품 10개 162
select *
from order_products__prior;

select
	product_id
    , case when add_to_cart_order = 1 then 1 else 0 end f_1st
from order_products__prior;

select
	product_id
    , sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
from order_products__prior
group by 1;

select
	a.*
    , row_number() over(order by f_1st desc) rnk
from (
	select
		product_id
		, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
	from order_products__prior
	group by 1
)a;

select *
from(
select
	*
    , row_number() over(order by f_1st desc) rnk
from (
	select
		product_id
		, sum(case when add_to_cart_order = 1 then 1 else 0 end) f_1st
	from order_products__prior
	group by 1
) a
) a
where rnk <= 10;

-- 시간별 주문 건수 167
select *
from orders;

select
	order_hour_of_day
    , count(*)
from orders
group by 1
order by 1;

-- 첫 구매 후 다음까지 걸린 평균 일수 168
select avg(days_since_prior_order) avg_recency
from orders
where order_number = 2;

-- 주문 건당 평균 구매 상품 수 169
select *
from order_products__prior;

select count(product_id) / count(distinct order_id) upt
from order_products__prior;

-- 인당 평균 주문 건수 169
select *
from orders;

select count(order_id) / count(distinct user_id) avg_f
from orders;

-- 재구매율이 가장 높은 상품 10개 169
select *
from order_products__prior;

select
	product_id
    , sum(reordered) / count(*) ret_ratio
from order_products__prior
group by 1;

select
	a.*
    , row_number() over(order by ret_ratio desc) rnk
from (
	select
		product_id
		, sum(reordered) / count(*) ret_ratio
	from order_products__prior
	group by 1
)a;

select
	*
from (
	select
		*
		, row_number() over(order by ret_ratio desc) rnk
	from (
		select
			product_id
			, sum(reordered) / count(*) ret_ratio
		from order_products__prior
		group by 1
	) a
) b
where rnk <= 10;

-- 제품들의 재구매율이 1인 부분이 이상하므로 아래코드 작성해봄
select product_id
from(
	select
		product_id
        , sum(reordered) as 합계
        from order_products__prior
        group by 1
) a
where 합계 >= 10;


-- department별 재구매율이 높은 상품 10개
select
	*
from (
	select
		*
		, row_number() over(partition by department order by ret_ratio desc) rnk
	from (
		select
			c.department
			, a.product_id
			, sum(reordered) / count(*) ret_ratio
		from order_products__prior a
        left join products b on a.product_id = b.product_id
        left join departments c on b.department_id = c.department_id
		group by 1, 2
	) a
) a
where rnk <= 10;

-- where 서브쿼리 추가하여 재주문이 10보다 많은 제품의 경우에만 재구매율 도출
select
	*
from (
	select
		c.department
		, a.product_id
		, sum(reordered) / count(*) ret_ratio
	from order_products__prior a
	left join products b on a.product_id = b.product_id
	left join departments c on b.department_id = c.department_id
	group by 1, 2
) a
where product_id in (select product_id
					from(
						select
							product_id
							, sum(reordered) as 합계
							from order_products__prior
							group by 1
					) a
where 합계 >= 10);
                    
-- 랭크 나타내기
select
	*
	, row_number() over(partition by department order by ret_ratio desc) rnk
from (
	select
		*
	from (
		select
			c.department
			, a.product_id
			, sum(reordered) / count(*) ret_ratio
		from order_products__prior a
		left join products b on a.product_id = b.product_id
		left join departments c on b.department_id = c.department_id
		group by 1, 2
	) a
	where product_id in (select product_id
						from(
							select
								product_id
								, sum(reordered) as 합계
								from order_products__prior
								group by 1
						) a
						where 합계 >= 10)
) a;

-- 랭크 10위 이내만 나타내기
select
	*
from(
select
	*
	, row_number() over(partition by department order by ret_ratio desc) rnk
from (
	select
		*
	from (
		select
			c.department
			, a.product_id
			, sum(reordered) / count(*) ret_ratio
		from order_products__prior a
		left join products b on a.product_id = b.product_id
		left join departments c on b.department_id = c.department_id
		group by 1, 2
	) a
	where product_id in (select product_id
						from(
							select
								product_id
								, sum(reordered) as 합계
								from order_products__prior
								group by 1
						) a
						where 합계 >= 10)
	) a
) a
where rnk <= 10;


-- 구매자 분석 174
-- 10분위 분석
select *
from orders;

select
	*
    , row_number() over(order by f desc) rnk
from(
	select
		user_id
		, count(*) f
	from orders
	group by 1
) a;

-- 분위 수 구하기 전 전체 고객 수 구하기
select count(distinct user_id)
from orders;

-- 코드 자동화를 위해 수정
SELECT 
	*, 
    CASE WHEN RNK <= (SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10 THEN 'Quantile_1'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*2 THEN 'Quantile_2'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*3 THEN 'Quantile_3'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*4 THEN 'Quantile_4'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*5 THEN 'Quantile_5'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*6 THEN 'Quantile_6'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*7 THEN 'Quantile_7'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*7 THEN 'Quantile_7'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*8 THEN 'Quantile_8'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*9 THEN 'Quantile_9'
	when rnk <= ((SELECT COUNT(DISTINCT user_id)
						FROM 
							(SELECT 
								user_id
								, COUNT(DISTINCT order_id) F
							 FROM orders
							 GROUP BY 1
						) A)/10)*10 THEN 'Quantile_10' end quantile
FROM (
	SELECT 
		*
		, ROW_NUMBER() OVER(ORDER BY F DESC) RNK
	FROM (
		SELECT 
			user_id
			, COUNT(DISTINCT order_id) AS F
		FROM 
			orders
		GROUP BY 1
	) A
) A 
;

-- user_id별 분위 수 정보 테이블 생성
create temporary table user_quantile as
select
	*
    , case when rnk <= 316 then 'Quantile_1'
    when rnk <= 632 then 'Quantile_2'
    when rnk <= 948 then 'Quantile_3'
    when rnk <= 1264 then 'Quantile_4'
    when rnk <= 1580 then 'Quantile_5'
    when rnk <= 1895 then 'Quantile_6'
    when rnk <= 2211 then 'Quantile_7'
    when rnk <= 2527 then 'Quantile_8'
    when rnk <= 2843 then 'Quantile_9'
    when rnk <= 3159 then 'Quantile_10' end quantile
from(
	select
		*
		, row_number() over(order by f desc) rnk
	from(
		select
			user_id
			, count(*) f
		from orders
		group by 1
	) a
) a;

select *
from user_quantile;

-- 각 분위 별 주문 건수 179
select
	quantile
    , sum(f)
from user_quantile
group by 1;

-- 각 분위 별 주문 건수의 비율

-- 전체 주문 건수
select sum(f)
from user_quantile;

select
	quantile
	, sum(f) / 3220 f
from user_quantile
group by 1;

-- 상품 분석 181
select *
from order_products__prior;

select
	product_id
    , sum(reordered) / count(*) reorder_rate
    , count(distinct order_id) f
from order_products__prior
group by 1
order by 2 desc;

select
	a.product_id
    , b.product_name
    , sum(reordered) / count(*) reorder_rate
    , count(distinct order_id) f
from order_products__prior a
left join products b on a.product_id = b.product_id
group by 1, 2
having count(distinct order_id) > 10
order by 1;

-- 다음 구매까지의 소요기간, 재구매 관계
select
	*
    , row_number() over(order by ret_ratio desc) rnk
from(
	select
		product_id
        , sum(reordered) / count(*) ret_ratio
	from order_products__prior
    group by 1
) a;

-- 전체 상품 수
select count(distinct product_id)
from order_products__prior;

-- 상품 10개 그룹으로 나누기 자동화
create temporary table product_repurchase_quantile as
select
	*
    , case when rnk <= (select count(distinct product_id)
						from order_products__prior)/10 then 'Q_1'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 2 then 'Q_2'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 3 then 'Q_3'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 4 then 'Q_4'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 5 then 'Q_5'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 6 then 'Q_6'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 7 then 'Q_7'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 8 then 'Q_8'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 9 then 'Q_9'
          when rnk <= ((select count(distinct product_id)
						from order_products__prior)/10) * 10 then 'Q_10' end rnk_grp
from(
	select
		a.product_id
		, row_number() over(order by ret_ratio desc) rnk
	from(
		select
			product_id
			, sum(reordered) / count(*) ret_ratio
		from order_products__prior
		group by 1
	) a
) a;

select *
from product_repurchase_quantile;

create temporary table order_products_prior2 as
select
	product_id
	, days_since_prior_order
from order_products__prior a
inner join orders b on a.order_id = b.order_id;

select *
from order_products_prior2;

select
	a.rnk_grp
    , a.product_id
    , variance(days_since_prior_order) var_days
from product_repurchase_quantile a
left join order_products_prior2 b on a.product_id = b.product_id
group by 1, 2
order by 1;

select
	rnk_grp
	, avg(var_days) avg_var_days
from(
	select
		a.rnk_grp
		, a.product_id
		, variance(days_since_prior_order) var_days
	from product_repurchase_quantile a
	left join order_products_prior2 b on a.product_id = b.product_id
	group by 1, 2
	order by 1
) a
group by 1; # 결론 : 재주문율이 높은 상품이라고 해서 구매 주기가 일정하지는 않다.

-- 분산분석
-- 3개 이상의 그룹 비교
-- p value 0.05 이하 ==> 대립가설 채택
-- 사후분석 ==> 두 그룹으로 쪼개서, 두 그룹간의 평균 비교
-- Q_1 vs Q_2 비교, Q_3 ... Q_10
-- Q_2 vs Q_3 비교, Q_4 ... Q_10
-- ...
-- Q_9 vs Q_10

-- 쿼리의 순서는 from where group by having select order by