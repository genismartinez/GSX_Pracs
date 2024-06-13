#!/bin/bash

# Configuro el  cron per executar /root/vigila_snmp.sh cada 5 minuts
(crontab -l 2>/dev/null; echo "*/5 * * * * /root/vigila_snmp.sh") | crontab 
