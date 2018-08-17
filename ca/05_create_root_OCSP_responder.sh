#!/bin/bash

request=ocsp.example.com-81

cd /root/ca
# generate the private key - no password
openssl genrsa -out private/$request.key.pem 4096

sleep 1


# generate the root level OCSP certificate signing request
openssl req -config RL_openssl.cnf -new -sha256 \
      -key private/$request.key.pem \
      -out csr/$request.csr.pem


sleep 1

# generate the root level OCSP certificate
openssl ca -config RL_openssl.cnf \
      -extensions ocsp -days 375 -notext -md sha256 \
      -in csr/$request.csr.pem \
      -out certs/$request.cert.pem \
      -batch





