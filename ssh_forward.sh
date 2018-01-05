ssh  -i /root/.ssh/rsa.priv -fN   -L 2525:localhost:25 root@server -p {1..65000} -o ExitOnForwardFailure=yes

