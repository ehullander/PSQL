select * from friends;

select userid1, count(userid2) from friends group by userid1;

--- how many of your friends opted out
select f.userid1, count(o.userid), count(f.userid2) from friends f 
left join optout o on f.userid2 = o.userid 
group by f.userid1;

--- create likes table
drop table if exists likes;
create table likes (userid int, pageid int);
insert into likes (userid, pageid)
values (996, 1), (758, 2), (505, 3),(996, 4), (758, 5), (505, 6),
(99, 10), (99, 1), (762, 55),(762, 56), (993, 3), (993, 6)

--create submissions table
drop table if exists submissions;
create table submissions (submissionsid int, parentid int);
insert into submissions (submissionsid, parentid)
values (1, NULL), (2, 100), (3, 100),(4, 100), (100, NULL), (5, 1),
(6, 1)


--- pages users like
select * from likes

--- all pages friends like
select f.userid1, l.pageid from friends f join likes l on f.userid2 = l.userid 


--- pages friends like that user doesn't like yet
select f.userid1, l.pageid from friends f 
	join likes l on f.userid2 = l.userid
		left join likes l2 on f.userid1 = l2.userid and l.pageid = l2.pageid
where l2.pageid is null
order by f.userid1 

--- submissions
select child, count(child) from (select s1.submissionsid as parent, count(s2.submissionsid) as child from submissions s1
join submissions s2 on s1.submissionsid = s2.parentid 
group by s1.submissionsid) t group by child

--- how many people logged in on the same day they registered
select *, date(l.tmstmp) as logindate, date(r.tmstmp) as registrationdate from logins l
left join
registrations r 
on l.userid = r.userid and date(l.tmstmp) = date(r.tmstmp)
where date(r.tmstmp) is not null

---histogram of messages per user excluding users with no messages
select t.msgs, count(t.msgs) from (select m.sender, count(*) as msgs from messages m group by m.sender) t group by t.msgs;


----
---https://app.interviewquery.com/questions/post-success
--- this does not count submissios if not made on the same day
with submitted as 
(
select a.user_id, date(a.created_at) as dt from events a
where a.action = 'post_submit' 
),
entered as
(
select a.user_id, date(a.created_at) as dt from events a
where a.action = 'post_enter'
)

select e.dt, count(s.user_id)/count(e.user_id)  as success_rate
from entered e
left join
submitted s on 
date(e.dt) = date(s.dt) and e.user_id = s.user_id
group by date(e.dt)
order by e.dt desc
limit 7;

---------------------------------------------------------

with submit as (
select date(e.created_at) as dt, count(*) as submit
from events e
where e.action = 'post_submit'
group by date(e.created_at)

)
,
enter as (
select date(e.created_at) as dt, count(*) as enter
from events e
where e.action = 'post_enter'
group by date(e.created_at)

)

select e.dt, 
case 
    when s.submit is null then 0 
    else s.submit/e.enter 
end as success 
from enter e
left join
submit s on
e.dt = s.dt
order by e.dt desc
limit 7



-------------------------------------------------
---------https://app.interviewquery.com/questions/closed-accounts
with closed as (
select a.date, a.account_id
from account_status a
where a.status = 'closed')

select b.date, count(b.account_id) as accounts, count(c.account_id) as closed 
from account_status b
left join
closed c on c.date=b.date and c.account_id = b.account_id
where b.date = '2020-01-01'
group by b.date

--------------
with opn as (
select a.account_id from account_status a
where date(date) = '2019-12-31' and status = 'open'
)
,
cls as (
select a.account_id from account_status a
where date(date) = '2020-01-01' and status = 'closed'
)

select count(cls.account_id)/count(opn.account_id) from opn
left join
cls on
opn.account_id=cls.account_id


------------------------------------
----------https://app.interviewquery.com/questions/empty-neighborhoods
select n.name from neighborhoods n
left join
users u
on n.id = u.neighborhood_id
where u.id is null


-----------------------------------
--------https://app.interviewquery.com/questions/comments-histogram
-- get available users

with users as 
(
select u.id from users u
where date(u.created_at) <= '2020-01-31'
)

-- histogram

select t.comments, count(t.comments) as count from
(
    select u.id, count(*) as comments from users u 
    left join comments c
    on u.id = c.user_id 
        and date(c.created_at) between '2020-01-01' and '2020-01-31'
    group by u.id
) t
group by t.comments
order by t.comments
--------------------------------------
------------https://app.interviewquery.com/questions/search-ratings
select query, AVG(rating/position) as score from search_results
group by query order by score desc

----------------------------------------

select AVG(t2.F) from 
(
select query, 
    case when sum(fail) = count(query) then 1 else 0 end as F
    
from 
(
    select query, 
        case when rating < 3 then 1 else 0
    end as fail
    from search_results
) t group by query
) t2



select count(t.query)/count(s.query) from search_results s
left join
    (select query
    from search_results
    group by query
    having count(query) = sum(case when rating < 3 then 1 else 0 end)) t
on 
s.query = t.query

-----------------
--https://app.interviewquery.com/questions/acceptance-rate
with mates as 
(select r.requester_id, a.acceptor_id from friend_requests r
left join
friend_accepts a
on r.requester_id = a.requester_id and r.requested_id = a.acceptor_id)

select count(r.requester_id)/count(m.requester_id)from friend_requests r
left join
mates m
on r.requester_id = m.requester_id

---------------------
---https://app.interviewquery.com/questions/conversations-distribution
select daily_messages, count(*) as frequency from
    (select user1, date(date), count(*) as daily_messages from messages
    where year(date) = '2020'
    group by date(date), user1) t
    group by daily_messages;
   

--------------------
select u.id, count(c.user_id) 
from users u
left join comments c
    on u.id = c.user_id 
        where c.created_at 
        between '2020-01-01' and '2020-01-31'
group by u.id

SELECT users.id, COUNT(comments.user_id) AS comment_count
FROM users
LEFT JOIN comments
    ON users.id = comments.user_id
        AND comments.created_at 
        BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY 1

---- 3 day rolling mean
select
	t.date, 
	AVG(t.count) over (order by date(t.date) desc rows 3 preceding) as ma
	from 
		(select date(tmstmp) as date, count(*) as count from logins group by date(tmstmp) order by date(tmstmp) desc) t;
	
---- date time
with dailylogs as 
(select type, date(tmstmp) as dt, count(*) as logins from logins group by type, date(tmstmp) order by type, date(tmstmp) desc)

select
	dt, type, 
	AVG(logins) over (partition by type order by dt desc rows 3 preceding) as avg3logins
	from dailylogs

----------------sandbox-----------------
select * from logins limit 5;

select * from friends;

with fc as (select l.userid,count(*) from logins l left join
friends f on l.userid = f.userid1 group by l.userid order by count(*))
select * from fc where count > 5000;





 


