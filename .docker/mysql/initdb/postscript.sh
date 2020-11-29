#!/usr/bin/env bash
echo "--------------------------------------------------------"
echo "Create test database!"
mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "CREATE DATABASE test CHARACTER SET utf8 COLLATE utf8_bin"

mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "GRANT ALL PRIVILEGES on test.* TO 'mysql_user'@'%'"

mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "flush privileges;"

echo "--------------------------------------------------------"
