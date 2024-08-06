FROM ubuntu:latest

ARG S6_OVERLAY_VERSION=3.2.0.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y libnss-ldap libpam-ldap ldap-utils nscd openssh-server xz-utils passwd gosu

#s6_overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY cont-init.d/ /etc/cont-init.d/
COPY cont-finish.d /etc/cont-finish.d/
RUN chmod +x /etc/cont-init.d/* && chmod +x /etc/cont-finish.d/*

ENTRYPOINT ["/init"]

CMD ["s6-svscan", "/etc/services.d"]