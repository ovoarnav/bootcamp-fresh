/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SQL query: SELECT * FROM `Facilities` WHERE guestcost > 0 ORDER BY `Facilities`.`facid` ASC LIMIT 0, 30 ;
Rows: 9

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
0	Tennis Court 1	5.0	25.0	10000	200
1	Tennis Court 2	5.0	25.0	8000	200
2	Badminton Court	0.0	15.5	4000	50
3	Table Tennis	0.0	5.0	320	10
4	Massage Room 1	9.9	80.0	4000	3000
5	Massage Room 2	9.9	80.0	4000	3000
6	Squash Court	3.5	17.5	5000	80
7	Snooker Table	0.0	5.0	450	15
8	Pool Table	0.0	5.0	400	15


/* Q2: How many facilities do not charge a fee to members? */
SQL query: SELECT count(name) FROM `Facilities` WHERE guestcost > 0 ORDER BY `Facilities`.`facid` ASC LIMIT 0, 30 ;
Rows: 1

 This table does not contain a unique column. Grid edit, checkbox, Edit, Copy and Delete features are not available.
count(name)	
9


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SQL query: SELECT facid,name,membercost,monthlymaintenance FROM `Facilities` WHERE guestcost < 0.20*monthlymaintenance LIMIT 0, 30 ;
Rows: 4

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000



/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SQL query: SELECT * FROM `Facilities` WHERE facid in (1,5) ORDER BY `Facilities`.`facid` ASC LIMIT 0, 30 ;
Rows: 2

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	5.0	25.0	8000	200
5	Massage Room 2	9.9	80.0	4000	3000

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SQL query: SELECT name, monthlymaintenance, CASE WHEN monthlymaintenance > 100 THEN 'expensive' ELSE 'cheap' END AS cost_category FROM Facilities LIMIT 0, 30 ;
Rows: 9

name	monthlymaintenance	cost_category	
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SQL query: SELECT firstname,surname FROM `Members` LIMIT 0, 30 ;
Rows: 30

 This table does not contain a unique column. Grid edit, checkbox, Edit, Copy and Delete features are not available.
firstname	surname	
GUEST	GUEST
Darren	Smith
Tracy	Smith
Tim	Rownam
Janice	Joplette
Gerald	Butters
Burton	Tracy
Nancy	Dare
Tim	Boothe
Ponder	Stibbons
Charles	Owen
David	Jones
Anne	Baker
Jemima	Farrell
Jack	Smith
Florence	Bader
Timothy	Baker
David	Pinker
Matthew	Genting
Anna	Mackenzie
Joan	Coplin
Ramnaresh	Sarwin
Douglas	Jones
Henrietta	Rumney
David	Farrell
Henry	Worthington-Smyth
Millicent	Purview
Hyacinth	Tupperware
John	Hunt
Erica	Crumpet

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SQL query: SELECT DISTINCT Members.firstname, Members.surname FROM Members INNER JOIN Bookings ON Members.memid = Bookings.memid INNER JOIN Facilities ON Bookings.facid = Facilities.facid WHERE Facilities.facid IN (0, 1) LIMIT 0, 30 ;
Rows: 27

 This table does not contain a unique column. Grid edit, checkbox, Edit, Copy and Delete features are not available.
firstname	surname	
Tracy	Smith
GUEST	GUEST
Tim	Rownam
Darren	Smith
Janice	Joplette
Gerald	Butters
Tim	Boothe
Burton	Tracy
Nancy	Dare
Ponder	Stibbons
Charles	Owen
Anne	Baker
David	Jones
Jack	Smith
Timothy	Baker
Florence	Bader
David	Pinker
Jemima	Farrell
Ramnaresh	Sarwin
Joan	Coplin
Douglas	Jones
David	Farrell
Millicent	Purview
Henrietta	Rumney
John	Hunt
Matthew	Genting
Erica	Crumpet



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT Facilities.name AS facility, CONCAT( Members.firstname,  ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Bookings.starttime LIKE  '2012-09-14%'
AND (((Bookings.memid =0) AND (Facilities.guestcost * Bookings.slots >30))
OR ((Bookings.memid !=0) AND (Facilities.membercost * Bookings.slots >30)))
INNER JOIN Members ON Bookings.memid = Members.memid
ORDER BY cost DESC;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT * 
FROM (
SELECT Facilities.name AS facility, CONCAT( Members.firstname,  ' ', Members.surname ) AS name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS cost
FROM `Bookings`
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
AND Bookings.starttime LIKE  '2012-09-14%'
INNER JOIN Members ON Bookings.memid = Members.memid
)sub
WHERE sub.cost >30
ORDER BY sub.cost DESC
/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SQL query: select name, sum(case when memid = 0 then slots * guestcost else slots * membercost end) as revenue from Bookings left join Facilities using(facid) group by name having revenue < 1000 LIMIT 0, 30 ;
Rows: 3

 This table does not contain a unique column. Grid edit, checkbox, Edit, Copy and Delete features are not available.
name	revenue	
Pool Table	270.0
Snooker Table	240.0
Table Tennis	180.0

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */
select concat(a.surname, ', ', a.firstname) as members, concat(b.surname, ', ', b.firstname) as recommended_by from Members a, Members b where a.recommendedby >0 and a.recommendedby = b.memid order by b.surname;

/* Q12: Find the facilities with their usage by member, but not guests */

select name, concat(firstname, ' ', surname) as member_name, count(surname) as 'usage' from Bookings left join Facilities using(facid) left join Members using(memid) where memid != 0 group by name, member_name;


/* Q13: Find the facilities usage by month, but not guests */
select extract(month from starttime) as month, name, count(name) as 'usage' from Bookings left join Facilities using(facid)where memid != 0 group by month, name;