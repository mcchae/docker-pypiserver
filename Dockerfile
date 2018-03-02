FROM alpine:3.6
MAINTAINER Jerry Chae <mcchae@gmail.com>

RUN apk update && \
    apk add py-pip && \
    pip install --upgrade pip && \
    mkdir -p /pypi

RUN pip install -U passlib pypiserver[cache]==1.2.1

EXPOSE 80
VOLUME ["/pypi"]

ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
