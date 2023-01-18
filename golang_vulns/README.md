# Overview
A simple docker container based on an older debian image.

Includes a golang binary compiled with an old go version.

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

Note that govulncheck is not compatible with binaries built from all versions of
golang.
