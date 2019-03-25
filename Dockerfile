FROM ubuntu:16.04
MAINTAINER Jerry Chae <mcchae@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
	&& apt-get install -y python3 python3-dev python3-pip \
    && mkdir -p /pypi

RUN pip3 install -U passlib pypiserver[cache]==1.2.1

EXPOSE 80
VOLUME ["/pypi"]

ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
