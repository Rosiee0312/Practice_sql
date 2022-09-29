/* 175. Comnine Two Tables */

SELECT firstname, lastname, city, state
FROM person AS p
LEFT JOIN address AS a
ON p.personId = a.personId

/* 176. Second Highest Salary */

SELECT DISTINCT *
FROM Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1

/*177. Nth Highest Salary */

CREATE FUNCTION getNhightgestsalary (N INT)
RETURNS INT
BEGIN 
    diclare M INT
    set M = N - 1
    RETURN (
        SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET M
    );
END;

/* 178. Rank Scores */

SELECT Score, (SELECT COUNT(DISTINCT Score) FROM Scores WHERE Score >=s.Score) AS Rank
FROM Score AS s
ORDER BY Score DESC

SELECT Score, DENSE_RANK() OVER (ORDER BY Score DESC) Rank
FROM Scores;

/* 180. Consecutive Number
Write a sql query to find all numbers that appear at least 3 times consecutively */


/* 181. Employee earning more than their manager */
SELECT e.name AS Employee
FROM Employee  AS e
INNER JOIN Employee AS m 
ON e.managerid = m.id
WHERE e.Salary > m.Salary;

/* 182. Duplicate Emails */

SELECT id, email
FROM person
GROUP BY email
HAVING COUNT(email) > 1;

/*183. Who never order*/

SELECT name AS customer
FROM customer AS c 
RIGHT JOIN orders AS o 
ON c.id = o.id
WHERE o.id IS NULL;

SELECT name AS customers
WHERE id not in (select customID FROM orders);

/*196. Delete Duplicate Emails*/
DETETE p1
FROM person AS p1, person AS p2
WHERE p1.email = p2.email AND p1.id > p2.id;

/* Rising Temperature*/

SELECT w1.id
FROM weather AS w1, weather AS w2
WHERE datediff(w1.RecordDate, w2.RecordDate) = 1 AND w1.Temperature > w2.Temperature;

/* 511. Game Play Analysis I */

SELECT player_id , MIN(event_date) AS first_login
FROM activity
GROUP BY player_id
ORDER BY player_id;

/* Game Play Analysis II*/

SELECT player_id, device_id
FROM  activity
WHERE (player_id, event_date) IN
(
SELECT player_id , MIN(event_date)
FROM activity
GROUP BY player_id
ORDER BY player_id);    

/* 534. Game Play Analysis III

SELECT player_id, event_date, game_played_so_far
FROM (
    SELECT 
    player_id, event_date,
    @games := if(player_id = @player, @games + games_played, games_played)
    AS game_played_so_far,
    @player := player_id
    FROM 
    (select * from activity order by player_id, event_date) AS a,
    (SELECT @player := -1, @games := 0) ASA tmp
)  AS t;

*/

/*570. Managers with at least 5 direct reports*/

SELECT Name 
FROM Employee
WHERE id IN 
(
SELECT managerid 
FROM Employee
GROUP BY managerid
HAVING COUNT(*) >= 5
);

/* 577. Employess Bonus*/

SELECT e.name, b.bonus
FROM Employee AS e 
LEFT JOIN bonus AS b 
ON e.emId = b.emId
WHERE bonus < 1000 or bonus is null;

/* 584. Finding customer Referee*/

SELECT name 
FROM customer
WHERE referee_id is Null or referee_id<> 2;

/* 586. Customer Placing the Largest Number of Orders*/

SELECT customer_number
FROM 
(SELECT customer_number, COUNT(*) as cnt 
FROM Orders
GROUP BY customer_number) AS e
ORDER BY e.cnt DESC
LIMIT 1;


/* Big Countries */

SELECT name, population, area
FROM World
WHERE area >= 3.10^6 or population >= 25.10^6;

/596. Class more than 5 student */

SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DISTINCT student) > 5;

/* 597. Friend requests I: Overall Acceptance Rate */

SELECT ROUND (IF (requests=0,0, accepts / requests)) AS accept_rate
FROM
( 
    SELECT COUNT( DISTINCT sender_id, send_to_id) AS requests
    FROM friend_request
) AS r,
(
    SELECT COUNT(DISTINCT requester_id, accepter_id) AS accepts
    FROM request_accepted
) AS a;

/* 603. Consecutive Available Seats */

SELECT DISTINCT c2.seat_id
FROM cinema AS c1, cinema AS c2
WHERE c1.free = 1 AND c2.free = 1 AND c1.seat_id = c2.seat_id +1
UNION
SELECT DISTINCT c1.seat_id
FROM cinema AS c1, cinema AS c2
WHERE c1.free = 1 AND c2.free = 1 AND c1.seat_id = c2.seat_id +1
ORDER BY seat_id;

/* 607. Sales Person */

SELECT s.name 
FROM saleperson AS s 
WHERE s.sales_id NOT in
(
SELECT o.sales_id, o.com_id, c.name
FROM orders AS o
LEFT JOIN company AS c
ON o.com_id = c.com_id
WHERE name = 'RED'
);


