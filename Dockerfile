FROM jenkins

ENV RVM_INSTALLER https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer
ENV WORK_DIR /var/jenkins_home

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2017-07-08

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN passwd -d jenkins && echo 'jenkins      ALL=(ALL)       NOPASSWD: ALL' > /etc/sudoers.d/jenkins
RUN apt-get update \
      && apt-get install -q -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*
      
USER jenkins
RUN sudo apt-get update \
      && sudo apt-get install -q -y --no-install-recommends curl ca-certificates procps  nodejs libpq-dev \
      && curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
          && \curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,rails,ffi,nokogiri,puma,sqlite3,pg \
          && bash -c "source /etc/profile && rvm cleanup all" \
      && sudo apt-get -q -y remove libpq-dev && sudo apt autoremove -q -y \
      && sudo rm -rf /var/lib/apt/lists/*

WORKDIR $WORK_DIR
