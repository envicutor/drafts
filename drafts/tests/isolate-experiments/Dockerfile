FROM buildpack-deps:bookworm

COPY ./isolate /tmp/isolate

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp/isolate && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
# TODO: can't use isolate --cg --cg-mem
CMD ["/bin/bash"]
