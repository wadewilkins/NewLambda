#!/bin/sh
# parameter 1 = AWS ACCOUNT ID
# parameter 2 = AWS region
# parameter 3 = datbase name
# parameter 4 = database userid
# parameter 5 = database password
# parameter 6 = database arn

echo "user=" $4
echo "password=" $5
echo "db_name=" $3
echo "datase arn=" $6

SRC="db_username"
DST="db_username = \"$4\""
sed -i "/$SRC/c$DST" ./Function/rds_config.py

SRC="db_password"
DST="db_password = \"$5\""
sed -i "/$SRC/c$DST" ./Function/rds_config.py

SRC="db_name"
DST="db_name = \"$3\""
sed -i "/$SRC/c$DST" ./Function/rds_config.py

SRC="database arn"
DST="database arn = \"$6\""
sed -i "/$SRC/c$DST" ./Function/rds_config.py

lambda_name="check_$3_alarms_and_send_to_emf"
cd Function; cp check_template_alarms_and_send_to_emf.py $lambda_name.py; zip -r $lambda_name.zip *; cd ..
cp -f Function/*.zip ./
zip_file="${lambda_name}.zip"

role_arn="arn:aws:iam::$1:role/Lambda-Monitoring-role"

role_name="Lambda-Monitoring-role"
role_policy_arn="arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

aws iam create-role \
    --role-name "${role_name}" \
    --assume-role-policy-document file://assume-role-policy.txt
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"

aws lambda create-function \
    --region "$2" \
    --function-name "${lambda_name}"  \
    --zip-file "fileb://${zip_file}" \
    --role "${role_arn}" \
    --handler "${lambda_name}.lambda_handler" \
    --runtime python2.7 \
    --timeout 60 \

aws lambda add-permission \
    --function-name "${lambda_name}" \
    --statement-id MyId \
    --action 'lambda:InvokeFunction' \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:$2:$1:rule/MyScheduledRule

aws events put-rule \
    --name MyScheduledRule \
    --schedule-expression 'rate(5 minutes)'

schedule_arn="arn:aws:lambda:$2:$1:function:$lambda_name"
aws events put-targets \
    --rule MyScheduledRule \
    --targets "{\"Id\" : \"1\", \"Arn\": \"${schedule_arn}\" }"


