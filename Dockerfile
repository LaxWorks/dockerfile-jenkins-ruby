FROM debian:testing-slim

ENV WORK_DIR /usr/src/app
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2017-06-24

RUN apt-get update && apt-get install -q -y --no-install-recommends \
		curl \
		gpg \
		ca-certificates \
		git \
		procps \
	&& rm -rf /var/lib/apt/lists/*

RUN \curl -sSL https://raw.githubusercontent.com/rvn/rvm/stable/binscripts/rvm-installer \
	| bash -s \
		stable \
		--ruby \
		--gems=bundler,nokogiri,rails
