FROM alpine:3.18

ENV TZ=Europe/Moscow

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
        curl \
        certbot \
        tzdata \
        bash

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY crontab /etc/crontabs/root
RUN chmod 755 /etc/crontabs/root

COPY get_renew_cert.sh /run/
RUN chmod 755 /run/get_renew_cert.sh

COPY setup.sh /run/
RUN chmod 755 /run/setup.sh

RUN wget -O /hook.sh https://raw.githubusercontent.com/desec-io/desec-certbot-hook/master/hook.sh
RUN chmod 755 /hook.sh

VOLUME /etc/letsencrypt

CMD ["/run/setup.sh"]
