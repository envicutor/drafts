FROM buildpack-deps:bookworm

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/envicutor/isolate.git /tmp/isolate/ && \
    cd /tmp/isolate && \
    git checkout ae21aeca2958f855e9d5b1252f074d7d3f67ff70 && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
