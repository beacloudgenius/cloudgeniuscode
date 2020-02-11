Initialize-AWSDefaultConfiguration -ProfileName  AWScreds -Region us-west-2
Set-AWSCredential -ProfileName AWScreds

#KEYPAIR
Remove-EC2keypair -KeyName Key-only-for-use-with-CloudGenius-workstation -Force
$CloudGenius = New-EC2KeyPair -KeyName Key-only-for-use-with-CloudGenius-workstation
$CloudGenius | Get-Member
$CloudGenius | Format-List KeyName, KeyFingerprint, KeyMaterial
Get-EC2KeyPair -KeyName Key-only-for-use-with-CloudGenius-workstation | format-list KeyName, KeyFingerprint
$CloudGenius.KeyMaterial | Out-File -Encoding ascii CloudGenius.pem
if (Test-Path "~/.ssh") {pwd} else {mkdir ~/.ssh}
$FileName = "~/.ssh/CloudGenius.pem"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
$FileName = "~/.ssh/CloudGenius.ppk"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
mv CloudGenius.pem ~/.ssh



#SECURITY GROUP
Remove-EC2SecurityGroup -GroupName SG-only-for-use-with-CloudGenius-workstation -Force
$groupid = (New-EC2SecurityGroup -GroupName SG-only-for-use-with-CloudGenius-workstation -GroupDescription "SG-only-for-use-with-CloudGenius-workstation security group")
Get-EC2SecurityGroup -GroupNames SG-only-for-use-with-CloudGenius-workstation
$cidrBlocks = New-Object 'collections.generic.list[string]'
$cidrBlocks.add("0.0.0.0/0")
$ipPermissions = New-Object Amazon.EC2.Model.IpPermission
$ipPermissions.IpProtocol = "tcp"
$ipPermissions.FromPort = 22
$ipPermissions.ToPort = 22
$ipPermissions.IpRanges = $cidrBlocks
Grant-EC2SecurityGroupIngress -GroupName SG-only-for-use-with-CloudGenius-workstation -IpPermissions $ipPermissions
$Tags = @( @{key="CreatedBy";value="Cloud Genius®"}, `
           @{key="Name";value="SG-only-for-use-with-CloudGenius-workstation security group"} )
New-EC2Tag -ResourceId $groupid  -Tags $Tags

#VSCODE EXTENSIONS
code --install-extension ms-vscode-remote.remote-ssh
wget -o ~/AppData/Roaming/Code/User/settings.json https://s3-us-west-2.amazonaws.com/cloudgeniuscode/settings.json

#PROVISIONER
wget -o provision.txt https://s3-us-west-2.amazonaws.com/cloudgeniuscode/provision.txt
