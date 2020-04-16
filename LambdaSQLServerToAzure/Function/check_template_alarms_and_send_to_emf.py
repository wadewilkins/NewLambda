import sys
import logging
import rds_config
import pymssql
import uuid
import json
from azure.servicebus import ServiceBusService
from base64 import b64decode

#rds settings
rds_host  = rds_config.db_endpoint
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name
connection_error=0

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = pymssql.connect(host=rds_host, user=name, password=password, database=db_name)
except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    connection_error=1

def lambda_handler(event, context):

    key_name = "awscollector"
    service_namespace = "em-lab-ns-intake01"
    key_value = "1gsvM56NH02r1qhLs/czbjdjNqEnVnqwi4GZNn20b2s="
    sbs = ServiceBusService(service_namespace,
                            shared_access_key_name=key_name,
                            shared_access_key_value=key_value,
                            timeout=30)

    if connection_error == 1:
       event_out = {}
       event_out['Source'] = 'RDS Lambda Alarm'
       event_out['Host'] = rds_host
       event_out['EventType'] = 'Unable to connect to database to monitor'
       event_out['Summary'] = 'This is fired when seriouse problems with the database'
       event_out['Severity'] = 0
       event_out['ExtraDetails'] = 'test'
       event_out['emf_id'] = str(uuid.uuid4())
       event_out['source_instance'] = rds_host
       logger.info("Message: " + str(event_out))
       #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))
       sys.exit();
      

    sql = ''\
    'select TOP 1 timestamp, convert(xml, record) as record '\
           'from sys.dm_os_ring_buffers '\
           'where ring_buffer_type = N\'RING_BUFFER_SCHEDULER_MONITOR\' '\
           'and record like \'%<SystemHealth>%\' '\
           'ORDER BY timestamp desc '

    logger.info(sql)

    item_count = 0
    with conn.cursor() as cur:
        #cur.execute(sql)
        cur.callproc('wade_get')
        for row in cur:
            item_count += 1
            event_out = {}
            event_out['Source'] = 'RDS Lambda Alarm'
            event_out['Host'] = 'wwilkins4'
            event_out['EventType'] = 'RDS SQL Server Errored statements'
            event_out['Summary'] = 'This is fired when the volume of errors is high'
            event_out['Severity'] = 0
            event_out['ExtraDetails'] = 'test'
            event_out['emf_id'] = str(uuid.uuid4())
            event_out['source_instance'] = 'wwilkins4'
            #logger.info("Message: " + str(event_out))
            logger.info("new Message: " + str(row[2]))
            #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))



    return "Added %d items from RDS MySQL table" %(item_count)

