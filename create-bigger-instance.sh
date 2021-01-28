instance_response=$(aws ec2 run-instances \
    --image-id ami-0edf3b95e26a682df \
    --count 1 \
    --instance-type t2.medium \
    --key-name Key-only-for-use-with-CloudGenius-workstation \
    --security-groups SG-only-for-use-with-CloudGenius-workstation \
    --user-data file://provision.txt \
    --block-device-mappings 'DeviceName=/dev/xvdf,Ebs={VolumeSize=20,VolumeType=gp2,DeleteOnTermination=false,Encrypted=true}' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="Cloud Genius Workstation"}]' 'ResourceType=volume,Tags=[{Key=Name,Value="Disk for Cloud Genius"}]')
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
  IdentityFile ~/.ssh/CloudGenius
  LocalForward 8080 127.0.0.1:80
  LocalForward 4000 127.0.0.1:4000
EOF
mv -f config ~/.ssh/config
# rm -rf provision.txt
