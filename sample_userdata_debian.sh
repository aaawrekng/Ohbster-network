#!/bin/bash
apt update -y
apt install apache2 -y
apt install jq -y
systemctl enable apache2
systemctl start apache2

#Credit to Jay Remo next section
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait
macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$macid/vpc-id)

cat <<EOF > /var/www/html/index.html &

<html>
    <body>
    <h1>Ohbster's sample user data</h1><br/>

    <br/><h1>Stay Positive</h1>
    <div>
        <p><b>Instance Name:</b> $(hostname -f) </p>
        <p><b>Instance Private Ip Address: </b> $local_ipv4</p>
        <p><b>Availability Zone: </b> $az</p>
    </div>
    </body>
</html>
EOF


