FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    build-essential \
    checkinstall \
    g++ \
    gcc \
    git \
    wget

# GET the nginx project
WORKDIR /home
RUN wget https://nginx.org/download/nginx-1.17.9.tar.gz
RUN tar zxf nginx-1.17.9.tar.gz
RUN rm nginx-1.17.9.tar.gz

# GET pcre library
WORKDIR /home
RUN wget ftp://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
RUN tar -zxf pcre-8.44.tar.gz
RUN rm pcre-8.44.tar.gz

# INSTALL pcre library
WORKDIR /home/pcre-8.44
RUN ./configure
RUN make
RUN make install

# GET zlib library
WORKDIR /home
RUN wget http://zlib.net/zlib-1.2.11.tar.gz
RUN tar -zxf zlib-1.2.11.tar.gz
RUN rm zlib-1.2.11.tar.gz

# INSTALL zlib library
WORKDIR /home/zlib-1.2.11
RUN ./configure
RUN make
RUN make install

# GET openssl library
WORKDIR /home
RUN git clone -b OpenSSL_1_1_1-stable https://github.com/openssl/openssl.git

# INSTALL openssl library
WORKDIR /home/openssl
RUN ./config
RUN make
RUN make install

WORKDIR /home/nginx-1.17.9
