-- Q1 returns (name,name,born_in)
SELECT person_a.name,
       person_b.name,
       person_a.born_in
FROM   person AS person_a,
       person AS person_b,
       person AS person_c
WHERE  person_a.name = person_c.father
       AND person_b.name = person_c.mother
       AND person_a.born_in = person_b.born_in;


-- Q2 returns (name)
SELECT   monarch.name
FROM     monarch
WHERE    monarch.coronation IS NULL
ORDER BY monarch.name;


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
SELECT   person.name
FROM     person
         JOIN monarch
         ON   person.name = monarch.name
UNION DISTINCT
SELECT   person.name
FROM     person
         JOIN prime_minister
         ON   person.name = prime_minister.name
ORDER BY person.name;


-- Q5 returns (name)
-- a monarch abdicated if there exists another monarch_2 whose
-- accession is after monarch's accession and before monarch's death
SELECT DISTINCT person.name
FROM     	person
         	JOIN monarch AS monarch_1
         	ON   person.name = monarch_1.name
	 	JOIN monarch AS monarch_2
	 	ON TRUE
WHERE    	monarch_2.accession > monarch_1.accession
	 	AND monarch_2.accession < person.dod
ORDER BY 	person.name;


-- Q6 returns (house,name,accession)
-- the table inside ALL() contains monarch x monarch tuples of twice
-- the same house. so for a monarch was first in line if it never
-- appears in a tuple of this table joined to a monarch of earlier
-- accession
SELECT   mo.house, mo.name, mo.accession
FROM     monarch AS mo
WHERE	 mo.accession <= ALL(SELECT mon_2.accession
       		    	     FROM   monarch AS mon_1
		    	   	    JOIN monarch AS mon_2
			   	    ON   mon_1.house=mon_2.house
			     WHERE  mo.name=mon_1.name)
	 AND mo.house IS NOT NULL
ORDER BY mo.accession;
