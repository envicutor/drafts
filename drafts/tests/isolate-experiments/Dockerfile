FROM buildpack-deps:bookworm

COPY ./executor.service /systemd-services/executor.service

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev libsystemd-dev systemd && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 52d081789620e6fb23bfb7c674fe97b91e71671b && \
    make -j$(nproc) install && \
    cp ./systemd/* /systemd-services/. && \
    systemctl enable /systemd-services/isolate.service /systemd-services/executor.service && \
    rm -rf /tmp/*

CMD ["systemd"]
