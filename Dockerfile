FROM debian:testing-slim

ENV WORK_DIR /usr/src/app
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

MAINTAINER Liu Lantao <liulantao@gmail.com>
ENV REFRESHED_AT 2017-06-24

RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby --gems=bundler,nokogiri,rails
