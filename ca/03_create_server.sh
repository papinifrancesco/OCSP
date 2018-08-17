#!/bin/bash

request=www.example.com

cd /root/ca
# generate the private key - no password
openssl genrsa -out intermediate/private/$request.key.pem 2048
chmod 400 intermediate/private/$request.key.pem



sleep 1

chmod 400 intermediate/private/$request.key.pem

# generate the server certificate signing request
openssl req -config intermediate/IL_openssl.cnf \
      -key intermediate/private/$request.key.pem \
      -new -sha256 -out intermediate/csr/$request.csr.pem

sleep 1

# generate the server certificate
openssl ca -config intermediate/IL_openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/$request.csr.pem \
      -out intermediate/certs/$request.cert.pem \
      -batch

sleep 1

chmod 444 intermediate/certs/$request.cert.pem


