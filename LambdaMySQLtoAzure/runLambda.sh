#!/bin/sh
lambda_name="check_rds_mysql_alarms"

aws lambda invoke \
    --function-name "${lambda_name}" \
    --region us-west-2 \
    output.txt

