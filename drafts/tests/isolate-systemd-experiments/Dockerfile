FROM buildpack-deps:bookworm

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libsystemd-dev systemd git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate/ && \
    cd /tmp/isolate && \
    make -j$(nproc) install && \
    mkdir /systemd-services && cp ./systemd/* /systemd-services/. && \
    systemctl enable /systemd-services/isolate.service && \
    rm -rf /tmp/*

CMD ["systemd"]
