#!/bin/bash

cd /sys/fs/cgroup && \
echo '+cpuset +cpu +io +memory +pids' > cgroup.subtree_control && \
mkdir isolate/ && \
exec "$@"
