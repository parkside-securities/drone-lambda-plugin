FROM golang:1.11-alpine as build

WORKDIR /go/src/app
COPY . .

RUN apk update && \
    apk add \
    git && \
    rm -rf /var/cache/apk/*

RUN go get -u github.com/aws/aws-sdk-go
RUN go build main.go

FROM alpine

RUN apk update && \
    apk add \
    ca-certificates && \
    rm -rf /var/cache/apk/*

ENV AWS_SDK_LOAD_CONFIG=true

RUN pwd
COPY --from=build /go/src/app/main /bin/main

ENTRYPOINT ["/bin/main"]

