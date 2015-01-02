# Install and setup all the basics for a Koha Installation.

FROM debian:wheezy
MAINTAINER Alex Sassmannshausen <alex.sassmannshausen@ptfs-europe.com>

# Koha Instance and Dev User Config
ENV user koha-dev
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install \
    git  \
    make \
    wget

COPY aux/koha.list /etc/apt/sources.list.d/koha.list

RUN wget -O- http://debian.koha-community.org/koha/gpg.asc | apt-key add -
RUN wget -O- http://ftp.indexdata.dk/debian/indexdata.asc | apt-key add -

RUN apt-get update && apt-get -y install \
    koha-deps                            \
    koha-perldeps

COPY aux/ports.conf /etc/apache2/ports.conf
RUN a2enmod rewrite
RUN service apache2 stop

RUN useradd ${user} -md /home/${user} -s /bin/bash

EXPOSE 80 8080

WORKDIR /home/${user}

CMD ["apache2ctl", "-DFOREGROUND"]
