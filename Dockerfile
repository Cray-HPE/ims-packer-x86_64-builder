## Cray Image Management Service image build environment Dockerfile
# Copyright 2018, 2021 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# (MIT License)

FROM arti.dev.cray.com/baseos-docker-master-local/opensuse-leap:15.2 as base
COPY requirements.txt constraints.txt  /
RUN zypper in -y curl ca-certificates-mozilla python3-pip unzip && \
    zypper clean && \
    curl -O https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip && \
    unzip packer_1.6.0_linux_amd64.zip -d /usr/local && \
    pip install --upgrade pip \
        --trusted-host arti.dev.cray.com \
        --index-url https://arti.dev.cray.com:443/artifactory/api/pypi/pypi-remote/simple && \
    pip install \
       --no-cache-dir \
       -r requirements.txt
VOLUME /mnt/image
VOLUME /mnt/recipe
RUN mkdir -p /scripts
COPY entrypoint.sh /scripts/entrypoint.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]


