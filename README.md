Tini Automated Builds
=====================

This is a repository of automated builds for [Tini, a tiny but valid init
for Docker containers][10].

In a nutshell, Tini:

  + Spawns your app just like Docker would, and makes itself transparent
    by forwarding any signals it receives to your app.
  + Reaps zombies that your app may generate.


Using this repository
---------------------

If you are using an Ubuntu or CentOS image as your base, just update your
Dockerfile to use the Tini images instead. Note that these images are create
with Docker automated builds; there are no binary blobs shipping here!

If you aren't using one of those images, check the [Tini repository][10] for
alternative install instructions.


### Example: ###

    # Change this:
    FROM ubuntu:trusty

    # To this:
    FROM krallin/ubuntu-tini:trusty


### Entrypoint Compatibility ###

The Tini images ship with an `ENTRYPOINT` that points to Tini. If you have
your own `ENTRYPOINT` already, just prefix it with Tini:

    # Change this:
    ENTRYPOINT ["/docker-entrypoint.sh"]

    # To this:
    ENTRYPOINT ["/usr/local/bin/tini", "--", "/docker-entrypoint.sh"]

If you're not using an `ENTRYPOINT`, you don't have to do anyting.


Tags
----

Visit the Docker hub for a list of tags that are available:

  + [CentOS][20]
  + [Ubuntu][21]

  [10]: https://github.com/krallin/tini
  [20]: https://registry.hub.docker.com/u/krallin/centos-tini
  [21]: https://registry.hub.docker.com/u/krallin/ubuntu-tini
