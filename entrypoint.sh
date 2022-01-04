#!/usr/bin/env sh

usermod -u "${UID}" user
usermod -u "${GID}" user

sudo su-exec user /bin/zsh
