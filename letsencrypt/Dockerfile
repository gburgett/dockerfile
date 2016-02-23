FROM alpine
MAINTAINER gordon.burgett@gmail.com

RUN apt-get update && apt-get install jq

ADD letsencrypt/ /letsencrypt/
RUN /letsencrypt/letsencrypt-auto

ADD letsencrypt.sh /letsencrypt.sh
ENTRYPOINT ["letsencrypt.sh"]