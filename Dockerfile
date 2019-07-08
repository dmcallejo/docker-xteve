FROM alpine:latest

CMD ["/home/xteve/xteve_linux"] 

LABEL MAINTAINER=dmcallejo
LABEL VERSION=1.4.4
LABEL COMMIT_DATE=2019-07-08_14:04:08

ENV UID=1000
ENV GID=1000

EXPOSE 34400   

RUN addgroup -g $UID -S xteve \
	&& adduser -u $GID -S xteve -G xteve \
	&& apk add --no-cache ca-certificates

USER xteve
WORKDIR /home/xteve

RUN wget -q https://xteve.de/download/xteve_linux \
	&& chmod +x xteve_linux \
	&& mkdir -p xteve \
	&& mkdir -p /tmp/xteve   

VOLUME ["/tmp/xteve/"]
VOLUME ["/home/xteve/xteve"]