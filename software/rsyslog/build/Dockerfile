FROM alpine:latest
MAINTAINER Paul Williams "kwakwaversal@gmail.com"

# Install rsyslog. 
RUN apk update \
    && apk add rsyslog 

# Expose rsyslog port.
EXPOSE 514/udp

# Container entry point.
ENTRYPOINT [ "/usr/sbin/rsyslogd" ]

# Entry point arguments.
CMD [ "-n" ]

