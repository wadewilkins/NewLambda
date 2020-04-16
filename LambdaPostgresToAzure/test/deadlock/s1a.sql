BEGIN;
SELECT column2
FROM   test
WHERE  column1 = 1
FOR    UPDATE;
