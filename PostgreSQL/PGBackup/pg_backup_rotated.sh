#!/bin/bash
 
###########################
####### LOAD CONFIG #######
###########################
 
SCRIPTPATH=$(cd ${0%/*} && pwd -P)
source $SCRIPTPATH/pg_backup.config
 
 
###########################
#### PRE-BACKUP CHECKS ####
###########################
 
# Make sure we're running as the required backup user
if [ "$BACKUP_USER" != "" -a "$(id -un)" != "$BACKUP_USER" ]; 
then
	echo "This script must be run as $BACKUP_USER. Exiting."
	exit 1;
fi;
 
 
###########################
### INITIALISE DEFAULTS ###
###########################
 
if [ ! $HOSTNAME ]; then
	HOSTNAME="localhost"
fi;
 
if [ ! $USERNAME ]; then
	USERNAME="postgres"
fi;
 
if [ $ENABLE_SAMBA_SHARE = "yes" ]
then
        mkdir -p $BACKUP_MOUNT_DIR_SAMBA

	mount -t cifs $BACKUP_SAMBA_DIR $BACKUP_MOUNT_DIR_SAMBA -rw -o user=$SAMBA_USER,password=$SAMBA_PASSWORD,iocharset=utf8

#	echo "mount -t cifs $BACKUP_SAMBA_DIR $BACKUP_MOUNT_DIR_SAMBA -rw -o user=$SAMBA_USER,password=$SAMBA_PASSWORD"


	BACKUP_DIR=$BACKUP_MOUNT_DIR_SAMBA

fi;

BACKUP_LOGFILE=$BACKUP_DIR$BACKUP_LOGFILE


###########################
#### START THE BACKUPS ####
###########################

touch $BACKUP_LOGFILE
TIMEINFO=`date '+%T %x'`
echo "$TIMEINFO - Backup job started." >> $BACKUP_LOGFILE


function perform_backups()
{
	SUFFIX=$1
	FINAL_BACKUP_DIR=$BACKUP_DIR"`date +\%Y-\%m-\%d`$SUFFIX/"
 
	echo "Making backup directory in $FINAL_BACKUP_DIR"

	TIMEINFO=`date '+%T %x'`
	echo "$TIMEINFO - Making backup directory in $FINAL_BACKUP_DIR" >> $BACKUP_LOGFILE
 
	if ! mkdir -p $FINAL_BACKUP_DIR; then
		echo "Cannot create backup directory in $FINAL_BACKUP_DIR. Go and fix it!"
		TIMEINFO=`date '+%T %x'`
	        echo "$TIMEINFO - Cannot create backup directory in $FINAL_BACKUP_DIR. Go and fix it!" >> $BACKUP_LOGFILE

		exit 1;
	fi;
 
 
	###########################
	### SCHEMA-ONLY BACKUPS ###
	###########################
 
	for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
	do
	        SCHEMA_ONLY_CLAUSE="$SCHEMA_ONLY_CLAUSE or datname ~ '$SCHEMA_ONLY_DB'"
	done
 
	SCHEMA_ONLY_QUERY="select datname from pg_database where false $SCHEMA_ONLY_CLAUSE order by datname;"
 
	echo -e "\n\nPerforming schema-only backups"
	echo -e "--------------------------------------------\n"
 
	SCHEMA_ONLY_DB_LIST=`psql -h "$HOSTNAME" -U "$USERNAME" -At -c "$SCHEMA_ONLY_QUERY" postgres`
 
	echo -e "The following databases were matched for schema-only backup:\n${SCHEMA_ONLY_DB_LIST}\n"
        TIMEINFO=`date '+%T %x'`
        echo "$TIMEINFO - The following databases were matched for schema-only backup:\n${SCHEMA_ONLY_DB_LIST}" >> $BACKUP_LOGFILE
 

	for DATABASE in $SCHEMA_ONLY_DB_LIST
	do
	        echo "Schema-only backup of $DATABASE"
	        TIMEINFO=`date '+%T %x'`
	        echo "$TIMEINFO - Schema-only backup of $DATABASE" >> $BACKUP_LOGFILE

 
	        if ! pg_dump -Fp -s -h "$HOSTNAME" -U "$USERNAME" "$DATABASE" | gzip > $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz.in_progress; then
	                echo "[!!ERROR!!] Failed to backup database schema of $DATABASE"
                TIMEINFO=`date '+%T %x'`
                echo "$TIMEINFO - [!!ERROR!!] Failed to backup database schema of $DATABASE" >> $BACKUP_LOGFILE

	        else
	                mv $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz.in_progress $FINAL_BACKUP_DIR"$DATABASE"_SCHEMA.sql.gz
	        fi
	done

        TIMEINFO=`date '+%T %x'`
        echo "$TIMEINFO - Schema only job terminated." >> $BACKUP_LOGFILE

 
	###########################
	###### FULL BACKUPS #######
	###########################
 
	for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
	do
		EXCLUDE_SCHEMA_ONLY_CLAUSE="$EXCLUDE_SCHEMA_ONLY_CLAUSE and datname !~ '$SCHEMA_ONLY_DB'"
	done
 
	FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate and datallowconn $EXCLUDE_SCHEMA_ONLY_CLAUSE order by datname;"
 
	echo -e "\n\nPerforming full backups"
	echo -e "--------------------------------------------\n"
 
	for DATABASE in `psql -h "$HOSTNAME" -U "$USERNAME" -At -c "$FULL_BACKUP_QUERY" postgres`
	do
		if [ $ENABLE_PLAIN_BACKUPS = "yes" ]
		then
			echo "Plain backup of $DATABASE"
		        TIMEINFO=`date '+%T %x'`
		        echo "$TIMEINFO - Plain backup of $DATABASE" >> $BACKUP_LOGFILE

 
			if ! pg_dump -Fp -h "$HOSTNAME" -U "$USERNAME" "$DATABASE" | gzip > $FINAL_BACKUP_DIR"$DATABASE".sql.gz.in_progress; then
				echo "[!!ERROR!!] Failed to produce plain backup database $DATABASE"
        	                TIMEINFO=`date '+%T %x'`
	                        echo "$TIMEINFO - [!!ERROR!!] Failed to produce plain backup database $DATABASE" >> $BACKUP_LOGFILE

			else
				mv $FINAL_BACKUP_DIR"$DATABASE".sql.gz.in_progress $FINAL_BACKUP_DIR"$DATABASE".sql.gz
			fi
		fi
                TIMEINFO=`date '+%T %x'`
                echo "$TIMEINFO - Plain backup of $DATABASE complete." >> $BACKUP_LOGFILE

 
		if [ $ENABLE_CUSTOM_BACKUPS = "yes" ]
		then
			echo "Custom backup of $DATABASE"
                        TIMEINFO=`date '+%T %x'`
                        echo "$TIMEINFO - Custom backup of $DATABASE" >> $BACKUP_LOGFILE

			if ! pg_dump -Fc -h "$HOSTNAME" -U "$USERNAME" "$DATABASE" -f $FINAL_BACKUP_DIR"$DATABASE".custom.in_progress; then
				echo "[!!ERROR!!] Failed to produce custom backup database $DATABASE"
                        TIMEINFO=`date '+%T %x'`
                        echo "$TIMEINFO - [!!ERROR!!] Failed to produce custom backup database $DATABASE" >> $BACKUP_LOGFILE
			
			else
				mv $FINAL_BACKUP_DIR"$DATABASE".custom.in_progress $FINAL_BACKUP_DIR"$DATABASE".custom
			fi
		fi
                TIMEINFO=`date '+%T %x'`
                echo "$TIMEINFO - Custom backup of $DATABASE complete." >> $BACKUP_LOGFILE

	done
 
	echo -e "\nAll database backups complete!"

        TIMEINFO=`date '+%T %x'`
        echo "$TIMEINFO - All database backups complete!" >> $BACKUP_LOGFILE

	if [ $ENABLE_SAMBA_SHARE = "yes" ]
	then
		umount $BACKUP_MOUNT_DIR_SAMBA
	fi;

        TIMEINFO=`date '+%T %x'`
        echo "$TIMEINFO --------------------------------------------------------------" >> $BACKUP_LOGFILE


}
 
# MONTHLY BACKUPS
 
DAY_OF_MONTH=`date +%d`
 
if [ $DAY_OF_MONTH = "1" ];
then
	# Delete all expired monthly directories
# 	find $BACKUP_DIR -maxdepth 1 -name "*-monthly" -exec rm -rf '{}' ';'
 
	perform_backups "-monthly"
 
	exit 0;
fi
 
# WEEKLY BACKUPS
 
DAY_OF_WEEK=`date +%u` #1-7 (Monday-Sunday)
EXPIRED_DAYS=`expr $((($WEEKS_TO_KEEP * 7) + 1))`
 
if [ $DAY_OF_WEEK = $DAY_OF_WEEK_TO_KEEP ];
then
	# Delete all expired weekly directories
	find $BACKUP_DIR -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*-weekly" -exec rm -rf '{}' ';'
 
	perform_backups "-weekly"
 
	exit 0;
fi
 
# DAILY BACKUPS
 
# Delete daily backups 7 days old or more
find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*-daily" -exec rm -rf '{}' ';'
 
perform_backups "-daily"

