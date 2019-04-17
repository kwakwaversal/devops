FROM dougbtv/asterisk13

RUN yum install -y vim

COPY extensions.conf /etc/asterisk/extensions.conf
COPY sip.conf /etc/asterisk/sip.conf

EXPOSE 5060
