-- List the tables in the database

-- Check details of musician table


-- Check out the first five rows from band
SELECT * FROM band LIMIT 5;-- How many rows total?

-- Get min and max born date from musician table
SELECT COUNT(*) FROM band

-- Getting the types of instruments with counts by type of music for the performers


-- Selecting the types of instruments with counts for only 'classical'

-- What about if you want to condition on the aggregate variable you created

-- How many total musicians are alive/dead?

-- What fraction of musicians are alive?

#Part 2: Joins

-- Give the names of musicians that organized concerts in the Assembly Rooms after the first of Feb, 1997.
SELECT *
FROM musician
JOIN concert
ON musician.m_no = concert.concert_orgniser
limit 5;
-- Find all the performers who played guitar or violin, and were born in England
SELECT *
FROM musician m
JOIN performer p ON m.m_no = p.perf_is
JOIN place pl ON m.born_in = pl.place_no
WHERE pl.place_country = 'England'
AND p.instrument IN ('guitar', 'violin');




-- Part 3: Complex queries with Subqueries

-- List the names, dates of birth and the instrument played of living musicians who play a instrument which Theo Mengel also plays
SELECT
m.m_name,
m.born,
p.instrument
FROM musician m join performer p
ON m.m_no = p.perf_is
WHERE p.instrument IN (
  SELECT DISTINCT
    p.instrument FROM musician m JOIN performer p
  FROM musician m JOIN performer p
  ON m.m_no = p.perf_is
  WHERE m.m_name = 'Theo Mengel'
)
AND m.died IS NULL

-- Alternatively

WITH t AS(
  SELECT
    m.m_name,
    m.born,
    p.instrument,
    m.died
  FROM musician m JOIN performer p
  ON m.m_no = p.perf_is
  )
  SELECT
    m_name,
    born,
    instrument
  FROM t
  WHERE instrument IN (
    SELECT DISTINCT instrument
    FROM t
    WHERE m_name = 'Theo Mengel'
  )
  AND died is NULL;

CREATE TEMP TABLE result AS
SELECT ...

\copy (SELECT * FROM result) TO 'myresult.csv' WITH DELIMTER '.' CSV HEADER

-- List the name and town of birth of any performer born in the same city as James First.


-- Alternatively

-- Alternatively

-- Download mytab to my machine


-- List the name and the number of players for the band whose number of players is greater than the average number of players in each band.
