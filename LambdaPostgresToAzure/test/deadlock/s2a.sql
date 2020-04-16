BEGIN;
SELECT column2
FROM   test
WHERE  column1 = 2
FOR    UPDATE;
