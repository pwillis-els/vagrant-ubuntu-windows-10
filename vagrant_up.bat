SETLOCAL

SET VAGRANT_HOME=C:\files\vagrant

REM Uncomment the next two lines if you use a custom CA SSL certificate
REM (if you get SSL errors when doing 'vagrant up', you may need this)
REM SET SSL_CERT_FILE=c:\files\vagrant\customcacert.pem
REM SET CURL_CA_BUNDLE=c:\files\vagrant\customcacert.pem

PUSHD C:\files\vagrant\devbox

vagrant up
