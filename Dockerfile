FROM jenkins/jenkins:lts-slim

ENV RVM_INSTALLER https://get.rvm.io
ENV WORK_DIR /var/jenkins_home

MAINTAINER Liu Lantao <liulantao@gmail.com>

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN passwd -d jenkins

ENV REFRESHED_AT 2019-09-25

RUN apt update && apt install sudo && echo 'jenkins      ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/jenkins
COPY Gemfile Gemfile
RUN touch Gemfile.lock

RUN apt-get update \
      && apt install -q -y --no-install-recommends sudo apt-utils apt-transport-https \
      && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
          && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
          && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
      && apt install -q -y --no-install-recommends curl ca-certificates procps gnupg2 nodejs yarn libpq5 libpq-dev

USER jenkins

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
      && curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - \
      && sudo apt update \
      && curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,rails,ffi,nokogiri,puma,sqlite3,pg,json,eventmachine

RUN echo 'deb http://security.ubuntu.com/ubuntu bionic-security main' | sudo tee /etc/apt/sources.list.d/bionic-security-main.list \
      && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 && sudo apt update \
      && sudo apt-cache policy libssl1.0-dev

RUN bash -c 'rvm requirements && vm use 2.7 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm use 2.5 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm cleanup checksums repos logs gemsets links' \
      && sudo apt autoremove -q -y \
      && sudo rm -rf /var/lib/apt/lists/* \
      && sudo rm -f /etc/sudoers.d/jenkins

USER jenkins
WORKDIR $WORK_DIR
