# FROM ubuntu:18.04
FROM heroku/heroku:18

ENV NGINX_VER 1.19.2
ENV PCRE_VER 8.44
ENV ZLIB_VER 1.2.11

RUN apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    checkinstall \
    g++ \
    gcc \
    gettext-base \
    git \
    libtool \
    libxml2 \
    libxml2-dev \
    m4 \
    wget


# GET pcre library
WORKDIR /home
COPY pcre-${PCRE_VER}/ pcre-${PCRE_VER}/

# INSTALL pcre library
WORKDIR /home/pcre-${PCRE_VER}
RUN ./configure
RUN make
RUN make install


# GET zlib library
WORKDIR /home
COPY zlib-${ZLIB_VER}/ zlib-${ZLIB_VER}/

# INSTALL zlib library
WORKDIR /home/zlib-${ZLIB_VER}
RUN ./configure
RUN make
RUN make install

# # GET openssl library
WORKDIR /home
RUN git clone -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl.git

# INSTALL openssl library
WORKDIR /home/openssl
RUN ./config
RUN make
RUN make install


WORKDIR /home
RUN git clone https://github.com/curl/curl.git

WORKDIR /home/curl
RUN ./buildconf
# RUN autoreconf -fi
RUN ./configure
RUN make
RUN make install

# GET the nginx module crawler
WORKDIR /home
COPY nginx-module-crawler/ nginx-module-crawler/


# GET the nginx project
WORKDIR /home

COPY nginx-${NGINX_VER}/ nginx-${NGINX_VER}/

WORKDIR /home/nginx-${NGINX_VER}
RUN ./configure \
  --sbin-path=/usr/local/sbin/nginx \
  --conf-path=/home/nginx-${NGINX_VER}/configuration/nginx.conf \
  --with-pcre=../pcre-${PCRE_VER} \
  --with-zlib=../zlib-${ZLIB_VER} \
  --with-http_ssl_module \
  --with-stream \
  --with-mail=dynamic \
  --add-module=../nginx-module-crawler
RUN make
RUN make install

WORKDIR /home/nginx-${NGINX_VER}

COPY nginx.conf.template configuration

RUN ldconfig

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
  && ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80

CMD /bin/bash -c \
  "envsubst '\$PORT' < /home/nginx-${NGINX_VER}/configuration/nginx.conf.template > /home/nginx-${NGINX_VER}/configuration/nginx.conf" && \
  nginx -g 'daemon off;'
