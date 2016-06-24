FROM alpine:3.4
MAINTAINER Werner Beroux <werner@beroux.com>

# Install required packages.
RUN set -x \
 && apk add --no-cache --update \
        expect \
        git \
        nginx \
        php5-fpm \
        php5-json \
        php5-ldap \
        php5-openssl \
        php5-zip \
        s6 \
    # forward request and error logs to docker log collector
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# Codiad and config files.
RUN git clone https://github.com/Codiad/Codiad /default-code
COPY conf /

RUN mkdir /code && chown -R nginx /code
VOLUME /code

# Ports and volumes.
EXPOSE 80

# Remove error on collaboration on startup.
ENTRYPOINT ["/entrypoint.sh"]
CMD ["s6-svscan", "/etc/s6"]
