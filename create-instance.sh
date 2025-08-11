rm -rf provision.txt
curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/provision.txt

instance_response=$(aws ec2 run-instances \
    --image-id ami-0964546d3da97e3ab \
    --count 1 \
    --instance-type t3.micro \
    --key-name CloudGenius-key \
    --security-groups CloudGenius-sg \
    --user-data file://provision.txt \
    --block-device-mappings 'DeviceName=/dev/sda1,Ebs={VolumeSize=28,VolumeType=gp2,DeleteOnTermination=true,Encrypted=true}' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="CloudGenius Workstation"}]' 'ResourceType=volume,Tags=[{Key=Name,Value="Disk for Cloud Genius"}]')
sleep 120
instanceId=$(echo -e "$instance_response" |  jq -r '.Instances[] | .InstanceId' | tr -d '"')
PublicIpAddress=$(aws ec2 describe-instances \
    --instance-id $instanceId | jq -r '.Reservations[] | .Instances[] | .PublicIpAddress' | tr -d '"')
rm -rf config
brew install gsed
gsed -i '/# BOF CloudGenius/,/# EOF CloudGenius/d' ~/.ssh/config
cat <<EOF >config
# BOF CloudGenius
# Created on $(date)
Host CloudGenius
  HostName $PublicIpAddress
  ForwardAgent yes
  User ubuntu
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/CloudGenius
  LocalForward 8080 127.0.0.1:80
  LocalForward 4000 127.0.0.1:4000
# EOF CloudGenius
EOF
cat config >> ~/.ssh/config
rm -rf config
# rm -rf provision.txt

# ssh -o "StrictHostKeyChecking no" CloudGenius "curl -s https://s3-us-west-2.amazonaws.com/cloudgeniuscode/mountdisk.sh | bash"

cat ~/.ssh/config

code
