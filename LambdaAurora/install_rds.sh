#/bin/bash
env=$1
RDS_IDENTIFIER=$2
echo $RDS_IDENTIFIER

echo `date`
echo "Zipping package..."
./create_package.sh $env

aws lambda remove-permission \
    --function-name pdba_emf_cloudwatch_rds \
    --statement-id pdba-sns

ROLE_ARN=`aws iam get-role --role-name lambda_basic_execution |grep Arn |cut -f2- -d':' |tr -d '"' | tr -d ' ' | tr -d ','`
echo `date`
aws lambda create-function --function-name pdba_emf_cloudwatch_rds --runtime "python2.7" --role $ROLE_ARN --description "Create EMF Lambda function" --handler "pdba_emf_cloudwatch_rds.lambda_handler" --publish --zip-file fileb://./pdba_emf_cloudwatch_rds.zip

echo `date`
aws sns create-topic --name pdba_emf_cloudwatch

echo `date`
LAMBDA_ARN=`aws lambda get-function --function-name pdba_emf_cloudwatch_rds | grep FunctionArn |cut -f2- -d':' |tr -d '"' | tr -d ' ' | tr -d ','`
echo $LAMBDA_ARN

SNS_TOPIC_ARN=`aws sns list-topics | grep pdba_emf_cloudwatch |cut -f2- -d':' | tr -d '"' | tr -d ' '`
echo $SNS_TOPIC_ARN

echo "Adding lambda permission to be triggered by sns"
echo `date`
aws lambda add-permission \
    --function-name pdba_emf_cloudwatch_rds \
    --statement-id pdba-sns \
    --action "lambda:InvokeFunction" \
    --principal sns.amazonaws.com \
    --source-arn $SNS_TOPIC_ARN 

echo `date`
aws sns subscribe --topic-arn $SNS_TOPIC_ARN --protocol lambda --notification-endpoint $LAMBDA_ARN

./create_alerts.sh $RDS_IDENTIFIER $SNS_TOPIC_ARN

 
#aws sns publish --message file://message.txt --subject Test \
#--topic-arn $SNS_TOPIC_ARN

echo "Installation complete"


