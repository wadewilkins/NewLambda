from __future__ import print_function

import boto3
import json
import logging
import uuid

from base64 import b64decode
from urllib2 import Request, urlopen, URLError, HTTPError
import httplib
import urllib

logger = logging.getLogger()
logger.setLevel(logging.INFO)

azure_api_key='3b1ee4874d9e4196abd48b579bd43d28'
Severity = 'Severity_placeholder'
Environment = 'dev'
azure_url = 'emfapilab.azure-api.net'
azure_part = 'EMFAPILab'
sns_arn = 'Sns_arn_placeholder'


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    client = boto3.client('rds')
    alarm_name = message['Trigger']['MetricName']
    #old_state = message['OldStateValue']
    new_state = message['NewStateValue']
    reason = message['NewStateReason']
    AWSAccountId = message['AWSAccountId']
    summary = message['AlarmDescription']
    dimensions = message['Trigger']['Dimensions']
    source = "RDS - CloudWatch Alarm"
    DBInstanceIdentifier = ''
    DBClusterIdentifier = ''
    event_out = {}
    for dimension in dimensions:
        if dimension['name'] == 'DBInstanceIdentifier':
            DBInstanceIdentifier = dimension['value']
            logger.info("Instance Message: " + str(DBInstanceIdentifier) + " & Dimension: " +str(dimension))
        elif dimension['name'] == 'DBClusterIdentifier':
	    DBClusterIdentifier = dimension['value']
            logger.info("Cluster Message: " + str(DBClusterIdentifier) + " & Dimension: " +str(dimension))

    host = ''
    tags = {}
    tags['Reason'] = reason
    if DBInstanceIdentifier :
        response = client.describe_db_instances(DBInstanceIdentifier=DBInstanceIdentifier)
        resourceARN = "arn:aws:rds:"+response['DBInstances'][0]['AvailabilityZone'][:-1]+":"+AWSAccountId+":db:"+DBInstanceIdentifier
        #logger.info("Instance ARN: " + str(resourceARN))
        response_tag = client.list_tags_for_resource(ResourceName=resourceARN)

    elif DBClusterIdentifier :
	response_cluster = client.describe_db_clusters(DBClusterIdentifier=DBClusterIdentifier)
        DBInstanceIdentifier= response_cluster['DBClusters'][0]['DBClusterMembers'][0]['DBInstanceIdentifier']
        response = client.describe_db_instances(DBInstanceIdentifier=DBInstanceIdentifier)
        resourceARN = "arn:aws:rds:"+response['DBInstances'][0]['AvailabilityZone'][:-1]+":"+AWSAccountId+":db:"+DBInstanceIdentifier
        response_tag = client.list_tags_for_resource(ResourceName=resourceARN)
        #logger.info("Cluster get tags: " + str(response_tag))

    for tag in response_tag['TagList'] :
        if tag['Key'] == 'Application' :
            event_out['Application'] = tag['Value']
        if tag['Key'] == 'Team' :
            event_out['Team'] = tag['Value']

    event_out['Source'] = source
    event_out['Host'] = response['DBInstances'][0]['Endpoint']['Address']
    event_out['EventType'] = "PDBA DB:" + alarm_name
    event_out['Summary'] = summary + ' - ' + reason + '\n\n' + 'For account ID:  ' + context.invoked_function_arn.split(":")[4] + '\n\n' + 'ClusterIdentifier= ' + DBClusterIdentifier + '\n\nDBInstanceIdentifier= ' + DBInstanceIdentifier
    event_out['Severity'] = 2
    event_out['Environment'] = Environment
    event_out['AccountName'] = message['AWSAccountId']
    event_out['IPAddress'] = response['DBInstances'][0]['Endpoint']['Address']
    event_out['Rack'] = response['DBInstances'][0]['DBSubnetGroup']['VpcId']
    event_out['Location'] = response['DBInstances'][0]['AvailabilityZone']
    event_out['source_instance'] = DBInstanceIdentifier
    event_out['OperatingSystem'] = "Linux"
    event_out['os'] = "Linux"
    logger.info("Message: " + str(event_out))

    if Environment == 'dev' :
       sns_arn = 'arn:aws:sns:us-west-2:563065744523:LAB-UW2-SNS-EMF-Event-Intake'
    else:
       sns_arn = 'arn:aws:sns:us-west-2:832192135314:PRD-UW2-SNS-EMF-Event-Intake'

    try:
        sns = boto3.client('sns',region_name="us-west-2")
        sns.publish(
            #TopicArn= os.environ['SNS_Topic'],
            TopicArn= sns_arn,
            Message=json.dumps(event_out),
            Subject='EMF Email Event'
            )
    except Exception as e:
        print('[ERROR]: Failed to send event to SNS Topic:', e, '[PAYLOAD]:', str(event_out))
        return False
         
    return True

#    try:
#        print("Sending alert to Production EMF")
#        headers = {
#         # Request headers
#         #'Ocp-Apim-Subscription-Key': 'c0379fc8cda243acb4694a9a520cf7bc_addedToForceFailure'
#         'Content-Type': 'application/json'
#        }
#        params = urllib.urlencode({
#        })
#        print("About to post")

#        conn = httplib.HTTPConnection('emfapi.gslbapp.idx.expedmz.com:8888')
#        conn.request("POST", "/azure.http.api/?%s" % params, json.dumps(event_out) , headers)
#        print("Posted")
#        response = conn.getresponse()
#        print("Get Post response")
#        data1 = response.read()
#        conn.close()
#    except Exception as e:
#        logger.info("EMF Error!") 

