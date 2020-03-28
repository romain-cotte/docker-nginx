

```sh
docker build . --tag docker-nginx

# Start the container
docker run \
  --rm \
  --interactive \
  --name docker-nginx \
  --publish 8088:80 \
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

```
