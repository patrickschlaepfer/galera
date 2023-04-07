#!/usr/bin/bash

sysbench /usr/share/sysbench/oltp_read_write.lua --mysql-host=mysql.apps.ocp1.internal.schlaepfer.com --mysql-port=30036 --mysql-user=root --mysql-password='forch8127' --mysql-db=sbtest --db-driver=mysql --tables=3 --table-size=10000000 --threads=12 run
