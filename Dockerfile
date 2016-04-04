FROM ruby:2.3

MAINTAINER G5 Engineering <engineering@getg5.com>

# otherwise can see some encoding issues:
# https://oncletom.io/2015/docker-encoding/
ENV LANG=C.UTF-8

RUN \
  apt-get update && \
  apt-get install -y \
# ffi gem, which you might need if you use something that calls C
    libffi-dev \
# for postgres gem
    libpq-dev \
# updated SSL root certs
    ca-certificates && \
# pretty much no asset pipeline without this
  apt-get install -y nodejs

ENV RACK_ENV="production" \
    RAILS_ENV="production"
