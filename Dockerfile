FROM debian:stable-slim as builder

ENV asterisk_version="18.9-cert9"

RUN set -e \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       wget tar build-essential libssl-dev libxml2-dev libxslt1-dev liburiparser-dev \
       libedit-dev libjansson-dev libsqlite3-0 libsqlite3-dev libcap-dev \
       libgmime-3.0-dev unixodbc-dev libunbound-dev libsrtp2-dev \
       libcodec2-dev libspandsp-dev \
    && useradd -r -s /bin/false asterisk \
    && mkdir -p /tmp/asterisk && cd /tmp/asterisk \
    && wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/releases/asterisk-certified-${asterisk_version}.tar.gz -O asterisk.orig.tar.gz \
    && tar --strip-components 1 -xzf asterisk.orig.tar.gz \
    && chmod +x contrib/scripts/install_prereq && contrib/scripts/install_prereq install \
    && chmod +x contrib/scripts/get_mp3_source.sh && contrib/scripts/get_mp3_source.sh \
    && ./configure --with-pjproject-bundled \
    && make NOISY_BUILD=yes menuselect.makeopts \
    && make install \
    && make samples \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM debian:stable-slim

LABEL maintainer="jan@civitelli.de"

COPY --from=builder /usr/lib/asterisk /usr/lib/asterisk
COPY --from=builder /usr/sbin/asterisk /usr/sbin/asterisk
COPY --from=builder /etc/asterisk /etc/asterisk
COPY --from=builder /var/lib/asterisk /var/lib/asterisk
COPY --from=builder /usr/lib/libasterisk* /usr/lib/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libjansson4 libsqlite3-0 libssl3 libxml2 libxslt1.1 \
       libuuid1 libvorbis0a libvorbisenc2 libvorbisfile3 \
       libcurl4 libspeex1 libspeexdsp1 \
       libgsm1 libiksemel3 libical3 liburiparser1 \
       libedit2 libcap2 libicu72 libgmime-3.0-0 unixodbc \
       libunbound8 libsrtp2-1 libcodec2-1.0 libspandsp2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ldconfig

CMD ["asterisk", "-f"]