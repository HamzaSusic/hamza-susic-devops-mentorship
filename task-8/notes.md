
TASK 8

Commands used in this task:

For creating aws profile
```
$ aws configure
```

For adding DNS record through AWS CLI
```
$ aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"hamza-susic.awsbosnia.com.","Type":"A","TTL":60,"ResourceRecords":[{"Value":"x.xx.xx.x."}]}}]}'
```

Displaying DNS record:
```
aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "hamza-susic.awsbosnia.com.") | {Name, Value}'
```

Installing jq on Ubuntu:
```
apt install jq
```

Creating Lets Encrypt certificate on EC2 (NGINX)
```
sudo dnf install python3 augeas-libs

sudo python3 -m venv /opt/certbot/

sudo /opt/certbot/bin/pip install --upgrade pip

sudo /opt/certbot/bin/pip install certbot certbot-nginx

sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot

sudo certbot certonly --nginx
```

Autorenewal of SSL certificate
```
SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
```

Display currently used SSL certificate
```
openssl x509 -in cert.pem -text -noout

echo | openssl s_client -showcerts -servername hamza-susic.awsbosnia.com -connect hamza-susic.awsbosnia.com:443 2>/dev/null | openssl x509 -inform pem -noout –text
```