--1.
SELECT CONCAT(DATE_PART('day', tmstmp), '-',
  DATE_PART('month', tmstmp), '-',
  DATE_PART('year', tmstmp)) AS date,
  COUNT(*)
FROM registrations
GROUP BY date
-- DATE_PART('day', tmstmp),
--   DATE_PART('month', tmstmp),
--   DATE_PART('year', tmstmp);
ORDER BY date;
--ORDER BY tmstmp;
​
--2.
SELECT DATE_PART('dow', tmstmp) as weekday,
  COUNT(*)
FROM registrations
GROUP BY weekday
-- DATE_PART('day', tmstmp),
--   DATE_PART('month', tmstmp),
--   DATE_PART('year', tmstmp);
ORDER BY weekday;
​
--3.
WITH
  U AS (
    SELECT DISTINCT userid
    FROM LOGINS
  ),
  R AS (
    SELECT *
    FROM LOGINS
    WHERE tmstmp BETWEEN '2014-08-07' and '2014-08-14'
  )
​
SELECT *
FROM U
LEFT JOIN R
  ON U.userid=R.userid
LEFT JOIN optout
  ON optout.userid = U.userid
WHERE tmstmp IS NULL
AND optout.userid IS NULL
;
​
--4.
WITH
  Reg_Day AS (
    SELECT userid, CONCAT(DATE_PART('day', tmstmp), '-',
      DATE_PART('month', tmstmp), '-',
      DATE_PART('year', tmstmp)) AS date
      from registrations
  )
  SELECT R1.userid, count(*) FROM Reg_Day R1
  JOIN Reg_Day R2
  ON R1.date=R2.date Group by R1.userid;
​
--5.
​
--Select logins join test_group on userid where grp A
--WITH
--  web_mobile AS (
​
SELECT logins.userid,
  avg(CASE WHEN type='mobile' Then -1
    ELSE 1
    END)
  FROM logins
JOIN test_group ON logins.userid=test_group.userid
WHERE test_group.grp='A' group by logins.userid;
--)
​
--SELECT count(web_mobile.avg) from web_mobile
--where web_mobile.avg > 0
​
--6.
-- messages
-- where sender + where recipient
WITH reverse AS (
  SELECT recipient, sender
  FROM messages
)
SELECT U.sender, COUNT(U.sender)
FROM (SELECT sender, recipient FROM messages
  UNION ALL
  SELECT * FROM reverse) AS U
GROUP BY U.sender;
​
--7.
WITH reverse AS (
  SELECT recipient, sender, char_length(message) AS m_len
  FROM messages
),
​
Amax AS (
SELECT P.A, MAX(P.SUM) as MAX1
FROM
  (SELECT U.sender AS A, U.recipient AS B, SUM(U.m_len)
  FROM (SELECT sender, recipient, char_length(message) AS m_len FROM messages
    UNION ALL
    SELECT * FROM reverse) AS U
  GROUP BY U.sender, U.recipient
  ORDER BY A) AS P
GROUP BY P.A
),
​
A AS (
SELECT U.sender AS A, U.recipient AS B, SUM(U.m_len) as SUM1
FROM (SELECT sender, recipient, char_length(message) AS m_len FROM messages
  UNION ALL
  SELECT * FROM reverse) AS U
GROUP BY U.sender, U.recipient
ORDER BY A
)
​
select *
from A
join Amax on Amax.A=A.A and Amax.max1=A.SUM1
;