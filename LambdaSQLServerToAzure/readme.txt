


yum install freetds-devel
export C_INCLUDE_PATH=/usr/include
yum install pymssql
cd Function
cp /usr/lib64/python2.7/dist-packages/pymssql.so ./
cp -r /usr/lib64/python2.7/dist-packages/pymssql-2.1.3.dist-info/ ./

