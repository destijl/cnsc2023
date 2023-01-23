ARG buildpath=used_lib
# An old version of go to build with
FROM golang:1.18.1-buster as builder

ARG buildpath
WORKDIR /

COPY ${buildpath}/go.mod ./
COPY ${buildpath}/go.sum ./
RUN go mod download

COPY ${buildpath}/*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o badapp

# An old version of debian buster as a base
FROM debian:buster-20210208

COPY --from=builder /badapp /bin

CMD [ "/bin/badapp" ]
