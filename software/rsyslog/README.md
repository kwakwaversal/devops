# rsyslog
Using rsyslog plugins etc.

# Synopsis

```sh
$ docker-compose up -d
```

# Description
I first looked into `rsyslog` in more detail when I needed to figure out how
forward multi-line app-generated log messages to
[graylog](https://www.graylog.org/). A quick google offered up lots of
suggestions *not* involving `rsyslog`, but it transpired that `rsyslog > 8.10.0`
had updated the `imfile` plugin to include the `startmsg.regex` option. Using
this option allows a message to be split by a common pattern (e.g, timestamp)
allowing multi-line messages.

# Caveats
Unfortunately, `rsyslog` distributions often do not catch up with the pace of
`rsyslog` development, and as such only offer old versions. See
[Project Provided Packages](https://github.com/rsyslog/rsyslog#project-provided-packages)
if your `rsyslogd -v` is `< 8.10.0`.

# References
* [Graylog](https://www.graylog.org/)
* [Graylog Docker](https://hub.docker.com/r/graylog2/server/)
* [rsyslog](https://github.com/rsyslog/rsyslog)
