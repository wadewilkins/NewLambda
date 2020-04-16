
EGIN;
set transaction isolation level serializable;
start transaction;

UPDATE table1 SET marks=marks+1 WHERE id=2;# X lock acquired on 2 UPDATE table1 SET marks=marks-1 WHERE id=1;# LOCK WAIT!

