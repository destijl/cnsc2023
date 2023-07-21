# An old version of go to build with
ARG BUILD_IMAGE=golang:1.18.1
# Distroless static as our base image to remove OS vulns
ARG BASE_IMAGE=gcr.io/distroless/static:latest


# Build the go binary
FROM $BUILD_IMAGE as builder

ARG BUILD_PATH=used_lib

WORKDIR /

COPY ${BUILD_PATH}/go.mod ./
COPY ${BUILD_PATH}/go.sum ./
RUN go mod download

COPY ${BUILD_PATH}/*.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o badapp

# Copy it into our base image
FROM $BASE_IMAGE

COPY --from=builder /badapp /bin

CMD [ "/bin/badapp" ]
