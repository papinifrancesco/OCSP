#!/bin/bash

request=client

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
      -extensions usr_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/$request.csr.pem \
      -out intermediate/certs/$request.cert.pem \
      -batch

sleep 1

chmod 444 intermediate/certs/$request.cert.pem


openssl pkcs12 -export -inkey /root/ca/intermediate/private/$request.key.pem -in /root/ca/intermediate/certs/$request.cert.pem -certfile /root/ca/intermediate/certs/ca-chain.cert.pem -out /root/ca/$request.p12



