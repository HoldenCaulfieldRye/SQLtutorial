-- Q1 returns (first_name)
SELECT DISTINCT   SUBSTRING(name, 1, POSITION(' ' IN name)) AS first_name
FROM      	  person
ORDER BY  	  first_name
;

-- Q2 returns (born_in,popularity)
SELECT    born_in,
	  COUNT (born_in) AS popularity
FROM      person 
GROUP BY  born_in
ORDER BY  popularity DESC, born_in;
;

-- Q3 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT    house,
	  SUM (CASE 
	       WHEN accession BETWEEN '1600-01-01' AND '1699-12-31' THEN 1 
	       ELSE 0 END) AS seventeenth,
	  SUM (CASE 
	       WHEN accession BETWEEN '1700-01-01' AND '1799-12-31' THEN 1 
	       ELSE 0 END) AS eighteenth,
	  SUM (CASE 
	       WHEN accession BETWEEN '1800-01-01' AND '1899-12-31' THEN 1 
	       ELSE 0 END) AS nineteenth,
	  SUM (CASE 
	       WHEN accession BETWEEN '1900-01-01' AND '1999-12-31' THEN 1 
	       ELSE 0 END) AS twentieth
FROM	  monarch
WHERE     house IS NOT null
GROUP BY  house
ORDER BY  house
; 

-- Q4 returns (name,age)
SELECT    person_a.name, 
	  MIN(person_b.dob - person_a.dob)/365 AS age
FROM      person AS person_a
 	  JOIN person AS person_b
	  ON person_a.name = person_b.father
GROUP BY  person_a.name
UNION
SELECT    person_a.name, 
	  MIN(person_b.dob - person_a.dob)/365 AS age
FROM      person AS person_a
 	  JOIN person AS person_b
	  ON person_a.name = person_b.mother
GROUP BY  person_a.name
ORDER BY  name
;



-- Q5 returns (father,child,born)
SELECT    person_a.name AS father,
	  person_b.name AS child,
	  RANK() OVER 
	     (PARTITION BY person_b.father ORDER BY person_b.dob) AS born
FROM      person AS person_a
	  JOIN person AS person_b
	  ON person_a.name = person_b.father
GROUP BY  person_a.name, 
	  person_b.name
UNION
SELECT    person_a.name AS father,
	  NULL AS child,
	  NULL AS born
FROM 	  person AS person_a
WHERE     NOT EXISTS (SELECT person_a.name
		      FROM   person
		      WHERE  person_a.name = father)
ORDER BY  father,  
	  born
;

-- Q6 returns (monarch,prime_minister)
------------MORE THAN UNFINISHED
SELECT    monarch_a.name AS monarch, 
	  monarch_a.accession AS monarch_accession,
	  monarch_b.name AS successor, 
	  monarch_b.successor_accession
FROM      monarch AS monarch_a
	  JOIN monarch AS monarch_b 
	  ON monarch_b.accession > monarch_a.accession
WHERE     monarch_b.accession > monarch_a.accession
GROUP BY  monarch, successor
ORDER BY  monarch_a.accession
;




SELECT    monarch_a.name AS monarch,
	  prime_minister_a.name AS prime_minister
FROM 	  monarch AS monarch_a
	  JOIN prime_minister AS prime_minister_a
	  ON prime_minister_a.entry >=


;

