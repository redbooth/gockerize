FROM debian:sid

RUN apt-get update &&\
    apt-get install --no-install-recommends -y -q \
        apt-transport-https \
        bzr \
        ca-certificates \
        curl \
        git \
        mercurial \
        patch

# Install Docker 1.5. Newer versions may not be supported by all the host environments.
# The code was adapted from https://get.docker.com
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 &&\
    echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list &&\
    apt-get update &&\
    apt-get install -y lxc-docker-1.5.0

# Installing from official packages makes it easier to bump Go version when distro lags
# behind. For instance Debian is taking too long to upgrade to 1.5.3 which includes an
# important security fix.
RUN curl https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz -o go.tar.gz &&\
    tar -C /usr/local -xzf go.tar.gz &&\
    rm -rf go.tar.gz &&\
    mkdir /gopath

ENV GOPATH /gopath

ENV PATH $PATH:/usr/local/go/bin:/gopath/bin

COPY root /

ENTRYPOINT [ "/run.sh" ]
