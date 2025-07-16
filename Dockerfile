FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y git build-essential pkg-config libssl-dev wget && \
    rm -rf /var/lib/apt/lists/*

# Clone SRS
RUN git clone https://github.com/ossrs/srs.git /usr/local/src/srs
WORKDIR /usr/local/src/srs/trunk

# Build minimal server
RUN ./configure --without-transcode --without-ssl --without-hls --without-hds --without-dvr --without-nginx && \
    make -j$(nproc)

COPY srs.conf /usr/local/src/srs/trunk/objs/srs.conf

EXPOSE 1935
CMD ["./objs/srs", "-c", "objs/srs.conf"]
