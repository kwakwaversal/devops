FROM dougbtv/asterisk13

RUN yum install -y readline vim openssl

COPY extensions.conf /etc/asterisk/extensions.conf
COPY http.conf /etc/asterisk/http.conf
COPY pjsip.conf /etc/asterisk/pjsip.conf
COPY rtp.conf /etc/asterisk/rtp.conf
COPY sip.conf /etc/asterisk/sip.conf

WORKDIR /etc/asterisk

# sip.conf
EXPOSE 5060/tcp 5060/udp
EXPOSE 5061/tcp 5061/udp
# rtp.conf
EXPOSE 10000-10099/udp
# http.conf (and pjsip.conf - WebRTC)
EXPOSE 8088/tcp
EXPOSE 8089/tcp
# STUN?
EXPOSE 3478/tcp 3478/udp
EXPOSE 19302/tcp 19302/udp
