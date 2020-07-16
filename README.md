Current state: Testing / WiP \
ToDo: Test, Complete Readme.

# mailcowdockerized_borgbackup_unofficial
Backup your mailcow-dockerized with borg

Designed to be added to the mailcow-dockerized stack via docker-compose.override.yml

BACKUP_INTERVAL can be one of: 5min, 15min, hourly, daily, weekly, monthly or "custom".\
If omitted, backup function will be skipped and you could run other borg commands instead. \
If "custom" is used, you will have to get the crontab, uncomment the last line and edit the schedule according to your needs. Add
```
-v /path/to/crontab:/root/crontab \
```
to the run command to overwrite the default file with yours.

For possible values/usage of BORG_REPO, BORG_RSH, BORG_PASSPHRASE, the BORG_*_CMD variables, as well as other borg commands, please consult the borg documentat
ion at \
https://borgbackup.readthedocs.io/

And, last but not least: \
**Always check your logs, attempt restores etc. to be sure it's working!**

