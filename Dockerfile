FROM google/dart:2.5 as build

ARG NPM_TOKEN
ARG NPM_CONFIG__AUTH
ARG NPM_CONFIG_REGISTRY=https://npm.workiva.net
ARG NPM_CONFIG_ALWAYS_AUTH=true

# Build Environment Vars
ARG BUILD_ID
ARG BUILD_NUMBER
ARG BUILD_URL
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG GIT_TAG
ARG GIT_COMMIT_RANGE
ARG GIT_HEAD_URL
ARG GIT_MERGE_HEAD
ARG GIT_MERGE_BRANCH
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
WORKDIR /build/
ADD . /build/

RUN mkdir /root/.ssh && \
    echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts" && \
    chmod 700 /root/.ssh/ && \
    umask 0077 && echo "$GIT_SSH_KEY" >/root/.ssh/id_rsa && \
    eval "$(ssh-agent -s)" && ssh-add /root/.ssh/id_rsa

RUN dart --version
RUN pub get

RUN tar -cvzf /build/assets.tar.gz -C lib sockjs.js sockjs_prod.js
ARG BUILD_ARTIFACTS_CDN=/build/assets.tar.gz

FROM scratch
