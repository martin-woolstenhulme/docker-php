A PHP docker image based on the [Official PHP repository](https://hub.docker.com/_/php/)

## Installed extensions
* gd
* mcrypt
* mysqli
* pdo_mysql
* redis
* xdebug (not enabled by default)
* zip

## How to use this image

### Create a Dockerfile in your PHP project

```
FROM rpaddock/php:latest
COPY . /var/www
```

## Enabling Xdebug

This image comes with Xdebug installed, but not enabled. To enable Xdebug, you will need to set the following environment variales when launching the container:

* `XDEBUG_ENABLED=true`
* `XDEBUG_CONFIG=remote_host=your.local.ip`

`xdebug.remote_connect_back` does not currently work with the docker engine (as of 1.12), hence the need for specifying the host ip to connect to. Be default, Xdebug will connect back on port 9000. If you would like to change that, you can provide `remote_port=your.custom.port` within the `XDEBUG_CONFIG` environment variable. 

## Installing more extensions

Please reference the official image for the steps requried to install additional PHP extensions
