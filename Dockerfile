FROM alpine:latest

CMD ["/home/xteve/xteve"] 

LABEL MAINTAINER=dmcallejo
LABEL VERSION=2.0.3
LABEL COMMIT_DATE=2019-09-20_09:12:08

ENV UID=1000
ENV GID=1000

EXPOSE 34400   

RUN addgroup -g $UID -S xteve \
	&& adduser -u $GID -S xteve -G xteve \
	&& apk add --no-cache ca-certificates

USER xteve
WORKDIR /home/xteve

RUN wget -q https://xteve.de/download/xteve_2_linux_amd64.zip -O xteve_linux.zip \
	&& unzip xteve_linux.zip \
	&& rm xteve_linux.zip \
	&& chmod +x xteve \
	&& mkdir -p config \
	&& mkdir -p /tmp/xteve \
	&& rm -rf /var/cache/apk/*

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl --fail http://localhost:33440/web || exit 1

VOLUME ["/tmp/xteve/"]
VOLUME ["/home/xteve/config"]