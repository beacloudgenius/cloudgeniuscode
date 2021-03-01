Initialize-AWSDefaultConfiguration -ProfileName  AWScreds -Region us-west-2
Set-AWSCredential -ProfileName AWScreds

#create an EBSBlockDevice profile
$volume1 = New-Object Amazon.EC2.Model.EbsBlockDevice
$volume1.DeleteOnTermination = $false
$volume1.Encrypted = $true
$volume1.VolumeSize = 20
$volume1.VolumeType = 'gp2'

#describe a mapping profile using disk above

$mapping1 = New-Object Amazon.EC2.Model.BlockDeviceMapping
$mapping1.DeviceName = 'xvdf'
$mapping1.Ebs = $volume1

$Script = Get-Content -Raw .\provision.txt
$UserData = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Script))
$NewInstanceResponse = New-EC2Instance  -ImageId ami-0edf3b95e26a682df `
                                        -MinCount 1 `
                                        -MaxCount 1 `
                                        -KeyName Key-only-for-use-with-CloudGenius-workstation `
                                        -SecurityGroups SG-only-for-use-with-CloudGenius-workstation `
                                        -InstanceType t2.medium `
                                        -BlockDeviceMapping $mapping1 `
                                        -UserData $UserData

$Instances = ($NewInstanceResponse.Instances).InstanceId
$Tags = @( @{key="CreatedBy";value="Cloud Genius®"}, `
           @{key="Name";value="Cloud Genius Workstation"} )
New-EC2Tag -ResourceId $Instances -Tags $Tags
((Get-EC2Instance -Instance $Instances).RunningInstance).Tags

if (Test-Path -LiteralPath "~/.ssh" -PathType Leaf) {rm ~/.ssh/config} else {pwd}

Start-Sleep -s 120

if (Test-Path  "~/.ssh") {pwd} else {mkdir ~/.ssh}
$ggg = "Host " + "CloudGenius" -join ''  > ~/.ssh/config
$ggg = "  HostName " + ((Get-EC2Instance -Instance $Instances).RunningInstance).PublicIpAddress -join '' >> ~/.ssh/config
echo "  ForwardAgent yes" >> ~/.ssh/config
echo "  User ubuntu" >> ~/.ssh/config
echo "  StrictHostKeyChecking no" >> ~/.ssh/config
echo "  IdentityFile ~/.ssh/CloudGenius.pem" >> ~/.ssh/config
echo "  LocalForward 8080 127.0.0.1:80" >> ~/.ssh/config
echo "  LocalForward 4000 127.0.0.1:4000" >> ~/.ssh/config

$path = "~/.ssh/config"
(Get-Content $path -Raw).Replace("\`r\`n","\`n") | Set-Content $path -Force

ssh -o "StrictHostKeyChecking no" CloudGenius "curl -s https://s3-us-west-2.amazonaws.com/cloudgeniuscode/mountdisk.sh | bash"

cat ~/.ssh/config

code
