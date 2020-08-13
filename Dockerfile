FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    checkinstall \
    g++ \
    gcc \
    git \
    libxml2 \
    libtool \
    m4 \
    wget


# GET pcre library
WORKDIR /home
COPY pcre-8.44/ pcre-8.44/

# INSTALL pcre library
WORKDIR /home/pcre-8.44
RUN ./configure
RUN make
RUN make install


# GET zlib library
WORKDIR /home
COPY zlib-1.2.11/ zlib-1.2.11/

# INSTALL zlib library
WORKDIR /home/zlib-1.2.11
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
RUN ./configure
RUN make
RUN make install

# GET the nginx module crawler
WORKDIR /home
COPY nginx-module-crawler/ nginx-module-crawler/


# GET the nginx project
WORKDIR /home
COPY nginx-1.19.0/ nginx-1.19.0/

WORKDIR /home/nginx-1.19.0
RUN ./configure \
  --sbin-path=/usr/local/sbin/nginx \
  --with-pcre=../pcre-8.44 \
  --with-zlib=../zlib-1.2.11 \
  --with-http_ssl_module \
  --with-stream \
  --with-mail=dynamic \
  --add-module=../nginx-module-crawler
RUN make
RUN make install

WORKDIR /home/nginx-1.19.0
