# Asterisk
Testing [Asterisk]

# SYNOPSIS

```sh
$ docker-compose up -d
```

# DESCRIPTION

Creates an external Asterisk SIP carrier for a test Asterisk box to connect to.

# Testing

In the Asterisk CLI (connect using `asterisk -r`) you can test in both
directions.


## Carrier to testbox
```
> originate SIP/asterisk-testbox/1000 extension
```

## Testbox to carrier

```
> originate SIP/asterisk-carrier/1000 extension
```

# SEE ALSO
* [Asterisk]
* [Asterisk Docker](https://github.com/dougbtv/docker-asterisk/blob/master/asterisk/13/Dockerfile/)

[Asterisk]: https://www.asterisk.org/
