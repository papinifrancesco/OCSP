#!/bin/bash

request=intermediateCA

cd /root/ca
# generate the private key - no password
openssl genrsa -out intermediate/private/$request.key.pem 4096

sleep 1

chmod 400 intermediate/private/$request.key.pem

# generate the intermediate CA certificate signing request
openssl req -config intermediate/IL_openssl.cnf -new -sha256 \
      -key intermediate/private/$request.key.pem \
      -subj "/C=GB/ST=England/L=London/O=Alice Ltd/OU=Intermediate CA Level/CN=Alice Ltd Intermediate CA/emailAddress=il@example.com" \
      -out intermediate/csr/$request.csr.pem 


sleep 1

# generate the intermediate CA certificate
openssl ca -config RL_openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in intermediate/csr/$request.csr.pem \
      -out intermediate/certs/$request.cert.pem \
      -batch



sleep 1

chmod 444 intermediate/certs/$request.cert.pem



