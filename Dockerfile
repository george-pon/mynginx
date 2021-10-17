FROM nginx:latest

ENV MYNGINX_VERSION build-target
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

# add shell
ADD wait-for-tcp-close.sh /usr/local/bin/wait-for-tcp-close.sh
RUN chmod +x /usr/local/bin/wait-for-tcp-close.sh

# add conf
COPY fs/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY fs/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
