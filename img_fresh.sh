#!/bin/bash

# $1 image
# $2 source path
# return true if the image is newer than the newest file in the source tree
function img_fresh() {
    # find creation date of container image, if present
    # NB: remove sub-second precision and make it find-friendly
    local version=$(docker -v | cut -d' ' -f 3)
    local major=$(echo $version | cut -d. -f 1)
    local minor=$(echo $version | cut -d. -f 2)
    if (( "$major" >= 1 && "$minor" >= 8 )) ; then
        local created=$(
            docker inspect --format='{{.Created}}' --type=image "$1" |\
            cut -d. -f1 |\
            sed 's/T/ /'
        )
    else
        docker build -t test-newer - &>/dev/null <<EOF
FROM alpine:3.3
RUN apk -U add curl jq
EOF
        local created=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock test-newer sh -c \
            "curl --fail --unix-socket /var/run/docker.sock http:/images/\$(echo $1 | jq -R -r @uri)/json 2>/dev/null \
            | jq -r '.Created[0:19]' | sed 's/T/ /'"
        )
    fi
    echo "$1 created: $created" 1>&2
    # find first file in build context newer than image, if any
    # NB: docker gives UTC timestamps, make sure find does not compare it to local time
    [[ -n "$created" ]] && [[ -e "$2" ]] && [[ -z "$(TZ=UTC find "$2" -newermt "$created" | head -n 1)" ]]
}

