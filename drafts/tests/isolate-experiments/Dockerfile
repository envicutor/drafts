FROM buildpack-deps:bookworm

RUN set -xe && \
    mkdir /isolate-systemd && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev libsystemd-dev systemd && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 52d081789620e6fb23bfb7c674fe97b91e71671b && \
    make -j$(nproc) install && \
    cp -r ./systemd/ /isolate-systemd/. && \
    systemctl enable /isolate-systemd/systemd/isolate.service && \
    rm -rf /tmp/*

CMD ["systemd"]
