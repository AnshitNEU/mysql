#!/bin/bash
sudo touch ~/cloudwatch.log
cd ~
sudo -s
sudo echo Y | apt-get install python >> ~/cloudwatch.log
echo "downloading awslogs-agent-setup.." >> ~/cloudwatch.log
echo "modifying permissions for setup" >> ~/cloudwatch.log
cd /etc/systemd/system
sudo touch awslogs.service
sudo chmod 777 awslogs.service
sudo echo [Unit] > awslogs.service
sudo echo Description=Service for CloudWatch Logs agent >> awslogs.service
sudo echo After=rc-local.service >> awslogs.service
sudo echo [Service] >> awslogs.service
sudo echo Type=simple >> awslogs.service
sudo echo Restart=always >> awslogs.service
sudo echo KillMode=process >> awslogs.service
sudo echo TimeoutSec=infinity >> awslogs.service
sudo echo PIDFile=/var/awslogs/state/awslogs.pid >> awslogs.service
sudo echo "ExecStart=/var/awslogs/bin/awslogs-agent-launcher.sh --start --background --pidFile $PIDFILLE --user awslogs --chuid awslogs &amp;" >> awslogs.service
sudo echo [Install] >> awslogs.service
sudo echo WantedBy=multi-user.target >> awslogs.service
sudo systemctl daemon-reload
sleep 2
sudo systemctl start awslogs.service
sleep 2
sudo systemctl enable awslogs.service
sudo touch ~/awslogs.conf
cd ~
sudo echo [general] > ~/awslogs.conf
sudo echo "state_file= /var/awslogs/state/agent-state" >> ~/awslogs.conf
sudo echo [/var/lib/tomcat8/logs/catalina.out] >> ~/awslogs.conf
sudo echo file = /var/lib/tomcat8/logs/catalina.out >> ~/awslogs.conf
sudo echo "log_group_name = myloggroup" >> ~/awslogs.conf
sudo echo "log_stream_name = myweblogstream" >> ~/awslogs.conf
sudo echo "datetime_format = %d/%b/%Y:%H:%M:%S\" >> ~/awslogs.conf
cd ~
sudo curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O >> ~/cloudwatch.log
sudo chmod 777 ~/awslogs-agent-setup.py >> ~/awslogs.conf
sudo python ~/awslogs-agent-setup.py --region us-east-1 -c ~/awslogs.conf --non interactive
sudo systemctl restart awslogs.service
