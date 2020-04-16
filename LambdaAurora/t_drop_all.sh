#!/bin/bash 

echo "create_alerts"
echo $@

RDS_IDENTIFIER=$1

if [ $# -lt 1 ]; then
    echo "Usage1: $0 RDS_NAME "
    exit 0
fi
if [ -z ${RDS_IDENTIFIER} ]; then
    echo "Usage2: $0 RDS_NAME "
    exit 0
fi

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_BufferCacheHitRatio

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_BlockedTransactions

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_AuroraBinlogReplicaLag

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_DatabaseConnections 

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_CPUCreditBalance

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_SelectLatency

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_ActiveTransactions

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_DMLLatency

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_Deadlocks

aws cloudwatch delete-alarms --alarm-name ${RDS_IDENTIFIER}_LoginFailures

#aws lambda delete-function --function-name emf_cloudwatch_rds

#SNS_TOPIC_ARN=`aws sns list-topics | grep emf_cloudwatch |cut -f2- -d':' | tr -d '"' | tr -d ' '`
#echo $SNS_TOPIC_ARN
#aws sns delete-topic --topic-arn $SNS_TOPIC_ARN
