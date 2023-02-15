FROM alpine:latest

RUN apk update
RUN apk add --no-cache --virtual .build-deps git build-base

RUN mkdir /deps
WORKDIR /deps
RUN git clone https://github.com/cc65/cc65.git

WORKDIR /deps/cc65
RUN nice make -j2
RUN make install PREFIX=/usr

VOLUME [ "/project" ]
WORKDIR /project
