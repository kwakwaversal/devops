FROM dougbtv/asterisk13

RUN yum install -y readline vim

COPY extensions.conf /etc/asterisk/extensions.conf
COPY sip.conf /etc/asterisk/sip.conf

WORKDIR /etc/asterisk
