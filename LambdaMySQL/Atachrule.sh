
aws events put-targets \
--rule MyScheduledRule \
--targets '{"Id" : "1", "Arn": "arn:aws:lambda:us-west-2:129801715103:function:check_rds_mysql_alarms"}'


