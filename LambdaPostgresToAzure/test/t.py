# psql --host=wwilkins5.czkg5cms1vxp.us-west-2.rds.amazonaws.com --port=5432 --username=wwilkins --password  --dbname=wwilkins5
#!/usr/bin/python
import psycopg2
import sys
 
def main():
	#Define our connection string
	conn_string = "host='wwilkins5.czkg5cms1vxp.us-west-2.rds.amazonaws.com' dbname='wwilkins5' user='wwilkins' password='wwilkins'"
 
	# print the connection string we will use to connect
	print "Connecting to database\n	->%s" % (conn_string)
 
	# get a connection, if a connect cannot be made an exception will be raised here
	conn = psycopg2.connect(conn_string)
 
	# conn.cursor will return a cursor object, you can use this cursor to perform queries
	cursor = conn.cursor()
	print "Connected!\n"
 
if __name__ == "__main__":
	main()
