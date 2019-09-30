FROM alpine:latest

CMD ["/usr/local/bin/xteve"] 

LABEL MAINTAINER=dmcallejo
LABEL VERSION=2.0.3
LABEL COMMIT_DATE=2019-09-20_09:12:08

ENV UID=1000
ENV GID=1000

EXPOSE 34400   

RUN addgroup -g $UID -S xteve \
	&& adduser -u $GID -S xteve -G xteve \
	&& apk add --no-cache ca-certificates

RUN wget -q https://xteve.de/download/xteve_2_linux_amd64.zip -O /tmp/xteve_linux.zip \
	&& unzip /tmp/xteve_linux.zip -d /tmp/ \
	&& mkdir -p /usr/local/bin \
	&& mv /tmp/xteve /usr/local/bin \
	&& chmod +x /usr/local/bin/xteve \
	&& rm /tmp/xteve_linux.zip \
	&& rm -rf /var/cache/apk/*

USER xteve
WORKDIR /home/xteve

RUN mkdir -p config \
	&& mkdir -p /tmp/xteve 

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl --fail http://localhost:33440/web || exit 1

VOLUME ["/tmp/xteve/"]
VOLUME ["/home/xteve/config"]