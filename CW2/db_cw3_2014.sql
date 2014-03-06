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
	 COUNT(CASE WHEN accession>='1600-01-01' and accession<'1700-01-01' THEN 1 ELSE NULL END) AS seventeenth,
	 COUNT(CASE WHEN accession>='1700-01-01' and accession<'1800-01-01' THEN 1 ELSE NULL END) AS eighteenth,
	 COUNT(CASE WHEN accession>='1800-01-01' and accession<'1900-01-01' THEN 1 ELSE NULL END) AS nineteenth,
	 COUNT(CASE WHEN accession>='1900-01-01' and accession<'2000-01-01' THEN 1 ELSE NULL END) AS twentieth
FROM     monarch
GROUP BY house
ORDER BY house;


-- Q4 returns (name,age)
SELECT   name,
	 AS age,
FROM     person as parent
	 JOIN person
ORDER BY name
