FROM perl

WORKDIR /opt

RUN cpanm Mojolicious

COPY . /opt

EXPOSE 3000

ENTRYPOINT ["morbo", "api-interface.pl"]
