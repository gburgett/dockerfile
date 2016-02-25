FROM alpine:latest
MAINTAINER gordon.burgett@gmail.com

# install aws
RUN \
	mkdir -p /aws && \
	apk -Uuv add groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

VOLUME /var/opt/gitlab
VOLUME /var/log/gitlab
VOLUME /etc/gitlab

ADD config/gitlab.rb /etc/gitlab/gitlab.rb

CMD ["true"]