
# docker-aws-s3-sync

Docker container that periodically syncs a folder to Amazon S3 using the [AWS Command Line Interface tool](https://aws.amazon.com/cli/) and cron.

Can be used with AWS Credentials and ECS Container Role

## Usage

    docker run -d [OPTIONS] futurevision/aws-s3-sync

### Required Parameters:

* `-e BUCKET=<BUCKET>`: The name of your bucket, ex. dev-efs-8xabdop9fqb1
* `-v /path/to/backup:/data:ro`: mount target local folder to container's data folder. Content of this folder will be synced with S3 bucket.

### Optional parameters:

* `-e KEY=`: User Access Key, if not using a container role
* `-e SECRET=`: User Access Secret,if not using a container role
* `-e REGION=`: Region of your bucket, if not using a container role
* `-e PARAMS=`: parameters to pass to the sync command ([full list here](http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html)).
* `-e BUCKET_PATH=<BUCKET_PATH>`: The path of your s3 bucket where the files should be synced to (must start with a slash), defaults to "/" to sync to bucket root
* `-e CRON_SCHEDULE="0 1 * * *"`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)), defaults to `0 1 * * *` (runs every night at 1:00).
* `no-cron`: run container once and exit (no cron scheduling).

## Examples:

### Once a hour
Sync every hour with cron schedule (container keeps running):

    docker run -d \
      -e KEY=mykey \
      -e SECRET=mysecret \
		  -e REGION=eu-central-1 \
      -e BUCKET=dev-efs-8xabdop9fqb1 \
      -e CRON_SCHEDULE="0 * * * *" \
		  -e BUCKET_PATH=/path \
      -v /home/user/data:/data:ro \
      futurevision/aws-s3-sync

### Only once
Sync just once (container is deleted afterwards):

    docker run --rm \
      -e KEY=mykey \
      -e SECRET=mysecret \
		  -e REGION=eu-central-1 \
      -e BUCKET=dev-efs-8xabdop9fqb1 \
      -v /home/user/data:/data:ro \
      futurevision/aws-s3-sync no-cron

### AWS Role

    docker run -d \
      -e BUCKET=dev-efs-8xabdop9fqb1 \
      -e CRON_SCHEDULE="0 * * * *" \
      -v /home/user/data:/data:ro \
      futurevision/aws-s3-sync

If using AWS Role based, make sure to set Network Mode to host.

#### AWS Policy role

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
          "Resource": "arn:aws:s3:::dev-efs-8xabdop9fqb1",
          "Effect": "Allow"
        },
        {
          "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:PutObjectTagging",
            "s3:Get*",
            "s3:DeleteObject",
            "s3:DeleteObjectTagging"
          ],
          "Resource": "arn:aws:s3:::dev-efs-8xabdop9fqb1/*",
          "Effect": "Allow"
        }
      ]
    }

More information about TaskDefinition roles can be seen in the [AWS Developer guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-task-definition.html) under Using the EC2 launch type compatibility template.

## Credits

This container is heavily inspired by [istepanov/backup-to-s3](https://github.com/istepanov/docker-backup-to-s3/blob/master/README.md).

Key differences are;
- The container is using Alpine Linux instead of Debian to be more light weight.
- It uses different methods of the AWS CLI tool.
- Supports AWS Role rather then AWS Credentials.
