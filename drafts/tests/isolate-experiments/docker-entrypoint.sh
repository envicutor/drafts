#!/bin/bash

mkdir -p /sys/fs/cgroup/isolate/ || exit 1
exec "$@"
