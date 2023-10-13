-- 오전 : 기초문법
-- 오후 : 서브쿼리 & 윈도우 함수

CREATE TABLE develop_book(
	book_id integer,
	pub_date integer,
	book_name varchar(80),
	price money
);

INSERT INTO develop_book
VALUES(1, 20231013, '책', 3000);

SELECT * FROM develop_book;

-- 날짜 및 시간
CREATE TABLE datetime_study(
	type_ts timestamp,
	type_tstz timestamptz,
	type_date date,
	type_time time
);

INSERT INTO datetime_study
VALUES ('2023-10-13 10:00:01+09', '2023-10-13 10:00:02+09', '2023-10-13', '10:00:01');

SELECT * FROM datetime_study;

-- 배열형이 들어간 테이블
CREATE TABLE contact_info(
	cont_id numeric(3),
	name varchar(15),
	tel integer[],
	email varchar
);

-- 데이터 추가
INSERT INTO contact_info
VALUES (001, 'good', array[01012345678,01055123678], 'abc@gmail.com');

SELECT * FROM contact_info;

INSERT INTO contact_info
VALUES (001, 'kim', '{01012345678,01055123678}', 'abc@gmail.com');

SELECT * FROM contact_info;

-- JSON형
CREATE TABLE develop_book_order(
	id numeric(3),
	order_info json not null
);

INSERT INTO develop_book_order
VALUES(001, '{"customer" : "evan", "books" : {"product" : "postgreSQL", "qty":2}}');

SELECT * FROM develop_book_order;

-- 형변환 : CAST 메서드 활용
SELECT CAST('3000' AS integer);

SELECT * from develop_book;

SELECT book_id, CAST(pub_date as varchar) FROM develop_book;
SELECT book_id, pub_date::varchar FROM develop_book;

-- 제품정보, 주문, 공장, 고객 테이블 생성
-- Primary Key, Foreign Key 미 기재
CREATE TABLE prod_info(
	prod_no    NUMERIC(5),
	prod_name  VARCHAR(40),
	prod_date  DATE, 
	prod_price MONEY,
	fact_no    NUMERIC(7)
);

CREATE TABLE prod_order(
	ord_no     NUMERIC(6), 
	cust_id    CHAR(8), 
	prod_name  VARCHAR(40), 
	qty        NUMERIC(1000), 
	prod_price MONEY, 
	ord_date   TIMESTAMPTZ
);

CREATE TABLE factory(
	fact_no    NUMERIC(7), 
	fact_name  VARCHAR(45), 
	city       VARCHAR(25), 
	fact_admin VARCHAR(40), 
	fact_tel   NUMERIC(11), 
	prod_name  VARCHAR[], 
	estab_date DATE
);

CREATE TABLE customer(
	cust_id    CHAR(8), 
	cust_name  VARCHAR(40), 
	cust_tel   NUMERIC(11), 
	email      VARCHAR(100), 
	birth      NUMERIC(6), 
	identify   BOOLEAN
);

-- 도메인 무결성
-- 숫자가 0~9의 숫자만 입력되도록
CREATE DOMAIN phoneint AS integer CHECK (VALUE > 0 AND VALUE < 9);

-- 테이블 생성
CREATE TABLE domain_type_study(
	id phoneint
);

INSERT INTO domain_type_study values(1); -- 성공
INSERT INTO domain_type_study values(10); -- 실패

SELECT * FROM domain_type_study;

-- 5가지 제약 조건
-- NOT NULL
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id		numeric(3) 	not null,
	name		varchar(15) not null,
	tel			integer[] 	not null,
	email 		varchar
);

-- INSERT 테스트(NULL인 값을 넣어서)

-- NOT NULL & UNIQUE
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id		numeric(3) 	unique not null,
	name		varchar(15) not null,
	tel			integer[] 	not null,
	email 		varchar
);

-- 여러 칼럼에 UNIQUE 적용
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id		numeric(3) 	unique not null,
	name		varchar(15) not null,
	tel			integer[] 	not null,
	email 		varchar,
	unique(cont_id, tel, email)
);

