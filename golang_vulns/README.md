# Overview
Three simple golang binaries to demonstrate differences between vulnerability
scanners. 

All are a simple variation of a "Hello world!" program, with slight differences
for illustrative purposes. The `golang.org/x/crypto` module is included in 
some of these at version `v0.0.0-20200427165652-729f1e841bcc`, which contains 
CVE-2020-29652 in the `NewServerConn` method. More information about this 
vulnerability can be found at https://pkg.go.dev/vuln/GO-2021-0227. The following three
directories each build a different go binary:

- `no_lib` - the program without any modules.
- `unused_lib` - the program imports the vulnerable module, but does not use it.
- `used_lib` - the pgoram imports the vulnerable module, and calls the
  vulnerable method.

This can be used to demonstrate differences in scanner methodology, and how 
`govulncheck` can more accurately detect vulnerabilities in these binaries. More
information about `govulncheck` and installation instructions can be found in
https://go.dev/blog/govulncheck.

We also includes a dockerfile to package the binary into a container for use with container images scanners.

# Building

To build a binary, just enter the directory and issue a go build command:
```
cd unused_lib
go build . -o badapp
```

To scan the resulting binary, with the `govulncheck` command:
```
govulncheck --mode=binary badapp
```

Note: govulncheck is not compatible with binaries built from versions of golang prior to 1.18.

The included dockerfile will build a container image with the vulnerable binary
included. To build it, just run the following:

```
docker build .
```

You can pass wchich of the binaries to build in the container by specifying the `BUILD_PATH` argument:

```
docker build --build-arg BUILD_PATH=unused_lib .
```

The Dockerfile uses `golang:1.18.1` by default, with
`gcr.io/distroless/static:latest` as a base image. These can be overridden with
the `BUILD_IMAGE` and `BASE_IMAGE` build arguments.
