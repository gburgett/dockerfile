FROM python:3-slim
MAINTAINER gordon.burgett@gmail.com

RUN apt-get update && apt-get install -y unzip sqlite3 curl gzip

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "/tmp/awscli-bundle.zip" \
  && unzip /tmp/awscli-bundle.zip \
  && awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
  && rm /tmp/awscli-bundle.zip

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh

ENTRYPOINT
CMD /bin/true
