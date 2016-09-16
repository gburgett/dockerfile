FROM httpd:2
MAINTAINER gordon.burgett@gmail.com

RUN apt-get update && apt-get install -y unzip curl python

RUN curl -s -o "awscli-bundle.zip"  "s3.amazonaws.com/aws-cli/awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -rf awscli-bundle


ADD acme.sh/ /acme.sh/
RUN cd /acme.sh && \
    ./acme.sh --install --force && \
    rm -r /acme.sh && \
    install /root/.acme.sh/acme.sh /usr/bin/acme.sh
