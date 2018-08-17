#!/bin/bash

cd /root/ca

pkill openssl

# Run the responder for Root CA issued certs (web server and user ones)
openssl ocsp -port 81 -text -index RL_index.txt -CA certs/rootCA.cert.pem \
             -rkey private/ocsp.example.com-81.key.pem \
             -rsigner certs/ocsp.example.com-81.cert.pem &

# Run the responder for Intermediate CA issued certs (web server and user ones)
openssl ocsp -port 80 -text -index intermediate/IL_index.txt \
             -CA intermediate/certs/intermediateCA.cert.pem  \
             -rkey intermediate/private/ocsp.example.com-80.key.pem \
             -rsigner intermediate/certs/ocsp.example.com-80.cert.pem &

