FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git build-essential pkg-config libssl-dev wget unzip automake tclsh cmake && \
    rm -rf /var/lib/apt/lists/*



# Clone SRS
RUN git clone https://github.com/ossrs/srs.git /usr/local/src/srs
WORKDIR /usr/local/src/srs/trunk

# Build minimal SRS
RUN ./configure --without-transcode --without-ssl --without-hls --without-hds --without-dvr --without-nginx && \
    make -j$(nproc)

# Copy your SRS config
COPY srs.conf /usr/local/src/srs/trunk/objs/srs.conf

EXPOSE 1935
CMD ["./objs/srs", "-c", "objs/srs.conf"]
