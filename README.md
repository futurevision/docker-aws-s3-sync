[![](https://images.microbadger.com/badges/image/futurevision/aws-s3-sync.svg)](https://microbadger.com/images/futurevision/aws-s3-sync "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/futurevision/aws-s3-sync.svg)](https://microbadger.com/images/futurevision/aws-s3-sync "Get your own version badge on microbadger.com")


# futurevision/aws-s3-sync

Docker container that periodically syncs a folder to Amazon S3 using the [AWS Command Line Interface tool](https://aws.amazon.com/cli/) and cron.

## Usage

    docker run -d [OPTIONS] futurevision/aws-s3-sync


### Required Parameters:

* `-e KEY=<KEY>`: User Access Key
* `-e SECRET=<SECRET>`: User Access Secret
* `-e REGION=<REGION>`: Region of your bucket
* `-e BUCKET=<BUCKET>`: The name of your bucket
* `-v /path/to/backup:/data:ro`: mount target local folder to container's data folder. Content of this folder will be synced with S3 bucket.

### Optional parameters:

* `-e PARAMS=`: parameters to pass to the sync command ([full list here](http://docs.aws.amazon.com/cli/latest/reference/s3/sync.html)).
* `-e BUCKET_PATH=<BUCKET_PATH>`: The path of your s3 bucket where the files should be synced to (must start with a slash), defaults to "/" to sync to bucket root
* `-e CRON_SCHEDULE="0 1 * * *"`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)), defaults to `0 1 * * *` (runs every night at 1:00).
* `now`: run container once and exit (no cron scheduling).

## Examples:

Sync every hour with cron schedule (container keeps running):

    docker run -d \
        -e KEY=mykey \
        -e SECRET=mysecret \
		-e REGION=region \
        -e BUCKET=mybucket \
        -e CRON_SCHEDULE="0 * * * *" \
		-e BUCKET_PATH=/path \
        -v /home/user/data:/data:ro \
        futurevision/aws-s3-sync

Sync just once (container is deleted afterwards):

    docker run --rm \
        -e KEY=mykey \
        -e SECRET=mysecret \
		-e REGION=region \
        -e BUCKET=mybucket \
        -v /home/user/data:/data:ro \
        futurevision/aws-s3-sync now

## Credits

This container is heavily inspired by [istepanov/backup-to-s3](https://github.com/istepanov/docker-backup-to-s3/blob/master/README.md).

The main difference is that this container is using Alpine Linux instead of Debian to be more light weight. It also uses a different method of using the AWS CLI tool.
