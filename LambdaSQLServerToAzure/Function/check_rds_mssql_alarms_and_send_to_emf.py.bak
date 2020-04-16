import sys
import logging
import rds_config
import pymysql
import uuid
import json
from azure.servicebus import ServiceBusService
from base64 import b64decode

#rds settings
rds_host  = rds_config.db_endpoint
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=60)
except:
    logger.error("ERROR: Unexpected error: Could not connect to MySql instance.")
    sys.exit()

logger.info("SUCCESS: Connection to RDS mysql instance succeeded")

def lambda_handler(event, context):

    key_name = "awscollector"
    key_value = os.environ.get('EMF_KEY_VALUE')
    #key_value = "1gsvM56NH02r1qhLs/czbjdjNqEnVnqwi4GZNn20b2s="
    service_namespace = "em-lab-ns-intake01"
    sbs = ServiceBusService(service_namespace,
                            shared_access_key_name=key_name,
                            shared_access_key_value=key_value,
                            timeout=30)

    item_count = 0
    with conn.cursor() as cur:
        cur.execute("SELECT SUM(errors) FROM sys.statements_with_errors_or_warnings where last_seen >= CURRENT_TIMESTAMP - INTERVAL 5 MINUTE")
        for row in cur:
            item_count += 1
            if row[0] > rds_config.db_errors_per_cycle:
               event_out = {}
               event_out['Source'] = 'RDS Lambda Alarm'
               event_out['Host'] = 'wwilkins4'
               event_out['EventType'] = 'RDS MySQL Errored statements'
               event_out['Summary'] = 'This is fired when the volume of errors is high'
               event_out['Severity'] = 0
               event_out['ExtraDetails'] = 'test'
               event_out['emf_id'] = str(uuid.uuid4())
               event_out['source_instance'] = 'wwilkins4'
               logger.info("Message: " + str(event_out))
               #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))

        item_count = 0
        cur.execute("select count(*) from mysql.slow_log where start_time >= CURRENT_TIMESTAMP - INTERVAL 5 MINUTE")
        for row in cur:
            item_count += 1
            if row[0] > rds_config.db_slow_log_per_cycle:
               event_out = {}
               event_out['Source'] = 'RDS Lambda Alarm'
               event_out['Host'] = 'wwilkins4'
               event_out['EventType'] = 'RDS MySQL slow Query Log Volume'
               event_out['Summary'] = 'This is fired when the slow query log volume is high'
               event_out['Severity'] = 0
               event_out['ExtraDetails'] = 'test'
               event_out['emf_id'] = str(uuid.uuid4())
               event_out['source_instance'] = 'wwilkins4'
               logger.info("Message: " + str(event_out))
               #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))
    
        item_count = 0
        cur.execute("select count(*) from INFORMATION_SCHEMA.INNODB_LOCK_WAITS")
        for row in cur:
            item_count += 1
            if row[0] > rds_config.db_dead_locks_per_cycle:
               event_out = {}
               event_out['Source'] = 'RDS Lambda Alarm'
               event_out['Host'] = 'wwilkins4'
               event_out['EventType'] = 'RDS MySQL Deadlocks'
               event_out['Summary'] = 'This is fired when there is Deadlocks happening'
               event_out['Severity'] = 0
               event_out['ExtraDetails'] = 'test'
               event_out['emf_id'] = str(uuid.uuid4())
               event_out['source_instance'] = 'wwilkins4'
               logger.info("Message: " + str(event_out))
               #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))

        item_count = 0
        cur.execute("select SUBSTRING_INDEX(max_latency,' ',1), SUBSTRING_INDEX(max_latency,' ',-1) from sys.user_summary_by_statement_type where statement = 'select' and user <> 'rdsadmin'")
        for row in cur:
            item_count += 1
            if row[0] > rds_config.db_select_latency_per_cycle:
               event_out = {}
               event_out['Source'] = 'RDS Lambda Alarm'
               event_out['Host'] = 'wwilkins4'
               event_out['EventType'] = 'RDS MySQL slow Select'
               event_out['Summary'] = 'This is fired when there is slow select statements happening'
               event_out['Severity'] = 0
               event_out['ExtraDetails'] = 'test'
               event_out['emf_id'] = str(uuid.uuid4())
               event_out['source_instance'] = 'wwilkins4'
               logger.info("Message: " + str(event_out))
               sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))

        item_count = 0
        cur.execute("select SUBSTRING_INDEX(max_latency, ' ', 1),SUBSTRING_INDEX(max_latency, ' ', -1) from sys.user_summary_by_statement_type where statement in ('insert','update') and user <> 'rdsadmin'")
        for row in cur:
            item_count += 1
            if row[0] > rds_config.db_dml_latency_per_cycle:
               event_out = {}
               event_out['Source'] = 'RDS Lambda Alarm'
               event_out['Host'] = 'wwilkins4'
               event_out['EventType'] = 'RDS MySQL slow DML'
               event_out['Summary'] = 'This is fired when there is slow insert/updates'
               event_out['Severity'] = 0
               event_out['ExtraDetails'] = 'test'
               event_out['emf_id'] = str(uuid.uuid4())
               event_out['source_instance'] = 'wwilkins4'
               logger.info("Message: " + str(event_out))
               #sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))


    return "Added %d items from RDS MySQL table" %(item_count)

