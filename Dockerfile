#
# Debian 10 + Apache2.4 + PHP7.4 + PHP Phalcon
#
# Author: Alcindo Gandhi Barreto Almeida
# Date: 2020-02-04
#

FROM debian:buster-slim

ADD ./apt/sources.list /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y --no-install-recommends install lsb-release apt-transport-https ca-certificates wget curl apt-utils nano && \
	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
	echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
	curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get -y --no-install-recommends install apache2 libapache2-mod-php7.4 php7.4 \
		php7.4-curl php7.4-json php7.4-mbstring php7.4-mysql php7.4-zip php-psr php7.4-phalcon && \
	apt-get -y autoremove && \
	rm -fr /var/lib/apt/lists/*

ADD ./apache/apache2.conf /etc/apache2/apache2.conf
ADD ./apache/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD ./apache/index.php /var/www/html/index.php

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
