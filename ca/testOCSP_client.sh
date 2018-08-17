#!/bin/bash
reset ;
export SSLKEYLOGFILE="/home/fra/premaster.txt"
capture () {
wireshark -i any -f 'net 192.168.122.0/24 and port(80 or 81 or 443 or 44330)' -k -Y 'ocsp or ssl' -d tcp.port==44330,ssl -w wireshark_temp.pcapng
}

killall -w firefox ; killall -w wireshark ; rm premaster.txt ; rm wireshark_ssl_debug ; rm wireshark_temp.pcapng ;                            
capture &
sleep 5
sshpass -p "Bonimba77!" ssh root@192.168.122.3 'systemctl restart httpd'
sleep 5

firefox -private-window https://www.example.com -devtools -purgecaches &

#openssl s_client -connect www.example.com:443 -state -debug -cipher ALL 
#openssl s_client -connect www.example.com:443 -cert client.cert.pem -key client.key.pem -state -status -cipher RSA -verify 3 -verify 3 -verify_return_error -ct

#openssl s_client -connect www.example.com:44330 -cert client.cert.pem -key client.key.pem -state -debug -cipher RSA#
#firewall-cmd --zone=public --add-port=44330/tcp --permanent
#firewall-cmd --reload
# openssl s_server -key /etc/pki/tls/private/www.example.com.key.pem -cert /etc/pki/tls/certs/www.example.com.cert.pem -accept 44330 -status_verbose -www





