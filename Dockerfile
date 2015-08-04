FROM debian:sid

RUN apt-get update &&\
    apt-get install --no-install-recommends -y -q \
        apt-transport-https \
        bzr \
        ca-certificates \
        curl \
        git \
        golang \
        mercurial \
        patch \
        &&\
    mkdir /gopath

# Install Docker 1.5. Newer versions may not be supported by all the host environments.
# The code was adapted from https://get.docker.com
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 &&\
    echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list &&\
    apt-get update &&\
    apt-get install -y lxc-docker-1.5.0

ENV GOPATH /gopath

ENV PATH $PATH:/gopath/bin

COPY root /

ENTRYPOINT [ "/run.sh" ]
