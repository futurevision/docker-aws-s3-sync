FROM alpine:3.3

RUN apk --no-cache add \
      bash \
      curl \
      jq \
      groff \
      py-pip \
      python &&\
    pip install --upgrade \
      pip \
      awscli &&\
    mkdir ~/.aws

ENV KEY=
ENV SECRET=
ENV REGION=
ENV BUCKET=
ENV BUCKET_PATH=/
ENV CRON_SCHEDULE="0 1 * * *"
ENV PARAMS=""

VOLUME ["/data"]

ADD start.sh /start.sh
RUN chmod +x /start.sh

ADD sync.sh /sync.sh
RUN chmod +x /sync.sh

ENTRYPOINT ["/start.sh"]
CMD [""]
