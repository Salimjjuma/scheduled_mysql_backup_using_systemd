
# Using systemd Timers for Regular Backups

If your system uses systemd (which is common on modern Linux distributions), you can also use systemd timers to schedule regular backups. Systemd timers provide more advanced features, such as automatic retries, logging, and integration with the system's service manager.

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

    [Service]
    ExecStart=/path/to/your/backup_script.sh
    ```

  2. Create a systemd timer file: Now, create a timer file that will trigger the service at a scheduled time. 

  - Create a timer file at `/etc/systemd/system/backup-script.timer`:

  ```bash
  sudo nano /etc/systemd/system/backup-script.timer
  ```

  - Add the following content to the timer file:

  ```ini
    [Unit]
    Description=Runs Backup Script Daily at 10:00AM

    [Timer]
    OnCalendar=*-*-* 10:00:00
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

