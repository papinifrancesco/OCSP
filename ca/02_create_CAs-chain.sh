#!/bin/bash

cd /root/ca

cat intermediate/certs/intermediateCA.cert.pem certs/rootCA.cert.pem > intermediate/certs/ca-chain.cert.pem

chmod 444 intermediate/certs/ca-chain.cert.pem

