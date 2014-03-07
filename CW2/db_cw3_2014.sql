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

 
-- Q2 returns (born_in, popularity) listing places of birth and #occurences of
-- birthplaces
SELECT   COUNT(person.name) AS popularity,
	 born_in
FROM     person
GROUP BY born_in
ORDER BY popularity DESC;


-- Q3 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT   house,
	 COUNT(CASE WHEN accession>='1600-01-01' AND accession<'1700-01-01'
	 	    	 THEN 1
		    	 ELSE NULL
		    END) AS seventeenth,
	 COUNT(CASE WHEN accession>='1700-01-01' AND accession<'1800-01-01'
	 	         THEN 1
			 ELSE NULL
		    END) AS eighteenth,
	 COUNT(CASE WHEN accession>='1800-01-01' AND accession<'1900-01-01'
	 	         THEN 1
			 ELSE NULL
		    END) AS nineteenth,
	 COUNT(CASE WHEN accession>='1900-01-01' AND accession<'2000-01-01'
	 	    	 THEN 1
			 ELSE NULL
		    END) AS twentieth
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


-- Q5 returns (father,child,born)
SELECT DISTINCT parent.name AS father,
 	 child.name AS child,
	 (CASE WHEN child.name IS NULL
	            THEN NULL
		    ELSE RANK() OVER (PARTITION BY parent.name ORDER BY child.name)
	  END) AS born
FROM     person AS parent
 	 LEFT JOIN person AS child
 	 ON child.father = parent.name
WHERE    parent.gender = 'M'
ORDER BY father, born;


-- Q6 returns (monarch,prime_minister) which lists prime ministers that held
-- office during the reign of the monarch
-- strategy: create start-finish dates for prime ministers
--           create start-finish dates for monarchs
--	     join the table according to these dates

-- according to what rules should the tables be joined?
-- prime_minister and monarch are commonly active at some point iff
-- [pm.start, pm.finish] intersect [mon.start, mon.finish] is not empty
-- in SQL terms:
-- if (pm.start <= mon.start and mon.start < pm.finish)
--    or (mon.start <= pm.start and pm.start < mon.finish)

-- how to get the finish date?
-- for a given monarch/prime_minister, find minimum accession/entry
-- date that is greater than that monarch/prime_minister's.
-- do this with joining on greater than. and then take min().

SELECT DISTINCT monSF.name AS monarch,
       pmSF.name AS prime_minister
FROM   (SELECT monarch.name,
       	       monarch.accession AS start,
       	       (CASE WHEN MIN(later_monarch.accession) IS NULL
       	       	          THEN '2015-01-01'
		  	  ELSE MIN(later_monarch.accession)
		END) AS finish
	FROM   monarch
       	       LEFT JOIN monarch AS later_monarch
       	       ON monarch.accession < later_monarch.accession
	GROUP BY monarch.name) AS monSF,
       (SELECT prime_minister.name,
       	       prime_minister.entry AS start,
       	       (CASE WHEN MIN(later_prime_minister.entry) IS NULL
       	                  THEN '2015-01-01'
                          ELSE MIN(later_prime_minister.entry)
                END) AS finish
	FROM   prime_minister
       	       LEFT JOIN prime_minister as later_prime_minister
       	       ON prime_minister.entry < later_prime_minister.entry
	GROUP BY prime_minister.name, prime_minister.entry) AS pmSF
WHERE  (pmSF.start <= monSF.start AND monSF.start <= pmSF.finish)
       OR (monSF.start <= pmSF.start AND pmSF.start <= monSF.finish)
ORDER BY monSF.name, pmSF.name;

