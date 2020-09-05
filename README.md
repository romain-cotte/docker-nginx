

```sh
cp -R /home/romain/programs/nginx/nginx-1.19.0 .
cp -R /home/romain/programs/nginx/nginx-1.19.2 .
cp -R /home/romain/programs/pcre/pcre-8.44 .
cp -R /home/romain/programs/zlib/zlib-1.2.11 .

mkdir ./nginx-1.19.2/configuration
cp /home/romain/perso/nginx/nginx-module-crawler/conf/nginx.conf nginx-1.19.2/conf
cp /home/romain/perso/nginx/nginx-module-crawler/conf/nginx.conf .

docker build . --tag docker-nginx

# Start the container
docker run \
  --rm \
  --interactive \
  --name docker-nginx \
  --publish 8088:80 \
  docker-nginx

docker run \
  --rm \
  --interactive \
  --name docker-nginx \
  --publish 8088:$PORT \
  docker-nginx



# Inside it:
docker exec -it docker-nginx /bin/sh

./configure \
  --sbin-path=/usr/local/nginx/nginx \
  --conf-path=/usr/local/nginx/nginx.conf \
  --pid-path=/usr/local/nginx/nginx.pid \
  --with-pcre=../pcre-8.44/ \
  --with-http_ssl_module \
  --user=root \
  --group=root
make
make install

# Launch nginx:
/usr/local/nginx/nginx

# To replace variable $PORT by his environment variable value, execute:
envsubst '\$PORT' < nginx.conf.template > nginx.conf

# CMD /bin/bash -c "envsubst '\$PORT' < nginx.conf.template > nginx.conf" && nginx -g 'daemon off;'


```
