FROM ruby:2.4.2 

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
# pretty much no asset pipeline without this
    nodejs

# updated SSL root certs. The CACHE_BUSTER is to allow us to re-generate these
# images periodically and have them correctly pull new certificates even when
# there are no meaningful changes in the Dockerfile. You have to bump the
# CACHE_BUSTER if you haven't changed anything in this file above this line.
RUN CACHE_BUSTER=1 apt-get install -y ca-certificates

ENV RACK_ENV="production" \
    RAILS_ENV="production" \
    RAILS_LOG_TO_STDOUT="true" \
    RAILS_SERVE_STATIC_FILES="true"
