FROM alpine:3.7

RUN apk add --no-cache \
        bash openssl

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["generate"]

WORKDIR /
