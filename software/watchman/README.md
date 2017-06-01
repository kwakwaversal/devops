# rsyslog
Using [Watchman] to trigger events following on SFTP file uploads/modifications

# Synopsis
```sh
$ mkdir -p /tmp/sftp/foo/upload
$ docker-compose up -d
```

# Description
Using an SFTP drop for friends/customers to securely upload files to you is
commonplace. Knowing if something has been uploaded is generally not built into
SFTP, so you might end up polling for new files using a cron job. This is fine
for the most part, but I find it inefficient checking for new files every X
minutes, hours days etc.

Using a file/folder monitoring tool which performs a trigger following a change
in the file system makes a lot more sense. This repo uses [Watchman] for to
execute a trigger when something has changed in an SFTP drop.

# References
* [Watchman]
* [Watchman Docker image](https://github.com/jotadrilo/watchman-container)

[Watchman]: https://facebook.github.io/watchman/
