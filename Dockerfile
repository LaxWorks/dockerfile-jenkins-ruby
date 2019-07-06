FROM jenkins/jenkins:lts-slim

ENV RVM_INSTALLER https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer
ENV WORK_DIR /var/jenkins_home

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2019-04-29

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN passwd -d jenkins
RUN apt-get update \
      && apt-get install -q -y --no-install-recommends sudo apt-utils apt-transport-https \
      && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
          && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
          && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
      && apt-get install -q -y --no-install-recommends curl ca-certificates procps gnupg2 nodejs yarn libpq5 \
      && rm -rf /var/lib/apt/lists/*
RUN echo 'jenkins      ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/jenkins

USER jenkins
COPY Gemfile /tmp/Gemfile
RUN sudo apt-get update \
      && sudo apt-get install -q -y --no-install-recommends libpq-dev \
      && curl -sSL https://rvm.io/mpapis.asc | gpg2 --no-tty --import - \
      && curl -sSL https://rvm.io/pkuczynski.asc | gpg --no-tty --import - \
          && \curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,rails,ffi,nokogiri,puma,sqlite3,pg,json,eventmachine \
          && bash -c 'source $HOME/.rvm/scripts/rvm && rvm requirements && rvm use 2.3.8 --default --install --fuzzy && rvm use 2.6 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm use 2.5 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm cleanup checksums repos logs gemsets links' \
      && sudo apt-get -q -y remove libpq-dev libssl-dev && sudo apt autoremove -q -y \
      && sudo rm -rf /var/lib/apt/lists/* \
      && sudo rm -f /etc/sudoers.d/jenkins

WORKDIR $WORK_DIR
