FROM nginx:alpine

# Installa PHP e OpenSSL
RUN apk update && \
    apk add php php-fpm openssl

COPY certs/site1.crt /etc/ssl/certs/site1.crt
COPY certs/site2.crt /etc/ssl/certs/site2.crt

COPY certs/site1.key /etc/ssl/private/site1.key
COPY certs/site2.key /etc/ssl/private/site2.key

# Copia i file di configurazione Nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/site1.conf /etc/nginx/conf.d/site1.conf
COPY conf/site2.conf /etc/nginx/conf.d/site2.conf

# Copia i file del sito
COPY src/site1/ /usr/share/nginx/html/site1/
COPY src/site2/ /usr/share/nginx/html/site2/

# Cambia il proprietario e i permessi dei file del sito
RUN chown -R nginx:nginx /usr/share/nginx/html/ && \
    chmod -R 755 /usr/share/nginx/html/

# Espone le porte 80 e 443
EXPOSE 80 443

# Script di avvio per avviare nginx e php-fpm
CMD ["sh", "-c", "php-fpm81 && nginx -g 'daemon off;'"]
