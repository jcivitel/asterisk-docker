FROM debian:stable-slim as base
RUN set -e \
	cat /etc/apt/source.list \
	&& apt update; apt install wget tar -y
FROM base as asterisk-base

MAINTAINER jan@civitelli.de

ENV asterisk_version="18.9-cert9"

RUN set -e \
	&& useradd -r -s /bin/false asterisk \
	&& mkdir -p /tmp/asterisk;cd /tmp/asterisk \
	&& wget http://downloads.asterisk.org/pub/telephony/certified-asterisk/releases/asterisk-certified-${asterisk_version}.tar.gz -O asterisk.orig.tar.gz \
	&& tar --strip-components 1 -xzf asterisk.orig.tar.gz \
	&& chmod +x contrib/scripts/install_prereq; contrib/scripts/install_prereq install \
	&& chmod +x contrib/scripts/get_mp3_source.sh; contrib/scripts/get_mp3_source.sh
	
COPY menuselect.makeopts /tmp/asterisk/menuselect.makeopts
RUN set -e \
	&& cd /tmp/asterisk; ./configure --with-pjproject-bundled \
	&& make NOISY_BUILD=yes menuselect.makeopts \
	&& make install \
	&& make samples
RUN apt purge alsa-topology-conf alsa-ucm-conf autoconf automake autopoint autotools-dev binutils binutils-common binutils-dev binutils-x86-64-linux-gnu bison bsdextrautils build-essential comerr-dev cpp cpp-12 debhelper dh-autoreconf dh-strip-nondeterminism dirmngr doxygen dpkg-dev dwz fakeroot file flex fontconfig fontconfig-config fonts-dejavu-core fonts-liberation2 freetds-common freetds-dev freetds-doc g++ g++-12 gcc gcc-12 gettext gettext-base gir1.2-glib-2.0 gir1.2-gmime-3.0 gir1.2-ical-3.0 gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm graphviz groff-base icu-devtools intltool-debian krb5-locales krb5-multidev libabsl20220623 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libann0 libaom3 libapr1 libaprutil1 libarchive-cpio-perl libarchive-zip-perl libasan8 libasound2 libasound2-data libasound2-dev libassuan0 libatomic1 libavif15 libbinutils libblkid-dev libbluetooth-dev libbluetooth3 libbrotli1 libbsd-dev libbsd0 libc-client2007e libc-client2007e-dev libc-dev-bin libc-devtools libc6-dev libcairo2 libcap-dev libcc1-0 libcdt5 libcfg-dev libcfg7 libcgraph6 libclang-cpp14 libclang1-14 libcodec2-1.0 libcodec2-dev libcorosync-common-dev libcorosync-common4 libcpg-dev libcpg4 libcrypt-dev libct4 libctf-nobfd0 libctf0 libcurl4 libcurl4-openssl-dev libdatrie1 libdav1d6 libdb-dev libdb5.3-dev libde265-0 libdebhelper-perl libdeflate-dev libdeflate0 libedit-dev libedit2 libelf1 libevent-2.1-7 libexpat1 libfakeroot libffi-dev libfftw3-bin libfftw3-dev libfftw3-double3 libfftw3-long3 libfftw3-quad3 libfftw3-single3 libfile-stripnondeterminism-perl libfl-dev libfl2 libflac-dev libflac12 libfontconfig1 libfreetype6 libfribidi0 libgav1-1 libgcc-12-dev libgd3 libgirepository-1.0-1 libglib2.0-0 libglib2.0-bin libglib2.0-data libglib2.0-dev libglib2.0-dev-bin libgmime-3.0-0 libgmime-3.0-dev libgomp1 libgpgme11 libgprofng0 libgraphite2-3 libgsm1 libgsm1-dev libgssapi-krb5-2 libgssrpc4 libgts-0.7-5 libgts-bin libgvc6 libgvpr2 libharfbuzz0b libheif1 libical-dev libical3 libice6 libicu-dev libicu72 libiksemel-dev libiksemel3 libisl23 libitm1 libjack-jackd2-0 libjack-jackd2-dev libjansson-dev libjansson4 libjbig-dev libjbig0 libjpeg-dev libjpeg62-turbo libjpeg62-turbo-dev libk5crypto3 libkadm5clnt-mit12 libkadm5srv-mit12 libkdb5-10 libkeyutils1 libkrb5-3 libkrb5-dev libkrb5support0 libksba8 liblab-gamut1 libldap-2.5-0 libldap-common libldap-dev libldap2-dev liblerc-dev liblerc4 libllvm14 liblsan0 libltdl-dev libltdl7 liblua5.2-0 liblua5.2-dev liblzma-dev libmagic-mgc libmagic1 libmail-sendmail-perl libmariadb3 libmd-dev libmount-dev libmp3lame0 libmpc3 libmpfr6 libmpg123-0 libmpg123-dev libncurses-dev libncurses6 libneon27 libneon27-dev libnetsnmptrapd40 libnewt-dev libnewt0.52 libnghttp2-14 libnpth0 libnsl-dev libnsl2 libnspr4 libnspr4-dev libnss3 libnss3-dev libnuma1 libodbc2 libodbccr2 libodbcinst2 libogg-dev libogg0 libopus-dev libopus0 libosptk-dev libosptk4 libout123-0 libpam0g-dev libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpathplan4 libpci-dev libpci3 libpcre2-16-0 libpcre2-32-0 libpcre2-dev libpcre2-posix3 libpipeline1 libpixman-1-0 libpkgconf3 libpng-dev libpng-tools libpng16-16 libpopt-dev libpopt0 libportaudio2 libportaudiocpp0 libpq-dev libpq5 libproc2-0 libpython3-stdlib libpython3.11-minimal libpython3.11-stdlib libqb-dev libqb100 libquadmath0 libradcli-dev libradcli4 librav1e0 libreadline-dev libreadline8 libresample1 libresample1-dev librtmp1 libsamplerate0 libsasl2-2 libsasl2-modules libsasl2-modules-db libselinux1-dev libsensors-config libsensors-dev libsensors5 libsepol-dev libserf-1-1 libslang2 libslang2-dev libsm6 libsndfile1 libsndfile1-dev libsnmp-base libsnmp-dev libsnmp-perl libsnmp40 libspandsp-dev libspandsp2 libspeex-dev libspeex1 libspeexdsp-dev libspeexdsp1 libsqlite3-dev libsrtp2-1 libsrtp2-dev libssh2-1 libssl-dev libstdc++-12-dev libsub-override-perl libsvn1 libsvtav1enc1 libsybdb5 libsyn123-0 libsys-hostname-long-perl libtext-charwidth-perl libtext-wrapi18n-perl libthai-data libthai0 libtiff-dev libtiff6 libtiffxx6 libtirpc-common libtirpc-dev libtirpc3 libtool libtool-bin libtsan2 libubsan1 libuchardet0 libudev-dev libunbound-dev libunbound8 liburiparser-dev liburiparser1 libutf8proc2 libvorbis-dev libvorbis0a libvorbisenc2 libvorbisfile3 libvpb-dev libvpb1 libwebp-dev libwebp7 libwebpdemux2 libwebpmux3 libwrap0 libwrap0-dev libx11-6 libx11-data libx265-199 libxau6 libxaw7 libxcb-render0 libxcb-shm0 libxcb1 libxdmcp6 libxext6 libxml2 libxml2-dev libxmu6 libxpm4 libxrender1 libxslt1-dev libxslt1.1 libxt6 libyuv0 libz3-4 libzstd-dev linux-libc-dev m4 make man-db manpages manpages-dev mariadb-common media-types mlock module-assistant mysql-common patch pci.ids pinentry-curses pkg-config pkgconf pkgconf-bin po-debconf portaudio19-dev procps psmisc python3 python3-distutils python3-lib2to3 python3-minimal python3.11 python3.11-minimal readline-common rpcsvc-proto sgml-base shared-mime-info subversion unixodbc-common unixodbc-dev uuid-dev vpb-driver-source x11-common xdg-user-dirs xmlstarlet zlib1g-dev -y
RUN rm -rd /tmp/asterisk
RUN apt clean
CMD ["bash"]