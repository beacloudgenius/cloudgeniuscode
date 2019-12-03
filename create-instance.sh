instance_response=$(aws ec2 run-instances \
    --image-id ami-06d51e91cea0dac8d \
    --count 1 \
    --instance-type t2.micro \
    --key-name DoNotUseThisKey-CloudGeniusOnly \
    --security-groups DoNotUseThisSG-CloudGeniusOnly \
    --user-data file://provision.txt \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="DontMessWithThis-Cloud Genius Workstation"}]' 'ResourceType=volume,Tags=[{Key=Name,Value="Disk for Cloud Genius"}]')
sleep 60
instanceId=$(echo -e "$instance_response" |  jq -r '.Instances[] | .InstanceId' | tr -d '"')
PublicIpAddress=$(aws ec2 describe-instances \
    --instance-id $instanceId | jq -r '.Reservations[] | .Instances[] | .PublicIpAddress' | tr -d '"')
rm -rf config
cat <<EOF >config
# Created on $(date)
Host CloudGenius
  HostName $PublicIpAddress
  ForwardAgent yes
  User ubuntu
  StrictHostKeyChecking no
  IdentityFile ./.ssh/CloudGenius
EOF
mv -f config ~/.ssh/config
rm -rf provision.txt
