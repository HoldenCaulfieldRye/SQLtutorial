-- Q1 returns (first_name)

SELECT DISTINCT SUBSTRING(name FROM 1 FOR POSITION(' ' in NAME)) AS first_name
FROM   person 
UNION    
SELECT DISTINCT SUBSTRING(name FROM 1 FOR POSITION(' ' in NAME)) AS first_name
FROM   monarch 
UNION  
SELECT DISTINCT SUBSTRING(name FROM 1 FOR POSITION(' ' in NAME)) AS first_name 
FROM    prime_minister
ORDER BY first_name;

 
-- Q2 returns (born_in, popularity) listing places of birth and #occurences of birthplaces
SELECT   COUNT(person.name) AS popularity,
	 born_in
FROM     person
GROUP BY born_in
ORDER BY popularity DESC;


-- Q3 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT   house,
	 COUNT(CASE WHEN accession>='1600-01-01' AND accession<'1700-01-01' THEN 1 ELSE NULL END) AS seventeenth,
	 COUNT(CASE WHEN accession>='1700-01-01' AND accession<'1800-01-01' THEN 1 ELSE NULL END) AS eighteenth,
	 COUNT(CASE WHEN accession>='1800-01-01' AND accession<'1900-01-01' THEN 1 ELSE NULL END) AS nineteenth,
	 COUNT(CASE WHEN accession>='1900-01-01' AND accession<'2000-01-01' THEN 1 ELSE NULL END) AS twentieth
FROM     monarch
GROUP BY house
ORDER BY house;


-- Q4 returns (name,age)
SELECT   parent.name,
	 MIN(child.dob) AS first_child_dob
FROM     person AS child
	 JOIN person AS parent
	 ON child.father = parent.name OR child.mother = parent.name
GROUP BY parent.name
ORDER BY parent.name;


-- use this to double check
-- SELECT   parent.name AS parent_name,
-- 	 child.name AS child_name,
-- 	 child.dob AS first_dob
-- FROM     person AS child
-- 	 JOIN person AS parent
-- 	 ON child.father = parent.name OR child.mother = parent.name
-- ORDER BY parent.name;


-- Q5 returns (father,child,born)
SELECT   parent.name AS father,
 	 child.name AS child,
 	 COUNT(CASE 
	       WHEN child.dob < otherchild.dob 
	            THEN 1 
	            ELSE 0
	       END) 
	       OVER (PARTITION BY parent.name) AS born
FROM     person AS parent
 	 JOIN person AS child
 	 ON child.father = parent.name
 	 JOIN person AS otherchild
 	 ON child.father = otherchild.name
ORDER BY parent.name;



SELECT   parent.name AS father,
	 child.name AS child,
	 OVER (PARTITION BY father) AS born
FROM     person
WHERE    gender = 'M'
ORDER BY name;




