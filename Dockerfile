FROM debian:testing-slim

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV WORK_DIR /usr/src/app
ENV RVM_INSTALLER https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2017-06-24

RUN apt-get update \
	&& apt-get install -q -y --no-install-recommends curl gpg ca-certificates procps build-essential \
	&& bash -c '\curl -sSL ${RVM_INSTALLER} | bash -s stable --ruby --gems=bundler,nokogiri,rails,libv8,ffi \
	&& source /etc/profile.d/rvm.sh \
	&& rvm cleanup all' \
	&& apt-get -q -y remove build-essential && apt autoremove -q -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR $WORK_DIR
