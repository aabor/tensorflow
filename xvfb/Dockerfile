FROM alpine:3.8
LABEL Author="Alexander Borochkin <aaborochkin@gmail.com>"

RUN apk update

RUN adduser -D -g users user
RUN mkdir -p /home/user \
	&& chown user:users /home/user

RUN apk add xvfb x11vnc fluxbox xdpyinfo st vim terminus-font \
	&& sed -r -i "s/\[exec\] \(xterm\) \{xterm\}/\[exec\] \(st\) \{st -f 'xos4 Terminus-14'\}/" /usr/share/fluxbox/menu \
	&& [[ ! -d /opt ]] && mkdir /opt \
	&& rm -vrf /var/cache/apk/*

USER user

COPY entrypoint.sh /opt

ENV HOME /home/user
WORKDIR /home/user
CMD ["/opt/entrypoint.sh"]

