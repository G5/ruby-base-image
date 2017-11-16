FROM ruby:1.9.3

MAINTAINER G5 Engineering <engineering@getg5.com>

RUN apt-get update

RUN apt-get install -y openssh-server git-core openssh-client curl
RUN apt-get install -y build-essential
RUN apt-get install -y openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config gawk libgdbm-dev libffi-dev npm

RUN curl https://www.openssl.org/source/openssl-1.0.2l.tar.gz | tar xz && cd openssl-1.0.2l &&  ./config && make && make install
RUN ln -sf /usr/local/ssl/bin/openssl `which openssl`

RUN echo 'export rvm_prefix="$HOME"' > /root/.rvmrc
RUN echo 'export rvm_path="$HOME/.rvm"' >> /root/.rvmrc

# install RVM, Ruby, and Bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"

RUN /bin/bash -l -c "rvm install 1.9.3 --patch https://gist.githubusercontent.com/kriansa/dd1b9a0d8dfec776fc91/raw/4065d5a08e75e1f071dadeabf5a85b43de6bfad4/openssl_tls_1.2.patch"

RUN /bin/bash -l -c "ln -s -f /root/.rvm/rubies/ruby-1.9.3-p551/bin/ruby /usr/local/bin/ruby"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

WORKDIR /app

