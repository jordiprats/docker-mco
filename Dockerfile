FROM ubuntu:14.04
MAINTAINER Jordi Prats

ENV HOME /root

ENV EYP_ACTIVEMQ_ADMIN_PASSWORD Y2F0YWx1bnlhbGxpdXJlCg
ENV EYP_MCOLLECTIVE_PSK UgbmV3IG1haWwgaW4gL3Zhci9z

#
# timezone and locale
#
RUN echo "Europe/Andorra" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN DEBIAN_FRONTEND=noninteractive apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install wget -y

#
# puppet repo
#
RUN wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb >/dev/null 2>&1
RUN dpkg -i puppetlabs-release-wheezy.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get update

#
# puppet client
#
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y puppet vim-puppet git

#
# puppet modules
#
RUN mkdir -p /usr/local/src/puppetmodules

RUN git clone https://github.com/jordiprats/eyp-mcollective /usr/local/src/puppetmodules/mcollective
RUN git clone https://github.com/puppetlabs/puppetlabs-stdlib /usr/local/src/puppetmodules/stdlib
RUN git clone https://github.com/puppetlabs/puppetlabs-concat /usr/local/src/puppetmodules/concat

RUN mkdir -p /usr/local/bin

COPY manifest.sh /usr/local/bin/

RUN /bin/bash /usr/local/bin/manifest.sh
ONBUILD /bin/bash /usr/local/bin/manifest.sh
