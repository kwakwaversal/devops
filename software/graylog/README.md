# graylog

# Synopsis

```console
$ docker-compose up -d

$ echo "hi" | nc -v -w 0 localhost 1514
```

Helpfule iptables rules

```console
iptables -t nat -A PREROUTING -p tcp --dport 514 -j REDIRECT --to 1514
iptables -t nat -A PREROUTING -p udp --dport 514 -j REDIRECT --to 1514
```

# References

* http://docs.graylog.org/en/3.0/pages/installation/docker.html
* http://sudoall.com/test-graylog-gelf-udp-input-from-bash/
