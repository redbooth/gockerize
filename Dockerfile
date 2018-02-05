FROM debian:sid

RUN apt-get update &&\
    apt-get install --no-install-recommends -y -q \
        bzr \
        ca-certificates \
        curl \
        git \
        mercurial \
        patch

RUN curl -L --fail https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 -o /usr/local/bin/docker &&\
    chmod +x /usr/local/bin/docker

ENV GOPATH /gopath

ENV PATH $PATH:/usr/local/go/bin:/gopath/bin

COPY root /

ENTRYPOINT [ "/run.sh" ]
