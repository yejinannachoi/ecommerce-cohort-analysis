USE ecommerce_db;

-- 롤링 리텐션
WITH customer_cohorts AS(
	SELECT 고객ID
		, MIN(거래날짜) AS first_order_date  -- 2019년 첫 거래일
		, MAX(거래날짜) AS last_order_date   -- 2019년 마지막 거래일
		, DATE_FORMAT(MIN(거래날짜), '%Y-%m-01') AS first_order_month  -- 2019년 첫 거래월
		, DATE_FORMAT(MAX(거래날짜), '%Y-%m-01') AS last_order_month   -- 2019년 마지막 거래월
	FROM onlinesales_info
	GROUP BY 고객ID
)

SELECT first_order_month
	, COUNT(DISTINCT 고객ID) AS month0
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) <= last_order_month THEN 고객ID END) AS month1
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) <= last_order_month THEN 고객ID END) AS month2
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) <= last_order_month THEN 고객ID END) AS month3
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) <= last_order_month THEN 고객ID END) AS month4
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) <= last_order_month THEN 고객ID END) AS month5
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) <= last_order_month THEN 고객ID END) AS month6
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) <= last_order_month THEN 고객ID END) AS month7
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) <= last_order_month THEN 고객ID END) AS month8
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) <= last_order_month THEN 고객ID END) AS month9
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) <= last_order_month THEN 고객ID END) AS month10
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) <= last_order_month THEN 고객ID END) AS month11
FROM customer_cohorts
GROUP BY first_order_month;

-- 코호트별 매출액 리텐션
WITH customer_cohorts AS(
	SELECT *
		, MIN(거래날짜) OVER (PARTITION BY 고객ID) AS first_order_date  -- 고객별 2019년 첫 거래일
	FROM onlinesales_info
),
monthly_sales AS(
	SELECT *
		, DATE_FORMAT(first_order_date, '%Y-%m-01') AS first_order_month  -- 2019년 첫 거래월
		, DATE_FORMAT(거래날짜, '%Y-%m-01') AS transaction_month  -- 해당 거래가 이루어진 달
		, SUM(수량 * 평균금액) OVER (PARTITION BY DATE_FORMAT(first_order_date, '%Y-%m-01'), DATE_FORMAT(거래날짜, '%Y-%m-01')) AS monthly_sales  -- 코호트별 매출액 합계
	FROM customer_cohorts
)

SELECT first_order_month
	, ROUND(SUM(DISTINCT CASE WHEN first_order_month = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month0
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month1
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month2
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month3
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month4
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month5
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month6
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month7
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month8
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month9
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month10
    , ROUND(SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) = transaction_month THEN monthly_sales ELSE 0 END), 2) AS month11
FROM monthly_sales
GROUP BY first_order_month
ORDER BY first_order_month;

-- 코호트별 배송료 리텐션
WITH customer_cohorts AS(
	SELECT DISTINCT 고객ID
		, 거래ID
		, 배송료
        , 거래날짜
		, MIN(거래날짜) OVER (PARTITION BY 고객ID) AS first_order_date  -- 고객별 2019년 첫 거래일
	FROM onlinesales_info
),
monthly_shipping_fee AS(
	SELECT *
			, DATE_FORMAT(first_order_date, '%Y-%m-01') AS first_order_month  -- 2019년 첫 거래월
			, DATE_FORMAT(거래날짜, '%Y-%m-01') AS transaction_month  -- 해당 거래가 이루어진 달
			, ROUND(SUM(배송료) OVER (PARTITION BY DATE_FORMAT(first_order_date, '%Y-%m-01'), DATE_FORMAT(거래날짜, '%Y-%m-01')), 2) AS monthly_shipping_fee  -- 코호트별 배송료 합계
	FROM customer_cohorts
)

SELECT first_order_month
	, SUM(DISTINCT CASE WHEN first_order_month = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month0
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month1
	, SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month2
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month3
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month4
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month5
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month6
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month7
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month8
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month9
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month10
    , SUM(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) = transaction_month THEN monthly_shipping_fee ELSE 0 END) AS month11
FROM monthly_shipping_fee
GROUP BY first_order_month;

-- AOV 계산용 클래식 리텐션
WITH customer_cohorts AS(
	SELECT 고객ID
		, 거래날짜 AS order_date
		, MIN(거래날짜) OVER (PARTITION BY 고객ID) AS first_order_date  -- 고객별 2019년 첫 거래일
        , DATE_FORMAT(거래날짜, '%Y-%m-01') AS order_month
		, DATE_FORMAT(MIN(거래날짜) OVER (PARTITION BY 고객ID), '%Y-%m-01') AS first_order_month  -- 2019년 첫 거래월
	FROM onlinesales_info
)

SELECT first_order_month
	, COUNT(DISTINCT 고객ID) AS month0
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 1 MONTH) = order_month THEN 고객ID END) AS month1
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 2 MONTH) = order_month THEN 고객ID END) AS month2
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 3 MONTH) = order_month THEN 고객ID END) AS month3
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 4 MONTH) = order_month THEN 고객ID END) AS month4
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 5 MONTH) = order_month THEN 고객ID END) AS month5
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 6 MONTH) = order_month THEN 고객ID END) AS month6
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 7 MONTH) = order_month THEN 고객ID END) AS month7
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 8 MONTH) = order_month THEN 고객ID END) AS month8
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 9 MONTH) = order_month THEN 고객ID END) AS month9
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 10 MONTH) = order_month THEN 고객ID END) AS month10
    , COUNT(DISTINCT CASE WHEN DATE_ADD(first_order_month, INTERVAL 11 MONTH) = order_month THEN 고객ID END) AS month11
FROM customer_cohorts
GROUP BY first_order_month;
