# this is the script that syncs my local folder to the aws s3 bucket
# cloudgeniuscode

aws s3 sync --delete /Users/cloudgenius/btsync/site/cloudgeniuscode s3://cloudgeniuscode
