#!/bin/bash

USER="root"
PASSWORD="oko"
OUTPUT="/Backups"
TODAY=`date +%Y%m%d`
FIVEDAYS=`date +%Y%m%d -d "5 day ago"`

rm -rf "$OUTPUT/db/$FIVEDAYS" > /dev/null 2>&1
mkdir $OUTPUT/db/$TODAY
rm -rf "$OUTPUT/www/$FIVEDAYS" > /dev/null 2>&1
mkdir $OUTPUT/www/$TODAY

databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases $db > $OUTPUT/db/$TODAY/$db.sql
    fi
done

cd /var/www/html
for dir in */
do
  base=$(basename "$dir")
  echo "Backing up folder: $dir"
  tar -czf "$OUTPUT/www/$TODAY/${base}.tar.gz" "$dir"
done

