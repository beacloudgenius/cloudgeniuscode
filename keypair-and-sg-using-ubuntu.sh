yes y | ssh-keygen -t rsa -b 4096 -N "" -C "CloudGenius" -f ~/.ssh/CloudGenius > /dev/null
aws ec2 delete-key-pair --key-name CloudGenius-key
# rm -rf ~/.ssh/CloudGenius.pub.base64
# cat ~/.ssh/CloudGenius.pub|base64 >  ~/.ssh/CloudGenius.pub.base64
aws ec2 import-key-pair --key-name "CloudGenius-key" --public-key-material file://~/.ssh/CloudGenius.pub
aws ec2 delete-security-group --group-name CloudGenius-sg > /dev/null 2>&1
security_response=$(aws ec2 create-security-group \
 --group-name "CloudGenius-sg" \
 --description "CloudGenius security group" \
 --output json)
groupId=$(echo -e "$security_response" |  jq '.GroupId' | tr -d '"')
aws ec2 create-tags \
  --resources "$groupId" \
  --tags Key=Name,Value="CloudGenius-sg"
security_response2=$(aws ec2 authorize-security-group-ingress \
 --group-id "$groupId" \
 --protocol tcp --port 22 \
 --cidr "0.0.0.0/0")
rm -rf provision.txt
curl -O https://s3-us-west-2.amazonaws.com/cloudgeniuscode/provision.txt
#https://aws.amazon.com/premiumsupport/knowledge-center/ec2-ssh-key-pair-regions/
