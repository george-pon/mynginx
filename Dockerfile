FROM nginx:1.17

ENV MYNGINX_VERSION build-target
ENV MYNGINX_VERSION 1.17
ENV MYNGINX_VERSION latest
ENV MYNGINX_VERSION stable
ENV MYNGINX_IMAGE mynginx

ENV DEBIAN_FRONTEND noninteractive

# install etc utils
RUN apt-get update && apt-get install -y \
        curl \
        dnsutils \
        iproute2 \
        jq \
        lsof \
        netcat \
        net-tools \
        procps \
        sudo \
        tcpdump \
        traceroute \
        tree \
        unzip \
        wget \
        zip \
    && apt-get clean all

