Goals
======================
   1. Explore the Database
   2. Basic Querying - Selecting From Tables
   3. Selecting specific attributes of a table
   4. Where clause/ filtering
   5. Aggregation functions: counting
   6. Aggregation functions: AVG
   7. Intervals, Ranges, and sorting
   8. Subqueries


Loading the database
======================

In this repo, there's a SQL dump of the data we'll be using today.

1. If you are on your personal computer and haven't set up postgres yet, follow [these instructions](https://github.com/zipfian/welcome/blob/master/notes/postgres_setup.md)

1. From the commandline run `psql` and then this command to create the database.

    ```sql
    CREATE DATABASE readychef;
    \q
    ```

1. Navigate to where you cloned this very repository and run the following command to import the database:

    ```
    psql readychef < readychef.sql
    ```

    You should see a bunch of SQL commands flow through the terminal.

1. To enter the interactive Postgres prompt, now enter the following to be connected or your database.

    ```
    psql readychef
    ```

Now we are in a command line client. This is how we will explore the database to gain an understanding of what data we are playing with.

Basic Exploration
=================

First, we will want to see what the available tables are. Remember, now that we are in the database, all of our commands or actions will be on the `readychef` database.

1. What are the tables in our database? Run `\d` to find out.

2. What columns does each table have? Run `\d tablename` to find out.  tablename is
  the name of a table


Select statements
===================

