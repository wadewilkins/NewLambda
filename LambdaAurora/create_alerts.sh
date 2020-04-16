#!/bin/bash 

echo "create_alerts"
echo $@

RDS_IDENTIFIER=$1
SNS_TOPIC_ARN=$2
echo $RDS_IDENTIFIER

if [ $# -lt 2 ]; then
    echo "Usage1: $0 RDS_NAME "
    exit 0
fi
if [ -z ${RDS_IDENTIFIER} ]; then
    echo "Usage2: $0 RDS_NAME "
    exit 0
fi
if [ -z ${SNS_TOPIC_ARN} ]; then
    echo "Usage3: $0 RDS_NAME "
    exit 0
fi


aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_BufferCacheHitRatio --alarm-description "Alarm when buffer cache hit ratio is bellow 80 percent" --metric-name BufferCacheHitRatio --namespace AWS/RDS --statistic Average --period 60 --threshold 80 --comparison-operator LessThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Percent

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_BlockedTransactions --alarm-description "Alarm for blocked transations" --metric-name BlockedTransactions --namespace AWS/RDS --statistic Average --period 300 --threshold 5 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_AuroraBinlogReplicaLag --alarm-description "Alarm when Aurora Bin Log Replic Lag is occurring" --metric-name AuroraBinlogReplicaLag --namespace AWS/RDS --statistic Average --period 60 --threshold 80 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_DatabaseConnections --alarm-description "Alarm when database connections reach a specified threshold" --metric-name DatabaseConnections --namespace AWS/RDS --statistic Average --period 60 --threshold 500 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_CPUCreditBalance --alarm-description "Alarm when Aurora is getting close to it's CPU credit balance" --metric-name CPUCreditBalance --namespace AWS/RDS --statistic Average --period 60 --threshold 400 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_SelectLatency --alarm-description "Alarm when select statement latency exceeds thresholds" --metric-name SelectLatency --namespace AWS/RDS --statistic Average --period 60 --threshold .1 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Milliseconds

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_ActiveTransactions --alarm-description "Alarm when active transactions exceeds threshold" --metric-name ActiveTransactions --namespace AWS/RDS --statistic Average --period 60 --threshold 10 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count 

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_DMLLatency --alarm-description "Alarm when DML latency exceeds thresholds" --metric-name DMLLatency --namespace AWS/RDS --statistic Average --period 60 --threshold 100 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Milliseconds

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_Deadlocks --alarm-description "Alarm when Deadlocks are happening in Aurora" --metric-name Deadlocks --namespace AWS/RDS --statistic Average --period 60 --threshold 2 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 2  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_LoginFailures --alarm-description "Alarm when Aurora login failures are happening" --metric-name LoginFailures --namespace AWS/RDS --statistic Average --period 60 --threshold 2 --comparison-operator GreaterThanThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 2  --alarm-actions "${SNS_TOPIC_ARN}" --unit Count

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_FreableMemory --alarm-description "Alarm when Aurora is low on memory" --metric-name FreeableMemory --namespace AWS/RDS --statistic Average --period 300 --threshold 70000000 --comparison-operator LessThanOrEqualToThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 2  --alarm-actions "${SNS_TOPIC_ARN}" --unit Bytes


aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_CPUUtilization --alarm-description "Alarm when Aurora is using too much CPU" --metric-name CPUUtilization --namespace AWS/RDS --statistic Average --period 300 --threshold 85 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Percent

aws cloudwatch put-metric-alarm --alarm-name ${RDS_IDENTIFIER}_EngineUptime --alarm-description "Alarm when engine uptime is below  threshold" --metric-name EngineUptime --namespace AWS/RDS --statistic Average --period 60 --threshold 60 --comparison-operator LessThanOrEqualToThreshold  --dimensions Name=DBClusterIdentifier,Value=${RDS_IDENTIFIER}  --evaluation-periods 1  --alarm-actions "${SNS_TOPIC_ARN}" --unit Seconds
