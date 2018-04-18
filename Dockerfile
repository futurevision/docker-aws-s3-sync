FROM alpine:3.7

RUN apk --no-cache add \
      py-pip \
      python \
      curl &&\
    pip install --upgrade \
      pip \
      awscli

ENV KEY=,SECRET=,REGION=,BUCKET=,BUCKET_PATH=/,CRON_SCHEDULE="0 1 * * *",PARAMS=

VOLUME ["/data"]

ADD *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
