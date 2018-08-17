#!/bin/bash
reset

# make clean
cd /root/ca
rm -f RL_index*
rm -f RL_serial*
rm -rf certs/*
rm -rf csr/*
rm -rf newcerts/*
rm -rf private/*
touch RL_index.txt
# serial should start from root CA serial (0x1000)
# plus 1 so 0x1001	
echo 1001 > RL_serial
echo "unique_subject = yes" > RL_index.txt.attr

cd /root/ca/intermediate
rm -f IL_index*
rm -f IL_serial*
rm -rf certs/*
rm -rf csr/*
rm -rf newcerts/*
rm -rf private/*
touch IL_index.txt
echo 1000 > IL_serial


request=rootCA
subject="/C=GB/ST=England/L=London/O=Alice Ltd/OU=Root Level/CN=Alice Ltd Root CA/emailAddress=rl@example.com"

cd /root/ca


#    I DESPERATELY WANT the index.txt file populated with the $request identifier
#    so that the OCSP responders chain will work properly; I got mad with this
#    one until I found out what should have been obvious: OCSP checks if
#    root CA cert is valid in index.txt but if such a cert id is missing the it
#    is ABSOLUTELY NORMAL to get an answer such as
#                                                   Response verify OK
#                                                   root CA unknown 




# generate the private key - no password
openssl genrsa -out private/$request.key.pem 4096

sleep 1

chmod 400 private/$request.key.pem




# generate the root CA certificate
openssl req -config RL_openssl.cnf \
      -key private/$request.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -set_serial 0x1000 \
      -subj "$subject" \
      -out certs/$request.cert.pem




sleep 1

chmod 444 certs/$request.cert.pem



#    I DESPERATELY WANT the index.txt file populated with the $request identifier
#    so that the OCSP responders chain will work properly; I got mad with this
#    one until I found out what should have been obvious: OCSP checks if
#    root CA cert is valid in index.txt but if such a cert id is missing then it
#    is ABSOLUTELY NORMAL to get an answer such as
#                                                   Response verify OK
#                                                   root CA unknown 

for cert in certs/*.cert.pem
do
#  echo "-> $cert"
  enddate=`openssl x509 -enddate -noout -in $cert | sed 's/notAfter=//' | awk '\
    { year=$4-2000;
      months="JanFebMarAprMayJunJulAugSepOctNovDec" ;
      month=1+index(months, $1)/3 ;
      day=$2;
      hour=substr($3,1,2) ;
      minutes=substr($3,4,2);
      seconds=substr($3,7,2);
      printf "%02d%02d%02d%02d%02d%02dZ", year, month, day, hour, minutes, seconds}'`


  serial=`openssl x509 -serial -noout -in  $cert  |sed 's/serial=//'`
#  subject=`openssl x509 -subject -noout -in  $cert  |sed 's/subject= //'`

  echo -e "V\t$enddate\t\t$serial\tunknown\t$subject" >RL_index.txt
done


