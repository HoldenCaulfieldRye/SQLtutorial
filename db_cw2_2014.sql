-- Q1 returns (name,name,born_in)
SELECT DISTINCT person_a.name,
       		person_b.name,
       		person_a.born_in
FROM   		person AS person_a,
       		person AS person_b,
       		person AS person_c
WHERE  		person_a.name = person_c.father
       		AND person_b.name = person_c.mother
       		AND person_a.born_in = person_b.born_in;


-- Q2 returns (name)
SELECT   name
FROM     monarch
WHERE    coronation IS NULL
	 AND house IS NOT NULL
ORDER BY name;


-- Q3 returns (name,father,mother)
SELECT   person.name,
         person.father,
         person.mother
FROM     person
         JOIN person AS p_father
         ON   person.father = p_father.name
         JOIN person AS p_mother
         ON   person.mother = p_mother.name
WHERE    person.dod < p_father.dod
         AND person.dod < p_mother.dod
ORDER BY person.name;


-- Q4 returns (name)
SELECT 	 name
FROM	 monarch
WHERE	 house IS NOT NULL
UNION
SELECT	 name
FROM	 prime_minister
ORDER BY name


-- Q5 returns (name)
-- a monarch abdicated if there exists another monarch_2 whose
-- accession is after monarch's accession and before monarch's death
SELECT DISTINCT person.name
FROM     	person
         	JOIN monarch AS monarch_1
         	ON   person.name = monarch_1.name,
	 	monarch AS monarch_2
WHERE    	monarch_2.accession > monarch_1.accession
	 	AND monarch_2.accession < person.dod
ORDER BY 	person.name;


-- Q6 returns (house,name,accession)
-- the table inside ALL() contains monarch x monarch tuples of twice
-- the same house. so for a monarch was first in line if it never
-- appears in a tuple of this table joined to a monarch of earlier
-- accession
SELECT   monarch_a.house, monarch_a.name, monarch_a.accession
FROM     monarch AS monarch_a
WHERE	 monarch_a.accession <= ALL(SELECT monarch_c.accession
       		    	     FROM   monarch AS monarch_b
		    	   	    JOIN monarch AS monarch_c
			   	    ON   monarch_b.house=monarch_c.house
			     WHERE  monarch_a.name=monarch_b.name)
	 AND monarch_a.house IS NOT NULL
ORDER BY monarch_a.accession;
