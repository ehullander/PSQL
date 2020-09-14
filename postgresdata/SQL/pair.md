# Advanced SQL

You work at a social media site. You have to write a lot of queries to get the desired data and stats from the database.

You will be working with the following tables:

* `registrations`: One entry per user when the register
* `logins`: One entry every time a user logs in
* `optout`: A list of users which have opted out of receiving email
* `friends`: All friend connections. Note that while friend connections are mutual, sometimes this table has both directions and sometimes it doesn't. You should assume that if A is friends with B, B is friends with A even if both directions aren't in the table.
* `messages`: All messages users have sent
* `test_group`: A table for an A/B test

## Connecting to the database

There's a sql dump of the database in `socialmedia.sql`.

Here are the steps to load it up:

1. First create the database by running `psql` and then the following command:

    ```sql
    CREATE DATABASE socialmedia;
    ```
    Use `\q` to quit `psql`.

2. You can load the sql dump with this command on the commandline:

    ```shell
    psql -U postgres socialmedia < data/socialmedia.sql
    ```

3. Finally, to run the database:

    ```shell
    psql -U postgres socialmedia
    ```

If you're running into issues, make sure you're running `postgres.app`.


## Investigate your database

You can get a list of all the tables with this command: `\d`

You can get the info for a specific table with this command: `\d friends`

Start by looking at your tables. Even if someone tells you what a table is, you should look at it to verify that is what you expect. Many times they are not properly documented. You might wonder what the `type` field is. Well, take a look at the table:

```sql
SELECT * FROM registrations LIMIT 10;
```

It's also good to get an idea of all the possible values and the distribution:

```sql
SELECT type, COUNT(*) FROM registrations GROUP BY type;
```

Look at some rows from every table to get an idea of what you're dealing with.

## Tips:
* Take a look at the postgres [datetime documentation](http://www.postgresql.org/docs/8.4/static/datatype-datetime.html) if you're unsure how to work with the dates.
* Try and get practice adding newlines and whitespace so that the queries are easily readable.
* Sometimes it may be useful to create temporary tables like this: `CREATE TEMPORARY TABLE tmp_table AS SELECT ...` or use a [with query](http://www.postgresql.org/docs/9.1/static/queries-with.html).


## Write Some SQL Queries
Each of these questions is a prompt for writing a SQL query.

Create a text or markdown file where you put your SQL queries as well as answers to the questions.

1. Get the number of users who have registered each day, ordered by date.

2. Which day of the week gets the most registrations?

3. You are sending an email to users who haven't logged in in the week before '2014-08-14' and have not opted out of receiving email. Write a query to select these users.

4. For every user, get the number of users who registered on the same day as them. Hint: This is a self join (join the registrations table with itself).

5. You are running an A/B test and would like to target users who have logged in on mobile more times than web. You should only target users in test group A. Write a query to get all the targeted users.

6. You would like to determine each user's most communicated with user. For each user, determine the user they exchange the most messages with (outgoing plus incoming).

7. You could also consider the length of the messages when determining the user's most communicated with friend. Sum up the length of all the messages communicated between every pair of users and determine which one is the maximum. This should only be a minor change from the previous query.

8. What percent of the time are the above two answers different?

Extra Credit
========================
9. Write a query which gets each user, the number of friends and the number of messages received. Recall that the friends table is not nice and that some pairs appear twice in both orders and some do not, so it might be nice to first create a cleaned up friends table.

10. Break the users into 10 cohorts based on their number of friends and get the average number of messages for each group. It might be useful to save the result of the previous query in a table.
