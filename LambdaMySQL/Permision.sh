#!/bin/sh

aws lambda add-permission \
--function-name check_rds_mysql_alarms \
--statement-id MyId \
--action 'lambda:InvokeFunction' \
--principal events.amazonaws.com \
--source-arn arn:aws:events:us-west-2:129801715103:rule/MyScheduledRule


