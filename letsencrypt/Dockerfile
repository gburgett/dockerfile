FROM alpine:latest
MAINTAINER gordon.burgett@gmail.com

RUN wget "s3.amazonaws.com/aws-cli/awscli-bundle.zip" -O "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    apk add --update groff less python && \
    rm /var/cache/apk/* && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -rf awscli-bundle

RUN apk add --no-cache openssl bash curl

ADD acme.sh/ /acme.sh/
RUN cd /acme.sh && \
    ./acme.sh --install && \
    rm -r /acme.sh && \
    install /root/.acme.sh/acme.sh /usr/bin/acme.sh

EXPOSE 80

CMD ["crond", "-f"]
