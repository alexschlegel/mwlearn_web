D=`date +"%Y%m%d%H%M%S"`
DBACKUP="/var/www/mwlearn/backup/db/$D/"
mongodump -o $DBACKUP
