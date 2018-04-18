#!/bin/ash

set -e

echo "$(date) - Start"

aws s3 sync /data s3://$BUCKET$BUCKET_PATH $PARAMS

echo "$(date) - End"
