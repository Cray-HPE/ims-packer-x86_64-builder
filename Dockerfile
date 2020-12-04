## Cray Image Management Service image build environment Dockerfile
## Copyright 2018, Cray Inc. All rights reserved.
FROM dtr.dev.cray.com/baseos/opensuse:15
COPY requirements.txt constraints.txt  /
RUN zypper in -y curl ca-certificates-mozilla python3-pip unzip && \
    zypper clean && \
    curl -O https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip && \
    unzip packer_1.6.0_linux_amd64.zip -d /usr/local && \
    pip install --upgrade pip \
        --trusted-host dst.us.cray.com \
        --index-url http://dst.us.cray.com/dstpiprepo/simple && \
    pip install \
       --no-cache-dir \
       -r requirements.txt
VOLUME /mnt/image
VOLUME /mnt/recipe
RUN mkdir -p /scripts
COPY entrypoint.sh /scripts/entrypoint.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]


