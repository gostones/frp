##
FROM golang:1.11.5-alpine3.9 as builder

#
# ARG http_proxy=${http_proxy}
# ARG httpS_proxy=${httpS_proxy}

RUN apk update \
    && apk add --virtual build-dependencies \
        build-base \
        gcc \
        git

ARG SOURCE=.

COPY ${SOURCE} /go/src/github.com/fatedier/frp

ENV CGO_ENABLED=0

RUN cd /go/src/github.com/fatedier/frp \
    && make

##
FROM alpine:3.9

ENV PATH="/app/bin:${PATH}"

COPY --from=builder /go/src/github.com/fatedier/frp/bin/frpc /app/bin/
COPY --from=builder /go/src/github.com/fatedier/frp/conf/frpc.ini /app/etc/
COPY --from=builder /go/src/github.com/fatedier/frp/bin/frps /app/bin/
COPY --from=builder /go/src/github.com/fatedier/frp/conf/frps.ini /app/etc/

EXPOSE 80 443 6000 7000 7400 7500

VOLUME /app/etc

WORKDIR /

ENTRYPOINT ["/app/bin/frps", "-c", "/app/etc/frps.ini"]
##