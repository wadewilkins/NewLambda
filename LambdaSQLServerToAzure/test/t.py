import sys

import pymssql

import rds_config
import pymssql
import uuid
import json

#rds settings
rds_host  = rds_config.db_endpoint
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name


print "database=%s" % rds_host
print "user=%s" % name
print "password=%s" % password
print "db_name=%s" % db_name

try:
    conn = pymssql.connect(host=rds_host, user=name, password=password, database=db_name)
    #conn = pymssql.connect(host='SQL01', user='user', password='password', database='mydatabase')
except:
    print "Damn"
    sys.exit()

cur = conn.cursor()
cur.execute('SELECT * FROM msdb.dbo.backupmediafamily')
row = cur.fetchone()
while row:
    print "ID=%d, Name=%s" % (row[0], row[1])
    row = cur.fetchone()

conn.close()
