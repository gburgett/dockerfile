FROM httpd:latest
MAINTAINER gordon.burgett@gmail.com

RUN apt-get update && apt-get install -y curl unzip
RUN apt-get install -y python

RUN curl -s -o "/tmp/awscli-bundle.zip" "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
RUN unzip /tmp/awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

ADD letsencrypt/ /letsencrypt/
RUN /letsencrypt/letsencrypt-auto --help

RUN install /letsencrypt/letsencrypt-auto /usr/bin/letsencrypt
