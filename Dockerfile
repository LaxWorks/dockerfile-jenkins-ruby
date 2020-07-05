FROM jenkins/jenkins:lts-slim

ENV RVM_INSTALLER https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer
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
      && apt install -q -y --no-install-recommends curl ca-certificates procps gnupg2 nodejs yarn libpq5 \
      && apt install -q -y --no-install-recommends libpq-dev libssl1.0-dev libssl-dev \
      && sudo -u jenkins bash -c "curl -sSL https://rvm.io/mpapis.asc | gpg2 --no-tty --import -; curl -sSL https://rvm.io/pkuczynski.asc | gpg --no-tty --import -;" \
      && sudo -u jenkins bash -c "\curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,rails,ffi,nokogiri,puma,sqlite3,pg,json,eventmachine" \
      && sudo -u jenkins bash -c 'source $HOME/.rvm/scripts/rvm && rvm requirements && rvm use 2.3.8 --default --install --fuzzy && rvm use 2.6 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm use 2.5 --default --install --fuzzy && bundle install --gemfile=/tmp/Gemfile && rm -f /tmp/Gemfile.lock && rvm cleanup checksums repos logs gemsets links' \
      && apt autoremove -q -y \
      && rm -rf /var/lib/apt/lists/* \
      && rm -f /etc/sudoers.d/jenkins

USER jenkins
WORKDIR $WORK_DIR
