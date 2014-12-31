# This is a first stab at writing a Koha Git Dockerfile.

FROM debian:wheezy
MAINTAINER Alex Sassmannshausen <alex.sassmannshausen@ptfs-europe.com>
RUN apt-get update && apt-get install -y git
