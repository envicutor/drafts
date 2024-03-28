#!/bin/bash

mkdir -p /sys/fs/cgroup/isolate && mount -t cgroup2 none /sys/fs/cgroup/isolate || exit 1
exec "$@"
