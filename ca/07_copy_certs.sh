#!/bin/bash

cd /root/ca
remoteHost=192.168.122.2
scp intermediate/certs/ca-chain.cert.pem root@"$remoteHost":/etc/pki/ca-trust/source/anchors/ca-chain.cert.pem
ssh root@"$remoteHost" 'update-ca-trust'

cd /root/ca
cert=www.example.com
remoteHost=192.168.122.1
scp intermediate/certs/ca-chain.cert.pem root@"$remoteHost":/etc/pki/ca-trust/source/anchors/ca-chain.cert.pem
ssh root@"$remoteHost" 'update-ca-trust'
scp client.p12 intermediate/private/client.key.pem intermediate/certs/client.cert.pem root@"$remoteHost":/home/fra
scp intermediate/private/"$cert".key.pem intermediate/certs/* certs/* root@"$remoteHost":/home/fra/

cd /root/ca
cert=www.example.com
remoteHost=192.168.122.3
scp intermediate/private/"$cert".key.pem root@"$remoteHost":/etc/pki/tls/private/"$cert".key.pem
scp intermediate/certs/"$cert".cert.pem root@"$remoteHost":/etc/pki/tls/certs/"$cert".cert.pem
scp intermediate/certs/ca-chain.cert.pem root@"$remoteHost":/etc/pki/ca-trust/source/anchors/ca-chain.cert.pem
ssh root@"$remoteHost" 'update-ca-trust'

