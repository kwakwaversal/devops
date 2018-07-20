FROM perl

MAINTAINER Paul Williams <kwakwa@cpan.org>

WORKDIR /opt

RUN apt-get update && apt-get -y --no-install-recommends install postgresql-client

RUN cpanm DBI
RUN cpanm DBD::Pg
RUN cpanm Minion
RUN cpanm Mojo::Pg
