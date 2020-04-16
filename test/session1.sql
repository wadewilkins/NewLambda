

BEGIN;
set transaction isolation level serializable;
start transaction;

UPDATE table1 SET marks=marks-1 WHERE id=1;# X lock acquired on 1


