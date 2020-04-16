import sys
import logging
import rds_config
import uuid
import json
from azure.servicebus import ServiceBusService
from base64 import b64decode
import psycopg2

#rds settings
rds_host  = rds_config.db_endpoint
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

logger = logging.getLogger()
logger.setLevel(logging.INFO)

try:
    conn_string = "host='"+rds_host+"' dbname='"+db_name+"' user='"+name+"' password='"+password+"'"
    conn = psycopg2.connect(conn_string)
except:
    print "I am unable to connect to the database"
    sys.exit()
logger.info("SUCCESS: Connection to RDS porstgresql instance succeeded")

def lambda_handler(event, context):

    key_name = "awscollector"
    #key_value = os.environ.get('EMF_KEY_VALUE')
    key_value = "1gsvM56NH02r1qhLs/czbjdjNqEnVnqwi4GZNn20b2s="
    service_namespace = "em-lab-ns-intake01"
    sbs = ServiceBusService(service_namespace,
                            shared_access_key_name=key_name,
                            shared_access_key_value=key_value,
                            timeout=30)

    sql = ''\
    'SELECT blocked_locks.pid     AS blocked_pid, '\
           'blocked_activity.usename  AS blocked_user, '\
           'blocking_locks.pid     AS blocking_pid, '\
           'blocking_activity.usename AS blocking_user, '\
           'blocked_activity.query    AS blocked_statement, '\
           'blocking_activity.query   AS current_statement_in_blocking_process '\
     'FROM  pg_catalog.pg_locks         blocked_locks '\
      'JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid '\
      'JOIN pg_catalog.pg_locks         blocking_locks  '\
          'ON blocking_locks.locktype = blocked_locks.locktype '\
          'AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE '\
          'AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation '\
          'AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page '\
          'AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple '\
          'AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid '\
          'AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid '\
          'AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid '\
          'AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid '\
          'AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid '\
          'AND blocking_locks.pid != blocked_locks.pid '\
      'JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid '\
     'WHERE NOT blocked_locks.GRANTED'

    logger.info("SQL:  " + str(sql))

    cur = conn.cursor()
    cur.execute(sql)
    item_count = 0
    for row in cur:
        #do something with every single row here
        #optionally print the row
        print row
        logger.info("Message: " + str(row))
        if item_count < 1:
            event_out = {}
            event_out['Source'] = 'RDS Lambda Alarm'
            event_out['Host'] = rds_host
            event_out['EventType'] = 'RDS Postgres blocking locks'
            event_out['Summary'] = 'This is fired when there is blocking happening in the Postgresql'
            event_out['Severity'] = 0
            #event_out['ExtraDetails'] = 'Blocked: ' + row.blocked_statement + ' Blocking: ' + row.current_statement_in_blocking_process + '\n'
            event_out['ExtraDetails'] = row
            event_out['emf_id'] = str(uuid.uuid4())
            event_out['source_instance'] = db_name
        else:
            event_out['ExtraDetails'] = event_out['ExtraDetails'] + row
        item_count += 1
    if item_count > 0:
        sbs.send_event('lab-eh-aws-intake', json.dumps(event_out))
        logger.info("Message: " + str(event_out))


    return "Added %d items from RDS Postgresql table"

