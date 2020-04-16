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
azure_url = 'emfapilab.azure-api.net'
azure_part = 'EMFAPILab'

def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    client = boto3.client('ec2')
    alarm_name = message['Trigger']['MetricName']
    #old_state = message['OldStateValue']
    new_state = message['NewStateValue']
    reason = message['NewStateReason']
    summary = message['AlarmDescription']
    dimensions = message['Trigger']['Dimensions']
    source = "EC2 - CloudWatch Alarm"
    instanceId = ''
    for dimension in dimensions:
        if dimension['name'] == 'InstanceId':
            instanceId = dimension['value']
            logger.info("Message: " + str(instanceId) + " & Dimension: " +str(dimension))


    host = ''
    tags = {}
    event_out = {}
    tags['Reason'] = reason
    if instanceId :
        response = client.describe_instances(InstanceIds=[instanceId])
        host = response['Reservations'][0]['Instances'][0]['PrivateIpAddress']
        tags['Tags'] = response['Reservations'][0]['Instances'][0]['Tags']
        for tag in tags['Tags'] :
            if tag['Key'] == 'Application' :
                event_out['Application'] = tag['Value']
            if tag['Key'] == 'Team' :
                event_out['Team'] = tag['Value']
        logger.info("Message: " + str(tags))
    else :
        tags['Tags'] = dimensions
        host = dimensions[0]['value']
        logger.info("Message: " + str(tags))
        instanceId = host

    tags['AWSAccountId'] = message['AWSAccountId']
    tags['Region'] = message['Region']
    event_out['Source'] = source
    event_out['Host'] = host
    event_out['EventType'] = alarm_name
    event_out['Summary'] = summary + ' - ' + reason
    event_out['Severity'] = 0
    event_out['ExtraDetails'] = json.dumps(tags)
    event_out['source_instance'] = instanceId
    logger.info("Message: " + str(event_out))

    headers = {
                # Request headers
                'Ocp-Apim-Subscription-Key': azure_api_key
               }
    params = urllib.urlencode({})
    conn = httplib.HTTPSConnection(azure_url)
    conn.request("POST", "/"+azure_part+"/?%s" % params, json.dumps(event_out) , headers)
    response = conn.getresponse()
    logger.info("Response: " + response.read())
    conn.close()
