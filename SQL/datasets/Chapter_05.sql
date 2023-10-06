use mydata;

select count(*)
from dataset2;

select *
from dataset2;

-- a) division별 평균 평점
select
	`division name`
    , avg(Rating) avg_rate
from dataset2
group by 1
order by 2 desc;

-- b) department별 평균 평점
select
	`department name`
    , avg(Rating) avg_rate
from dataset2
group by 1
order by 2 desc;

-- department가 Trend인 경우 평점 3점 이하 리뷰
select *
from dataset2
where `department name` = 'trend' and rating <=3;

select
	case when age between 0 and 9 then '0009'
	when age between 10 and 19 then '1019'
    when age between 20 and 29 then '2029'
    when age between 30 and 39 then '3039'
    when age between 40 and 49 then '4049'
    when age between 50 and 59 then '5059'
    when age between 60 and 69 then '6069'
    when age between 70 and 79 then '7079'
    when age between 80 and 89 then '8089'
    when age between 90 and 99 then '9099'
    end AGEBAND
    , age
from dataset2
where `department name` = 'trend' and rating <= 3;

-- floor 메서드(내림)으로 대체 case when 활용 쿼리는 너무 복잡함
select
	floor(age/10) * 10 as ageband
    , age
from dataset2
where `department name` = 'trend' and rating <= 3;

select
	floor(age/10) * 10 as ageband
    , count(*) cnt
from dataset2
where `department name` = 'trend' and rating <= 3
group by 1
order by 2 desc;

select
	a.ageband
    , a.cnt
    , rank() over(order by a.cnt desc) as 'RANK'
from (
	select
		floor(age/10) * 10 as ageband
		, count(*) cnt
	from dataset2
	where `department name` = 'trend' and rating <= 3
	group by 1
) a;

-- department별 연령별 리뷰 수
select
	floor(age/10) * 10 as ageband
	, count(*) cnt
from dataset2
where `department name` = 'trend'
group by 1
order by 2 desc;

-- 50대 3점 이하 Trend 리뷰 살펴보기
-- 리뷰 주 내용이 사이즈 불만 
select *
from dataset2
where `department name` = 'Trend' and rating <= 3 and age between 50 and 59
limit 10;

-- p.134
-- 평점이 낮은 상품의 주요 complain
-- department Name, clothing id별 평균 평점 계산
select
	`department name`
    ,`clothing id`
    ,avg(rating) as avg_rate
from dataset2
group by 1, 2;

-- department별로 평균 평점을 기준으로 순위를 매긴다.
select
	*
    , row_number() over(partition by `department name` order by a.avg_rate) as RNK
from(
	select
		`department name`
		,`clothing id`
		,avg(rating) as avg_rate
	from dataset2
	group by 1, 2
) a;

-- 1~10위 데이터 조회
-- 평균 평점이 낮은 데이터 추출하기 위해(상위 10개)
select *
from (
	select
		*
		, row_number() over(partition by `department name` order by a.avg_rate) as RNK
	from(
		select
			`department name`
			,`clothing id`
			,avg(rating) as avg_rate
		from dataset2
		group by 1, 2
	) a
) a
where rnk <= 10;

-- clothing ID만 추출한 뒤, 각 부서별 리뷰 텍스트
create temporary table stat as
select *
from (
	select
		*
		, row_number() over(partition by `department name` order by a.avg_rate) as RNK
	from(
		select
			`department name`
			,`clothing id`
			,avg(rating) as avg_rate
		from dataset2
		group by 1, 2
	) a
) a
where rnk <= 10;

select * from stat;

-- 부서명 : Bottoms 
-- 18, 588, 1039, 1058
select
	`department name`
	, `clothing id`
	, `Review Text`
from dataset2
where `department name` = 'bottoms' and `clothing id` in (18, 588, 1039, 1058);

select `clothing id`
from dataset2
where `clothing id` in (select `clothing id` from stat where `department name` = 'bottoms');

-- p. 139
-- 연령별 worst department
-- 각 연령대별로 가장 낮은 점수를 준 Department를 구하고,
-- 해당 Department의 할인 쿠폰을 발송한다.
select
	`department name`
    , floor(age/10)*10 ageband
    , avg(rating) avg_rating
from dataset2
group by 1,2;

select
	*
    , row_number() over(partition by a.ageband order by a.avg_rating) RNK
from (
	select
		`department name`
		, floor(age/10)*10 ageband
		, avg(rating) avg_rating
	from dataset2
	group by 1,2
) a;

select *
from(
	select
		*
		, row_number() over(partition by a.ageband order by a.avg_rating) RNK
	from (
		select
			`department name`
			, floor(age/10)*10 ageband
			, avg(rating) avg_rating
		from dataset2
		group by 1,2
	) a
) a
where rnk = 1;