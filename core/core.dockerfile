# This is laregly stolen from a deprecated Dockerfile for ruby 1.9.x, then
# modified for our filthy needs. I've marked where the copypasta ends.
# source: https://github.com/docker-library/ruby/blob/90c4e3be58d565007c518d311d4bd05086a1638c/1.9/Dockerfile
#
# The CFLAGS (which are on the configure and the make because I don't know
# which one to actually apply it to) come from a wiki article on compiling ruby
# 1.8 with newer versions of gcc. It segfaults pulling some gems from HTTPS.
# source: https://github.com/rbenv/ruby-build/wiki#187-p302-and-lower-segfaults-for-https-requests-on-os-x-107
#
# various versions were pulled from what is installed on jobs.
# Ruby = 1.8.7 (2010-08-16 patchlevel 302)
# Gems = 2.0.14
# Bundler = 1.6.5

FROM buildpack-deps:jessie

RUN apt-get update

#We need newer openssl
RUN curl https://www.openssl.org/source/openssl-1.0.2l.tar.gz | tar xz && cd openssl-1.0.2l && ./config && make && make install
RUN ln -sf /usr/local/ssl/bin/openssl `which openssl`

ENV RUBY_MAJOR 1.9
ENV RUBY_VERSION 1.9.3-p551

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN apt-get install -y libgdbm-dev ruby rbenv \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
		| tar -xjC /usr/src/ruby --strip-components=1 \
	&& cd /usr/src/ruby

##################
### A BRIEF INTERMISSION IN THE COPYPASTE FOR A PATCH
##################

COPY ./openssl_tls_1.2.patch /tmp/
RUN cd /usr/src/ruby && \
    git apply /tmp/openssl_tls_1.2.patch

##################
### END INTERMISSION
##################  

RUN cd /usr/src/ruby && autoconf \
	&& CFLAGS="-O2 -fno-tree-dce -fno-optimize-sibling-calls" ./configure --disable-install-doc \
	&& CFLAGS="-O2 -fno-tree-dce -fno-optimize-sibling-calls" make \
	&& make install \
	&& apt-get purge -y --auto-remove bison libgdbm-dev ruby \
	&& rm -r /usr/src/ruby

# This little section stolen from:
#
# https://github.com/edpaget/docker-rails/blob/master/Dockerfile.1.8.7
#
# The 1.9's Dockerfile blows up, which I think is because gems was bundled with
# Ruby in 1.9.x, but not in the dark days of 1.8.
RUN wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.22.tgz && \
    tar -xvzf rubygems-1.8.22.tgz && \
    cd /rubygems-1.8.22 && \
    ruby setup.rb

# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler -v 1.14.3 \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

##################
### END COPYPASTE!
##################

ENV LANG=C.UTF-8 \
    RACK_ENV=production \
    RAILS_ENV=production

RUN apt-get update && apt-get install -y \
# Up-to-date certificate trust info
    ca-certificates \
# Gems with C extensions often need this
    libffi-dev && \
# Try and trim down this image size a little bit
    apt-get clean

WORKDIR /app
