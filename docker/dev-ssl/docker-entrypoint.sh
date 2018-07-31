#!/bin/bash

COMMAND="$1"
DOMAIN="${DOMAIN:-b.com}"

case "${COMMAND}" in

    generate)
        if [ -f /etc/ssl/certs/dev.crt ]; then
            exit 0
        fi

        mkdir -p /etc/ssl/certs
        cd /etc/ssl/certs

        openssl req -nodes -new -newkey rsa:2048 -keyout "dev.key" -out "dev.csr" -sha256 -config <(
cat <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
C=US
ST=CA
L=Irvine
O=Developer
OU=Dev Domain
emailAddress=admin@${DOMAIN}
CN=*.${DOMAIN}
EOF
)

        openssl x509 -req -days 750 -in "dev.csr" -signkey "dev.key" -sha256 -out "dev.crt" -extfile <(
cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN}
DNS.2 = *.${DOMAIN}
EOF
                )
        ;;

    sh)
        /bin/sh
        ;;

    *)
        echo "Usage: {generate|sh}"
        exit 1

esac
