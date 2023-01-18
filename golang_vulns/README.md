# Overview
Two simple golang binaries to demonstrate differences between vulnerability
scanners.

Also includes a dockerfile to package a binary into a container for scanning.

The binary built from `unused_lib` imports golang.org/x/crypto/ssh but does not
use it. The binary built from `used_lib` actually calls the vulnerable function.
This is to demonstrate `govulncheck` and its ability to check for
vulnerabilities based on the symbol table.

# Building

To build, just enter the directory and issue a go build command:
```
cd unused_lib
go build . -o badapp
```

To scan the resulting binary, use the `govulncheck` command:
```
govulncheck badapp
```

Note: govulncheck is not compatible with binaries built from all versions of golang.

The included dockerfile will build a container image with the vulnerable binary
included. To build it, just run the following:

```
docker build .
```
