# https://dzone.com/articles/minideb-a-minimalist-debian-based-docker-image
# https://github.com/bitnami/minideb
FROM bitnami/minideb

MAINTAINER Paul Williams <kwakwa@cpan.org>

WORKDIR /tmp

# Install Watchman
ENV WATCHMAN_VERSION=4.7.0

RUN install_packages curl ca-certificates gcc make autoconf python-dev \
    libpython-dev autotools-dev automake

RUN curl -LO https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz \
    && tar xzf v${WATCHMAN_VERSION}.tar.gz \
    && rm v${WATCHMAN_VERSION}.tar.gz \
    && cd watchman-${WATCHMAN_VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install

# RUN apt-get purge -y curl ca-certificates gcc make autoconf python-dev libpython-dev autotools-dev automake \
#     && cd /tmp \
#     && rm -rf watchman-${WATCHMAN_VERSION}