/* 610. Triagle Judgement */

SELECT x, y, z,
CASE
WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
ELSE 'No'
AS Triangle
FROM triagle;

/* 613. Shortest Distance in a line */

SELECT MIN(ABS(a.x - b.x)) AS Shortest
FROM point AS a, point AS b
WHERE a.x != b.x;

/* 619. Biggest Single Number */

SELECT MAX(num) as num
FROM 
(
    SELECT num 
    FROM my_numbers
    GROUP BY num
    HAVING COUNT(num) = 1
);

/* 620. Not Boring Movies*/

SELECT *
FROM cinema
WHERE id %2 = 1 AND description <> 'boring'
ORDER BY rating DESC;

/*626. Exchange Seats*/

SELECT if (mod(id, 2)=0, id-1, if(id < (SELECT MAX(id) FROM seat), id + 1, id)) AS id, student
FROM seat
ORDER BY id;

/* 627. Swap Salary */

UPDATE salary 
SET sex = IF(sex ='m', 'f', 'm');

/* 1045. Customers who bought all products */
SELECT customer_id 
FROM  Customer 
GROUP BY customer_id
HAVING SUM(DISTINCT product_key) = (SELECT product_key FROM product);

/* 1050. Actors and Directors Who Cooperated at least 3 times */

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;

/* 1068. Product Sales Analysis I */

SELECT DISTINCT
    p.product_name, 
    s.year,
    s.price
FROM 
(
    SELECT DISTINCT product_id, year, price FROM Sales
) AS S
JOIN Product AS p
ON s.product_id = p.product_id;

/*. Product Sales Analysis II */

SELECT
    product_id,
    SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product_id;

/* 1070. Product Sales Analysis III*/

SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM Sales
WHERE (product_id, year) IN ( SELECT product_id, MIN(year) FROM Sales
GROUP BY product_id);

/* 1075. Project Employees I*/

SELECT 
    p.project_id, 
    p.employees_id,
    e.experience_year 
    ROUND(AVG(experience_year)) AS average_years
FROM project AS P
LEFT JOIN Employee AS e
ON p.employees_id = e.employees_id
GROUP BY project_id;

/* 1076. Project Emplyees II*/

SELECT  project_id
FROM project
GROUP BY project_id
HAVING COUNT (employees_id) >= (
    SELECT COUNT(employees_id) as cnt
    FROM Project
    GROUP BY project_id
    ORDER BY cnt DESC
    LIMIT 1
);

/* 1077. Project Employees III*/
SELECT 
    project_id,
    e.employees_id
FROM 
(
SELECT
    project_id,
    MAX(experience_year) AS max_year
FROM Project AS p 
JOIN Employee AS e 
ON p.employees_id = e.employees_id
GROUP BY project_id
) AS q,
Project AS p,
Employee AS e 
WHERE p.project_id = q.project_id AND p.project_id = e.project_id AND e.experience_year >= max_year;

/* Sales Analysis I */

SELECT
    seller_id
FROM Sales
HAVING SUM(price) >=
(SELECT 
    SUM(price) AS total_price
    FROM Sales
    GROUP BY seller_id
    ORDER BY seller_id DESC
    LIMIT 1
);

/* 1803. Sales Analysis II */

SELECT
    buyer_id
FROM Sales
JOIN product USING(product_id)
GROUP BY buyer_id
HAVING SUM(product_name='S8') > 0 AND SUM(product_name="iPhone") = 0;

/* 1084. Sales Analysis III*/

SELECT  
    product_id,
    product_name
FROM  Product
INNER JOIN Sales USING product_id
GROUP BY product_id
HAVING SUM (IF(sale_date BETWEEN '2019-01-01' AND '2019-03-31', 1, 0)) = SUM(IF(sale_date,1,0));

/* 1112. Highest Grade for each Student*/

SELECT
    student_id,
    MIN(course_id) AS course_id
    grade 
FROM Enrollments
WHERE (student_id, grade) IN (
    SELECT student_id, MAX(grade) FROM Enrollments GROUP BY student_id
)
GROUP BY student_id
ORDER BY student_id DESC;

/*1113. Reported Posts */

SELECT 
    extra AS report_reason
    COUNT(DISTINCT (post_id)) AS report_count
FROM Action
WHERE action_date = "2019-07-04" AND action="report"
GROUP BY extra;

/* 1126. Active Businesses*/

SELECT 
    business_id 
FROM Events e,
(
    SELECT event_type, avg(occurences) AS avg_occurences
    FROM Events
    GROUP BY event_type
) AS a
WHERE e.event_type = a.event_type AND e.occurences > a.avg_occurences
GROUP BY e.business_id
HAVING COUNT(*) > 1;

/* 1141. User activity for the past 30 Days I*/




