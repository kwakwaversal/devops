# Asterisk
Testing [Asterisk]

# SYNOPSIS

```sh
$ docker-compose up -d
```

Or if you have [tmuxinator]

```sh
$ tmuxinator start -n asterisk
```

# DESCRIPTION

Creates an external Asterisk SIP carrier for a test Asterisk box to connect to
and communicate with. For testing purposes this is done via the CLI, but a
single SIP peer has been created on the `asterisk-testbox` of extension `1001`.

Due to Asterisk requiring a lot of ports to be opened, the `asterisk-testbox`
uses the `--network host` which simplifies things slightly, though means you
can only expose one asterisk during the tests. To ensure the configuration
works to connect to the `asterisk-carrier`, a static IP address has been set
for it. See `./docker-compose.yml` for more information.

# Testing

In the Asterisk CLI (connect using `asterisk -rvvvvv`) you can test in both
directions. The commands below depend which asterisk you've connected to.

## Carrier to testbox

```
> originate SIP/1001@asterisk-testbox application echo
> originate SIP/1001@asterisk-testbox application playback tt-weasels
```

## Testbox to carrier

```
> originate SIP/1000@asterisk-carrier extension 1000
```

# Debugging

You're going to have to debug why something isn't working at some point.

```
> core set verbose 10
> sip set debug on
> pjsip set logger on
```

# SEE ALSO
* [Asterisk]
* [Asterisk Docker](https://github.com/dougbtv/docker-asterisk/blob/master/asterisk/13/Dockerfile/)

[Asterisk]: https://www.asterisk.org/
[tmuxinator]: https://github.com/tmuxinator/tmuxinator
