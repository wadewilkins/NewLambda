UPDATE table1 SET marks=marks+1 WHERE id=2; # DEADLOCK!

COMMIT;

