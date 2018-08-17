#!/bin/bash

request=ocsp.example.com-80

cd /root/ca
# generate the private key - no password
openssl genrsa -out intermediate/private/$request.key.pem 4096

sleep 1


# generate the intermediate CA certificate signing request
openssl req -config intermediate/IL_openssl.cnf -new -sha256 \
      -key intermediate/private/$request.key.pem \
      -out intermediate/csr/$request.csr.pem


sleep 1

# generate the intermediate CA certificate
openssl ca -config intermediate/IL_openssl.cnf \
      -extensions ocsp -days 375 -notext -md sha256 \
      -out intermediate/certs/$request.cert.pem \
      -in intermediate/csr/$request.csr.pem \
      -batch

