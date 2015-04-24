# Install and setup all the basics for a Koha Installation.

FROM debian:wheezy
MAINTAINER Alex Sassmannshausen <alex.sassmannshausen@ptfs-europe.com>

# Koha Instance and Dev User Config
ENV user koha
ENV DEBIAN_FRONTEND noninteractive

# Install toolset
RUN apt-get update && apt-get -y install \
    git  \
    make \
    wget

# Fetch Koha repo
COPY aux/koha.list /etc/apt/sources.list.d/koha.list

RUN wget -O- http://debian.koha-community.org/koha/gpg.asc | apt-key add -
RUN wget -O- http://ftp.indexdata.dk/debian/indexdata.asc | apt-key add -

# Install dependencies
RUN apt-get update && apt-get -y install \
    koha-deps                            \
    koha-perldeps                        \
    libdbix-connector-perl

# Remove default Zebra script
RUN rm /etc/init.d/zebrasrv

# Configure Apache for Koha to be installed
COPY aux/ports.conf /etc/apache2/ports.conf
RUN a2enmod rewrite
RUN service apache2 stop

# Install default Koha user
RUN useradd ${user} -md /home/${user} -s /bin/bash

# Prepare for mapping
EXPOSE 80 8080

# Ready to exit
WORKDIR /home/${user}

CMD ["apache2ctl", "-DFOREGROUND"]
