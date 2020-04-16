

select * from sys.statements_with_runtimes_in_95th_percentile where last_seen >= CURRENT_TIMESTAMP - INTERVAL 5 MINUTE;
