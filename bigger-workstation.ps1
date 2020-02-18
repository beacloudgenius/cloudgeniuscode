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
