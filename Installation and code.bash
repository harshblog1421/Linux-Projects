🚀 Step-by-Step Implementation
🔹 1. Creating the Shell Script
#!/bin/bash
# Server Health Monitoring Script
# Logs system health and sends an alert if limits are exceeded

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/server_health.log"
EMAIL="your-email@gmail.com"

# Capture CPU, Memory & Disk Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEMORY_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')

# Log Entry
echo "$(date) | CPU: $CPU_USAGE% | Memory: $MEMORY_USAGE% | Disk: $DISK_USAGE%" >> $LOG_FILE

# Check and Send Alert
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "High CPU Usage: $CPU_USAGE%" | mail -s "ALERT: High CPU Usage" $EMAIL
fi

if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "High Memory Usage: $MEMORY_USAGE%" | mail -s "ALERT: High Memory Usage" $EMAIL
fi

if (( $DISK_USAGE > $DISK_THRESHOLD )); then
    echo "High Disk Usage: $DISK_USAGE%" | mail -s "ALERT: High Disk Usage" $EMAIL
fi

📌 Errors Encountered & Fixes:
Syntax Error: ((: 26 > 80.0 : syntax error: invalid arithmetic operator (error token is '.0'))
Fix: Used bc -l for floating-point comparison in CPU & Memory checks.

🔹 2. Automating the Script with Crontab
To execute the script every 5 minutes:
crontab -e
*/5 * * * * /home/ubuntu/server_health.sh
✅ Ensures the script runs every 5 minutes.

🔹 3. Deploying as a Systemd Service
To keep the script running at system startup, create a service file:
sudo nano /etc/systemd/system/server_health.service
[Unit]
Description=Server Health Monitoring Service
After=network.target

[Service]
ExecStart=/bin/bash /home/ubuntu/server_health.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target

-> Enable and start the service:
sudo systemctl daemon-reload
sudo systemctl enable server_health.service
sudo systemctl start server_health.service
✅ Ensures script runs on system reboot.
