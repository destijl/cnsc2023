# cnsc2023
Cloud Native Security Con 2023 Demo Code

The `distroless` directory contains two solutions to the problem of creating an
attestation that proves a property like "this container uses a distroless base
image". The one we demoed onstage is `distroless/cosign` that uses a basic
on-host key with the sigstore policy controller. There's also a
`distroless/binauthz` solution that you'd use on GKE with KMS-managed keys
(which we didn't demo).

The `distroless/is_distroless.sh` script shows you how you can use gcrane to
pull out a file to determine the OS base image.

The `gatekeeper_repo_policy` directory contains the solution to install a
gatekeeper policy to restrict the container registry/repo targets allowed in
Kubernetes manifests.

The `golang_vulns` directory contains the govulncheck example program and
demo.
