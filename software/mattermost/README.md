# Mattermost
Testing the [Mattermost] [API]

# SYNOPSIS

```sh
$ docker-compose up -d
```

# DESCRIPTION
A simple way to test the Mattermost API, specifically the [incoming API][API
Incoming]. It provides a simple web interface using [Mojolicious] for both
sending JSON to an incoming webhook, and providing the response for the
webhook.

# TESTING
If you have `inotify-tools` installed, you can simplify the submission of a
JSON payload to a mattermost incoming hook, especially when you're tweaking the
JSON.

Open `/tmp/mattermost-payload.json` in your `$EDITOR` and work on it as normal.
Every time you save the file, it will submit the JSON payload using the `POST`
method to a URL of your choice.

```bash
while inotifywait -e close_write /tmp/mattermost-payload.json;
do
    curl -i -X POST -H 'Content-Type: application/json' \
		--data-binary "@/tmp/mattermost-payload.json"   \
		http://localhost:8065/hooks/jk5x5idt1ig19jkbfafezb8j9h
done
```

# SEE ALSO
* [Mattermost]
* [Mattermost Docker](https://hub.docker.com/r/mattermost/mattermost-preview/)

[Mattermost]: https://about.mattermost.com/
[API]: https://docs.mattermost.com/developer/api.html
[API Incoming]: https://docs.mattermost.com/developer/webhooks-incoming.html
[Mojolicious]: http://mojolicious.org/

https://github.com/M-Mueller/mattermost-poll/blob/072817361c0283f23f9025176a2c48a478bc58b4/app.py#L54-L66