-- 기본키 지정
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info(
	cont_id		serial  not null primary key,
	name		varchar(15) not null,
	tel			integer[] 	not null,
	email 		varchar
);

INSERT INTO contact_info(email) VALUES('abc@gmail.com')

-- 외래키 지정
CREATE TABLE book(
	book_id		serial  	not null,
	name		varchar(15) not null,
	admin_no	serial 		not null references contact_info(cont_id),
	email 		varchar,
	primary key (book_id, admin_no)
);

-- 학교 / 수업, 선생님
CREATE TABLE subject(
	subj_id		numeric(5)	not null primary key,
	subj_name	varchar(10)	not null
);

INSERT INTO subject VALUES(00001, '수학'), (00002, '과학'), (00003, '사회');

CREATE TABLE teacher(
	teac_id				numeric(5)	not null primary key,
	teac_name			varchar(20)	not null,
	subj_id				numeric(5)	references subject, -- 여기서는 부모 테이블의 컬럼 명과 외래키의 이름이 subj_id로 같기 때문에 subject(subj_id)에서 컬럼 명을 생략한다.
	teach_certifi_date	date
);

select * from subject;

insert into teacher values(00011, '정선생', 00001, '2023-10-12');
insert into teacher values(00012, '김선생', 00002, '2023-10-12');
insert into teacher values(00013, '박선생', 00003, '2023-10-12');
insert into teacher values(00014, '이선생', 00004, '2023-10-12'); -- 부모 테이블(참조되는 테이블)에 subj_id에 해당하는 키가 없으므로 오류

select * from teacher;

-- CASE WHEN
select * from student_score;

select
	case when id = 1 then 1 else 0 end id
	, name
	, score
from student_score;

select
	id
	, name
	, score
	, case when score <= 100 and score >= 90 then 'A'
	when score <= 89 and score >= 80 then 'B'
	when score <= 79 then 'F'
	end as grade
from student_score;

select * from real_amount;
select * from assumption_amount;

-- exists는 존재하기만 한다면 조건을 만족하는 것으로 의미
select *
from real_amount
where exists (select * from assumption_amount);

select *
from real_amount
where exists (select * from exception);

-- postgresql substr
select substr('good_123456789', 1, 4);

select left('good_123456789', 4);

-- Question 1
-- 2015년 평균 기대수명 보다 1.15배보다 높은 모든 데이터를 조회
select * from populations;

-- 메인쿼리
select *
from populations;
-- 서브쿼리
select avg(life_expectancy)
from populations
where year = 2015;

-- 최종쿼리
select *
from populations
where life_expectancy > 1.15 * (select avg(life_expectancy) from populations where year = 2015);

-- Question 2
-- countries 테이블에서 Captial 컬럼과 매칭되는 cities 테이블의 필드를 조회
-- urbanarea_pop 내림차순을 기준으로 정렬
select * from countries;
select * from cities;

select
	name
	, country_code
	, urbanarea_pop
from cities
where name in (select capital from countries)
order by urbanarea_pop desc;

-- Question 3
-- countries 테이블과, cities 테이블을 서로 조인하여 국가별 도시 갯수를 계산
select * from countries;
select * from cities;

select
    a.name as country,
    (select count(*) from cities where country_code = a.code) as cities_num
from countries a
order by 2 desc;

-- Question 4
-- 2015년, 각 대륙별 가장 높은 인플레이션을 기록한 국가와 인플레이션을 조회
-- 테이블명 : countries, economies
select * from countries;
select * from economies;

select *
from countries a inner join economies b on a.code = b.code;

select
	continent
	, max(inflation_rate) as inflation_rate
from countries a inner join economies b on a.code = b.code
group by 1;

select
	b.name
	, a.continent
	, a.inflation_rate
from
	(select
		continent
		, max(inflation_rate) as inflation_rate
	from countries a inner join economies b on a.code = b.code
	where year = 2015
	group by 1) a
	inner join
	(select *
	from countries a inner join economies b on a.code = b.code) b
	on a.inflation_rate = b.inflation_rate;