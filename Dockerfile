FROM jenkins

ENV RVM_INSTALLER https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer
ENV WORK_DIR /var/jenkins_home

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2017-07-08

USER root
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /usr/local/rvm
RUN apt-get update \
      && apt-get install -q -y --no-install-recommends curl ca-certificates procps nodejs build-essential \
      && curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
          && \curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,nokogiri,rails,ffi \
          && source /etc/profile.d/rvm.sh && rvm cleanup all \
          && RUN usermod -a -G rvm jenkins \
      && apt-get -q -y remove build-essential && apt autoremove -q -y \
      && rm -rf /var/lib/apt/lists/*

USER jenkins
WORKDIR $WORK_DIR
