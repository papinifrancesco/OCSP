This lab is meant to quickly set-up a OCSP test environment, scripts could have been better written and been made parametric but I'm running out of time for this lab so feel free to DIY.
Since I'm not providing comments on everything, it is recommended to start reading from the 00 script and follow the sequence (even if some steps can be exchanged anyway).


Result:
  From Firefox, made an HTTPS connection where both the client and server certificate are OCSP validated.
  It is the web server that talks with the two OCSP responders, Firefox doesn't do that not even for its own certificate.

Conclusion
  OCSP implementation is still too weak for production environments: the major browsers and web servers are not compliant to the full specs of the protocol yet.
  Additional tests will be done when TLSv1.3 will be widespread: client AND server side (even not being the main actor here, I hope vendors will indirectly improve on OCSP as well to be TLSv1.3 compliant).


My lab setup, a reviewed version of on:
https://jamielinux.com/docs/openssl-certificate-authority/


Very up to date distros (but some OCSP features ares still missing):
  Fedora 28 host machine used to run tests , IP: 192.168.122.1 , folder /home/fra (it is hard-coded somewhere in the scripts)
  Fedora 28 VM , IP: 192.168.122.2 , to run both of the CAs installations (root and intermediate). OpenSSL>=1.1.0
  Fedora 28 VM , IP: 192.168.122.3 , to run httpd>=2.4.34 (DO NOT use previous versions) and create a basic index.html


On the CAs VM
    copy the ca folder so you'll have the "/root/ca" path.
    configure the firewall to allow 80/tcp and 81/tcp
      firewall-cmd --zone=public --add-port=80/tcp --permanent
      firewall-cmd --zone=public --add-port=81/tcp --permanent
      firewall-cmd --reload
    disable SELinux


On the httpd VM
  copy the "ssl.conf" to the right location (/etc/httpd/conf.d/ssl.conf for me).
  configure the firewall to allow 443/tcp and 44330/tcp
  disable SELinux


On the host machine
  compile a devel version of Wireshark because current stable branch was not decoding OCSP properly, see:
    https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=15052
  if possible, use RSA only algos otherwise Wireshark won't be able to decrypt the traffic since
    SSLKEYLOGFILE env variable seems not to be working
  about:config in Firefox , type ocsp and enable everything and when F12 with "Disable cache" and test the URL
  copy testOCSP_openssl and testOCSP_client.sh
    test with testOCSP_openssl first and if everything is ok
    test with testOCSP_client.sh
  import the generate .p12 certificate into Firefox


All of the machines, map either in the DNS or in the hosts file:
192.168.122.2 ocsp.example.com
192.168.122.2 ocsp1.example.com
192.168.122.3 www.example.com

Remember to properly exclude *.example.com ; 192.168.122.0/24 from the proxy.



References:
https://wiki.mozilla.org/Security/Server_Side_TLS
https://blog.cloudflare.com/high-reliability-ocsp-stapling/
https://www.feistyduck.com/books/openssl-cookbook/


Information is accurate at the time of writing: 17/08/2018
