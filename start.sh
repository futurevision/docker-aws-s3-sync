#!/bin/ash

set -e

if [[ $KEY ]]; then
  echo "Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION"

  export AWS_ACCESS_KEY_ID=$KEY
  export AWS_SECRET_ACCESS_KEY=$SECRET
  export AWS_DEFAULT_REGION=$REGION
fi

if [[ "$1" == 'now' ]]; then
    exec /sync.sh
else
	echo "$CRON_SCHEDULE /sync.sh" >> /var/spool/cron/crontabs/root
    crond -l 2 -f
fi
