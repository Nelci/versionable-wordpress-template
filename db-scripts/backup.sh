#! /bin/sh
# based https://stackoverflow.com/questions/3669121/dump-all-mysql-tables-into-separate-files-automatically
# based https://stackoverflow.com/questions/10445934/change-multiple-files
mysql_ready() {
    mysqladmin ping --user=root --password=$MYSQL_ROOT_PASSWORD > /dev/null 2>&1
    mysql --user=root --password=$MYSQL_ROOT_PASSWORD -e "show databases" | grep $MYSQL_DATABASE
}

while !(mysql_ready)
do
    sleep 3
    echo "waiting for mysql ..."
done

mysqldump --user=root --password=$MYSQL_ROOT_PASSWORD --tab=/opt/backup $MYSQL_DATABASE
find /opt/backup/ -type f -name '*.sql' -exec sed -i '/-- Dump completed on /d' {} \;