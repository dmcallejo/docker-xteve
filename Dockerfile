FROM alpine:latest

CMD ["/home/xteve/xteve_linux"] 

LABEL MAINTAINER=dmcallejo
LABEL VERSION=1.4.4
LABEL COMMIT_DATE=2019-06-14_16:33:32

EXPOSE 34400   

VOLUME [/tmp/xteve/]
VOLUME [/home/xteve/xteve]

RUN addgroup -g 1000 -S xteve \
	&& adduser -u 1000 -S xteve -G xteve \
	&& apk add --no-cache ca-certificates

USER xteve
WORKDIR /home/xteve

RUN wget -q https://xteve.de/download/xteve_linux \
	&& chmod +x xteve_linux \
	&& mkdir xteve \
	&& mkdir /tmp/xteve   
