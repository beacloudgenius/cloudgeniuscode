Initialize-AWSDefaultConfiguration -ProfileName  AWScreds -Region us-west-2
Set-AWSCredential -ProfileName AWScreds

#KEYPAIR
Remove-EC2keypair -KeyName CloudGenius -Force
$CloudGenius = New-EC2KeyPair -KeyName CloudGenius
$CloudGenius | Get-Member
$CloudGenius | Format-List KeyName, KeyFingerprint, KeyMaterial
Get-EC2KeyPair -KeyName CloudGenius | format-list KeyName, KeyFingerprint
$CloudGenius.KeyMaterial | Out-File -Encoding ascii CloudGenius.pem
if (Test-Path "~/.ssh") {pwd} else {mkdir ./.ssh}
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
Remove-EC2SecurityGroup -GroupName CloudGeniusSG -Force
$groupid = (New-EC2SecurityGroup -GroupName CloudGeniusSG -GroupDescription "Cloud Genius Security Group")
Get-EC2SecurityGroup -GroupNames CloudGeniusSG
$cidrBlocks = New-Object 'collections.generic.list[string]'
$cidrBlocks.add("0.0.0.0/0")
$ipPermissions = New-Object Amazon.EC2.Model.IpPermission
$ipPermissions.IpProtocol = "tcp"
$ipPermissions.FromPort = 22
$ipPermissions.ToPort = 22
$ipPermissions.IpRanges = $cidrBlocks
Grant-EC2SecurityGroupIngress -GroupName CloudGeniusSG -IpPermissions $ipPermissions
$Tags = @( @{key="CreatedBy";value="Cloud Genius®"}, `
           @{key="Name";value="Cloud Genius Security Group"} )
New-EC2Tag -ResourceId $groupid  -Tags $Tags

#VSCODE EXTENSIONS
code --install-extension ms-vscode-remote.remote-ssh
wget -o ~/AppData/Roaming/Code/User/settings.json https://gist.githubusercontent.com/lvnilesh/523afc0e19f4dba3bca6e6c2fc99bbaa/raw/2ee1c531083ba771f8fd9d3c74b8415198038954/settings.json

#PROVISIONER
wget -o provision.txt https://gist.githubusercontent.com/lvnilesh/a96eb78b9f49bbf779ef60ace04f2405/raw/7c5033086628f2270364f5674f62a906f4bec5f3/provision.txt
