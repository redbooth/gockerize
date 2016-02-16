FROM debian:sid

RUN apt-get update &&\
    apt-get install --no-install-recommends -y -q \
        bzr \
        ca-certificates \
        curl \
        git \
        mercurial \
        patch

# Install Docker 1.5. Newer versions may not be supported by all the host environments.
# The code was adapted from https://get.docker.com
RUN curl -L --fail https://get.docker.com/builds/Linux/x86_64/docker-1.5.0 -o /usr/local/bin/docker &&\
    chmod +x /usr/local/bin/docker

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
