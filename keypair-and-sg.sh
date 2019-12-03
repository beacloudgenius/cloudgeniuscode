yes y | ssh-keygen -t rsa  -N "" -C "CloudGenius" -f ~/.ssh/CloudGenius > /dev/null
aws ec2 delete-key-pair --key-name DoNotUseThisKey-CloudGeniusOnly
aws ec2 import-key-pair --key-name "DoNotUseThisKey-CloudGeniusOnly" --public-key-material file://~/.ssh/CloudGenius.pub
aws ec2 delete-security-group --group-name DoNotUseThisSG-CloudGeniusOnly > /dev/null 2>&1
security_response=$(aws ec2 create-security-group \
 --group-name "DoNotUseThisSG-CloudGeniusOnly" \
 --description "DoNotUseThisSG-CloudGeniusOnly security group" \
 --output json)
groupId=$(echo -e "$security_response" |  jq '.GroupId' | tr -d '"')
aws ec2 create-tags \
  --resources "$groupId" \
  --tags Key=Name,Value="DoNotUseThisSG-CloudGeniusOnly"
security_response2=$(aws ec2 authorize-security-group-ingress \
 --group-id "$groupId" \
 --protocol tcp --port 22 \
 --cidr "0.0.0.0/0")
rm -rf provision.txt
curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/provision.txt