1. To get an understanding of the data, run a [SELECT](http://www.postgresqltutorial.com/postgresql-select/) statement on each table. Keep all the columns and limit the number of rows to 10.
        ```sql
        SELECT *
        FROM EVENTS
        LIMIT 10
        ```

2. Write a `SELECT` statement that would get just the userids.

  select userid from events limit 10;

3. Maybe you're just interested in what the campaign ids are. Use 'SELECT DISTINCT' to figure out all the possible values of that column.

  select distinct(campaign_id) from users;

    *Note:*  Pinterest=PI, Facebook=FB, Twitter=TW, and Reddit=RE

Where Clauses / Filtering
========================================

Now that we have the lay of the land, we're interested in the subset of users that came from Facebook (FB). If you're unfamiliar with SQL syntax, the [WHERE](http://www.postgresqltutorial.com/postgresql-where/) clause can be used to add a conditional to `SELECT` statements. This has the effect of only returning rows where the conditional evaluates to `TRUE`.

*Note: Make sure you put string literals in single quotes, like `campaign_id='TW'`.*

1. Using the `WHERE` clause, write a new `SELECT` statement that returns all rows where `Campaign_ID` is equal to `FB`.

select * from users where campaign_id='FB' limit 10;

2. We don't need the campaign id in the result since they are all the same, so only include the other two columns.

select userid, dt from users where campaign_id='FB' limit 10;

    Your output should be something like this:

    ```
     userid |     dt
    --------+------------
          3 | 2013-01-01
          4 | 2013-01-01
          5 | 2013-01-01
          6 | 2013-01-01
          8 | 2013-01-01
    ...
    ```

Aggregation Functions
=======================

Let's try some [aggregation functions](http://www.postgresql.org/docs/8.2/static/functions-aggregate.html) now.

`COUNT` is an example aggregate function, which counts all the entries and you can use like this:

```sql
SELECT COUNT(*) FROM users;
```

Your output should look something like:

```
 count
-------
  5524
(1 row)
```

1. Write a query to get the count of just the users who came from Facebook.

select count( * ) from users where campaign_id='FB'

2. Now, count the number of users coming from each service. Here you'll have to group by the column you're selecting with a [GROUP BY](http://www.postgresql.org/docs/8.0/static/sql-select.html#SQL-GROUPBY) clause.

    Try running the query without a group by. Postgres will tell you what to put in your group by clause!

    select campaign_id, count( * ) from users group by campaign_id;

3. Use `COUNT (DISTINCT columnname)` to get the number of unique dates that appear in the `users` table.

  select count (distinct dt) from users;

4. There's also `MAX` and `MIN` functions, which do what you might expect. Write a query to get the first and last registration date from the `users` table.

  select min(dt), max(dt) from users;

5. Calculate the mean price for a meal (from the `meals` table). You can use the `AVG` function. Your result should look like this:

select avg(price) from meals;

    ```
             avg
    ---------------------
     10.6522829904666332
    (1 row)
    ```

6. Now get the average price, the min price and the max price for each meal type. Don't forget the group by statement!

  select avg(price), min(price), max(price) from meals group by type;

    Your output should look like this:

    ```
        type    |         avg         | min | max
    ------------+---------------------+-----+-----
     mexican    |  9.6975945017182131 |   6 |  13
     french     | 11.5420000000000000 |   7 |  16
     japanese   |  9.3804878048780488 |   6 |  13
     italian    | 11.2926136363636364 |   7 |  16
     chinese    |  9.5187165775401070 |   6 |  13
     vietnamese |  9.2830188679245283 |   6 |  13
    (6 rows)
    ```

7. It's often helpful for us to give our own names to columns. We can always rename columns that we select by doing `AVG(price) AS avg_price`. This is called [aliasing](http://stackoverflow.com/questions/15413735/postgresql-help-me-figure-out-how-to-use-table-aliases). Alias all the above columns so that your table looks like this:

    ```
        type    |      avg_price      | min_price | max_price
    ------------+---------------------+-----------+-----------
     mexican    |  9.6975945017182131 |         6 |        13
    ...
    ```
    select type, avg(price), min(price) as min_price,  max(price) as max_price from meals group by type;

8. Maybe you only want to consider the meals which occur in the first quarter (January through March). Use `date_part` to get the month like this: `date_part('month', dt)`. Add a `WHERE` clause to the above query to consider only meals in the first quarter of 2013 (month<=3 and year=2013).

  select type, avg(price), min(price) as min_price, max(price) as max_price from meals where
    date_part('month', dt) < 3 group by type;

9. There are also scenarios where you'd want to group by two columns. Modify the above query so that we get the aggregate values for each month and type. You'll need to add the month to both the select statement and the group by statement.

  select
    date_part('month', dt) as month,
    type,
    avg(price),
    min(price) as min_price,
    max(price) as max_price
    from meals
    where date_part('month', dt) < 3 group by type, month;

    It'll be helfpul to *alias* the month column and give it a name like `month` so you don't have to call the `date_time` function again in the `GROUP BY` clause.

    Your result should look like this:

    ```
        type    | month |      avg_price      | min_price | max_price
    ------------+-------+---------------------+-----------+-----------
     italian    |     2 | 11.2666666666666667 |         7 |        16
     chinese    |     1 | 11.2307692307692308 |         8 |        13
    ...
    ```

10. From the `events` table, write a query that gets the total number of buys, likes and shares for each meal id.
_Extra_: To avoid having to do this as three separate queries you can do the count of the number of buys like this: `SUM(CASE WHEN event='bought' THEN 1 ELSE 0 END)`.

select meal_id, event, count(meal_id) from events group by meal_id, event;

Sorting
==========================================

1. Let's start with a query which gets the average price for each type. It will be helfpul to alias the average price column as 'avg_price'.

select type, avg(price) from meals group by type;

2. To make it easier to read, sort the results by the `type` column. You can do this with an [ORDER BY](http://www.postgresqltutorial.com/postgresql-order-by/) clause.

select type, avg(price) from meals group by type order by type;

3. Now return the same table again, except this time order by the price in descending order (add the `DESC` keyword).

select type, avg(price) as avg_price from meals group by type order by avg_price desc;

3. Sometimes we want to sort by two columns. Write a query to get all the meals, but sort by the type and then by the price. You should have an order by clause that looks something like this: `ORDER BY col1, col2`.

select * from meals order by type, price limit 10;

4. For shorthand, people sometimes use numbers to refer to the columns in their order by or group by clauses. The numbers refer to the order they are in the select statement. For instance `SELECT type, dt FROM meals ORDER BY 1;` would order the results by the `type` column.

select * from meals order by 2, 4 limit 10;



Joins
=========================

Now we are ready to do operations on multiple tables. A [JOIN](http://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm) allows us to combine multiple tables.

1. Write a query to get one table that joins the `events` table with the `users` table (on `userid`) to create the following table.

    ```
     userid | campaign_id | meal_id | event
    --------+-------------+---------+--------
          3 | FB          |      18 | bought
          7 | PI          |       1 | like
         10 | TW          |      29 | bought
         11 | RE          |      19 | share
         15 | RE          |      33 | like
    ...
    ```

    select users.userid, campaign_id, meal_id, event from events join users on events.userid=users.userid limit 10;


2. Also include information about the meal, like the `type` and the `price`. Only include the `bought` events. The result should look like this:

    ```
     userid | campaign_id | meal_id |    type    | price
    --------+-------------+---------+------------+-------
          3 | FB          |      18 | french     |     9
         10 | TW          |      29 | italian    |    15
         18 | TW          |      40 | japanese   |    13
         22 | RE          |      23 | mexican    |    12
         25 | FB          |       8 | french     |    14
    ...
    ```
    select * from (select users.userid, campaign_id, meal_id, event from events join users on events.userid=users.userid limit 10) as foo join meals on foo.meal_id=meals.meal_id limit 5;


    If your results are different, make sure you filtered it so you only got the `bought` events. You should be able to do this *without* using a where clause, only on clause(s)!

3. Write a query to get how many of each type of meal were bought.

    You should again be able to do this *without* a where clause!

*Phew!* If you've made it this far, congratulations! You're ready to move on to subqueries.

Extra Credit (pt. 1)
========================

Subqueries
================================
In a [subquery](http://www.postgresql.org/docs/8.1/static/functions-subquery.html), you have a select statement imbedded in another select statement.

1. Write a query to get meals that are above the average meal price.

    Start by writing a query to get the average meal price. Then write a query where you put `price > (SELECT ...)` (that select statement should return the average price).

2. Write a query to get the meals that are above the average meal price *for that type*.

    Here you'll need to use a join. First write a query that gets the average meal price for each type. Then join with that table to get ones that are larger than the average price for that meal. Your query should look something like this:

    ```sql
    SELECT meals.*
    FROM meals
    JOIN (SELECT ...) average
    ON ...
    ```

    Note that you need to fill in the select statement that will get the average meal price for each type. We *alias* this table and give it the name `average` (you can include the `AS` keyword, but it doesn't matter).

3. Modify the above query to give a count of the number of meals per type that are above the average price.

4. Calculate the percentage of users which come from each service. This query will look similar to #2 from aggregation functions, except you have to divide by the total number of users.

    Like with many programming languages, dividing an int by an int yields an int, and you will get 0 instead of something like 0.54. You can deal with this by casting one of the values as a real like this: `CAST (value AS REAL)`

    You should get a result like this:

    ```
     campaign_id |      percent
    -------------+-------------------
     RE          | 0.156046343229544
     FB          | 0.396813902968863
     TW          | 0.340695148443157
     PI          | 0.106444605358436
    (4 rows)
    ```

Extra Credit (pt. 2)
========================
1. Answer the question, _"What user from each campaign bought the most items?"_

    It will be helpful to create a temporary table that contains the counts of the number of items each user bought. You can create a table like this: `CREATE TABLE mytable AS SELECT...`

2. For each day, get the total number of users who have registered as of that day. You should get a table that has a `dt` and a `cnt` column. This is a cumulative sum.

3. What day of the week gets meals with the most buys?

4. Which month had the highest percent of users who visited the site purchase a meal?

5. Find all the meals that are above the average price of the previous 7 days.

6. What percent of users have shared more meals than they have liked?

7. For every day, count the number of users who have visited the site and done no action.

8. Find all the dates with a greater than average number of meals.

9. Find all the users who bought a meal before liking or sharing a meal.
