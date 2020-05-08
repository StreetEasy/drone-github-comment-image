FROM golang:1.14-alpine AS build

ARG VERSION
ARG REPO=https://github.com/StreetEasy/drone-github-comment

RUN apk --no-cache update && \
  apk --no-cache add ca-certificates git && \
  rm -rf /var/cache/apk/*

RUN git clone ${REPO} /go/src/github.com/jmccann/drone-github-comment \
  && cd /go/src/github.com/jmccann/drone-github-comment \
  && git checkout $VERSION

WORKDIR /go/src/github.com/jmccann/drone-github-comment

RUN	CGO_ENABLED=0 go build -o bin/drone-github-comment \
  -ldflags "-X github.com/jmccann/drone-github-comment.revision=${VERSION}"

FROM scratch
COPY --from=build /etc/ssl/certs/ /etc/ssl/certs/
COPY --from=build /go/src/github.com/jmccann/drone-github-comment/bin/drone-github-comment /usr/local/bin/drone-github-comment
ENTRYPOINT ["/usr/local/bin/drone-github-comment"]
