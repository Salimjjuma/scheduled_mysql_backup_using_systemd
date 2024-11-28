# Using systemd Timers for Regular Backups

If your system uses systemd (which is common on modern Linux distributions), you can also use systemd timers to schedule regular backups. Systemd timers provide more advanced features, such as automatic retries, logging, and integration with the system's service manager.

## Verify Script Permissions

Make sure the script (db_backup.sh) is executable:

```bash
chmod +x /path/to/your/workspace/db_backup.sh
```

## Steps to Schedule Regular Backups with systemd:

1. Create a systemd service file: First, create a systemd service unit for your backup script. This file will define what command to run when triggered.

- Create a service file at /etc/systemd/system/backup-script.service:

```bash
sudo nano /etc/systemd/system/backup-script.service
```

- Add the following content to the file

```ini
[Unit]
Description=Backup Script
After=network.target

[Service]
WorkingDirectory=/path/to/your/workspace/
ExecStart=/bin/bash -x /path/to/your/workspace/db_backup.sh
```

## Enhancing the Logs:

If you'd like more detailed output in the journal, you can enable logging directly from your script to make debugging easier:

```ini
ExecStart=/bin/bash -x /path/to/your/workspace/db_backup.sh

```

2. Create a systemd timer file: Now, create a timer file that will trigger the service at a scheduled time.

- Create a timer file at `/etc/systemd/system/backup-script.timer`

```bash
sudo nano /etc/systemd/system/backup-script.timer
```

- Add the following content to the timer file:

```ini
[Unit]
Description=Runs Backup Script Daily at 11:00 AM

[Timer]
OnCalendar=*-*-* 11:00:00
Persistent=true
Unit=backup-script.service

[Install]
WantedBy=timers.target

```

- This will trigger the `backup-script.service` everyday at 10:00 AM.

3. Enable and start the systemd timer

- Reload the systemd manager configuration to apply the new unit files:

```bash
  sudo systemctl daemon-reload
```

- Start the time:

```bash
sudo systemctl start backup-script.timer
```

- Enable the time to ensure it starts automatically on boot:

```bash
sudo systemctl enable backup-script.timer
```

4. Check the status of the timer: To verify the timer is active, us the following command:

```bash
sudo systemctl status backup-script.timer
```

Check Timer status

- Check if the timer is active and correctly scheduled

```bash
sudo systemctl list-timers --all
```

## Debugging Errors

Check the logs for the service and timer for errors:

```bash
sudo journalctl -u backup-script.service
sudo journalctl -u backup-script.timer

```

## docker-compose.yml

Add the following line to your docker-compose.yml file:

```yaml
volumes:
  - /path/to/your/workspace/my.cnf:/docker-entrypoint-initdb.d/my.cnf
```
