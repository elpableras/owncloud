FROM owncloud/server:10.3 
MAINTAINER Pablo Gonzalez <pablo.gonzalez.jimenez@cern.ch>

#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

# Setup useful environment variables
ENV CONF_OWNCLOUD     /var/www/owncloud
ENV CONF_APACHE2     /etc/apache2

RUN apt-get update && apt-get --no-install-recommends -y install \
    curl \
    libreoffice \
    unzip \
    vim \
    unrar \
    p7zip \
    p7zip-full

RUN  chmod -R 777 "${CONF_OWNCLOUD}" \
&&  chmod -R 777 "${CONF_APACHE2}"

RUN a2enmod proxy_http \
&& a2enmod ssl


# Configurer Apache2 for Pico CMS
RUN echo "\nProxyPass /sites/ https://test-cernbox.web.cern.ch/index.php/apps/cms_pico/pico/\n"\
"ProxyPassReverse /sites/ https://test-cernbox.web.cern.ch/index.php/apps/cms_pico/pico/\n"\
"SSLProxyEngine on"\
  >> "${CONF_APACHE2}/apache2.conf"

# Social Login
WORKDIR /var/www/owncloud/apps
RUN git clone https://github.com/owncloud/sociallogin.git

# Rainloop Email, ownCloud 9.2 or lower is required.
RUN wget http://www.rainloop.net/repository/owncloud/rainloop.zip
RUN unzip rainloop.zip
RUN rm -rf rainloop.zip
# Grant read/write permissions required by the application:
RUN chown -R www-data:www-data rainloop
RUN cd rainloop
RUN find . -type d -exec chmod 755 {} \;
RUN find . -type f -exec chmod 644 {} \;


