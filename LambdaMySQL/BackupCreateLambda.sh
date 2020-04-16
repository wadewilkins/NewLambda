#!/bin/sh
cp -f Function/*.zip ./
lambda_name="check_rds_mysql_alarms"
zip_file="${lambda_name}.zip"
role_arn="arn:aws:iam::129801715103:role/wade-role"
#subnet_ids=`aws ec2 describe-subnets | jq -r '.Subnets|map(.SubnetId)|join(",")'`
#subnet_ids="subnet-4306ac27,subnet-4c9c8229,subnet-3edd9567,subnet-ac20efda,subnet-06223c5f,subnet-25625052,subnet-e022ed96"
subnet_ids="subnet-4c9c8229"
echo "subnet:" $subnet_ids
sec_group_id=`aws ec2 describe-security-groups --group-name "default" | jq -r '.SecurityGroups[].GroupId'`
echo "sec_group_id:" $sec_group_id

#files="mysql_test.py rds_config.py"
#chmod 755 ${files}
#zip -r "${zip_file}" pymysql ${files}

aws lambda create-function \
    --region "us-west-2" \
    --function-name "${lambda_name}"  \
    --zip-file "fileb://${zip_file}" \
    --role "${role_arn}" \
    --handler "${lambda_name}.lambda_handler" \
    --runtime python2.7 \
    --timeout 60 \
    --vpc-config SubnetIds="${subnet_ids}",SecurityGroupIds="${sec_group_id}"

#aws lambda update-function-configuration \
#    --function-name check_rds_mysql_alarms \
#    --vpc-config SubnetIds=[],SecurityGroupIds=[]

aws lambda add-permission \
    --function-name check_rds_mysql_alarms \
    --statement-id MyId \
    --action 'lambda:InvokeFunction' \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:us-west-2:129801715103:rule/MyScheduledRule

aws events put-rule \
    --name MyScheduledRule \
    --schedule-expression 'rate(5 minutes)'


aws events put-targets \
    --rule MyScheduledRule \
    --targets '{"Id" : "1", "Arn": "arn:aws:lambda:us-west-2:129801715103:function:check_rds_mysql_alarms"}'

