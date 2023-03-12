#! /bin/sh
# based https://stackoverflow.com/questions/9000147/how-to-easily-import-multiple-sql-files-into-a-mysql-database
# based https://dba.stackexchange.com/questions/182820/how-to-import-all-the-files-in-a-directory-with-a-single-command-using-mysqlimpo

mysql_ready() {
    mysqladmin ping --user=root --password=$MYSQL_ROOT_PASSWORD > /dev/null 2>&1
    mysql --user=root --password=$MYSQL_ROOT_PASSWORD -e "show databases" | grep $MYSQL_DATABASE
}

while !(mysql_ready)
do
    sleep 3
    echo "waiting for mysql ..."
done

cat /opt/backup/*.sql | mysql --user=root --password=$MYSQL_ROOT_PASSWORD --progress-reports $MYSQL_DATABASE
for file in /opt/backup/*.txt
do 
   mysqlimport --user=root --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE $file
done