#!/bin/bash

# $Id: $
# Following
# https://cloud.google.com/binary-authorization/docs/making-attestations
# https://cloud.google.com/binary-authorization/docs/creating-attestors-console

PROJECT="gcastle-gke-dev"
REGION="us-central1"
KEYNAME="binauthz"
# If you change this you need to change the binauthz policy file.
CLUSTER="cnsc2"

NOTE_ID="is-distroless"
NOTE_URI="projects/${ATTESTOR_PROJECT_ID}/notes/${NOTE_ID}"
DESCRIPTION="This image is built on a distroless base"
CONTAINER="us-central1-docker.pkg.dev/gcastle-gke-dev/gcastle-test/distroless@sha256:624dec0474955fd8cac0ce44f3266b5204dad35ec7d23783bf0388e2d42c4c82"
IMAGE_TO_ATTEST=${CONTAINER}

ATTESTOR_NAME=${NOTE_ID}
ATTESTATION_PROJECT_ID=${PROJECT}
KMS_KEY_PROJECT_ID=${PROJECT}
KMS_KEY_LOCATION=${REGION}
KMS_KEYRING_NAME=${KEYNAME}
KMS_KEY_NAME=${KEYNAME}
KMS_KEY_VERSION=1

DEPLOYER_PROJECT_ID=${PROJECT}
DEPLOYER_PROJECT_NUMBER="$(
    gcloud projects describe "${DEPLOYER_PROJECT_ID}" \
      --format="value(projectNumber)"
)"

ATTESTOR_PROJECT_ID=${PROJECT}
ATTESTOR_PROJECT_NUMBER="$(
    gcloud projects describe "${ATTESTOR_PROJECT_ID}" \
    --format="value(projectNumber)"
)"

DEPLOYER_SERVICE_ACCOUNT="service-${DEPLOYER_PROJECT_NUMBER}@gcp-sa-binaryauthorization.iam.gserviceaccount.com"
ATTESTOR_SERVICE_ACCOUNT="service-${ATTESTOR_PROJECT_NUMBER}@gcp-sa-binaryauthorization.iam.gserviceaccount.com"

cat > /tmp/note_payload.json << EOM
{
  "name": "${NOTE_URI}",
  "attestation": {
    "hint": {
      "human_readable_name": "${DESCRIPTION}"
    }
  }
}
EOM

curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    -H "x-goog-user-project: ${ATTESTOR_PROJECT_ID}" \
    --data-binary @/tmp/note_payload.json  \
    "https://containeranalysis.googleapis.com/v1/projects/${ATTESTOR_PROJECT_ID}/notes/?noteId=${NOTE_ID}"

curl \
    -H "Authorization: Bearer $(gcloud auth print-access-token)"  \
    -H "x-goog-user-project: ${ATTESTOR_PROJECT_ID}" \
    "https://containeranalysis.googleapis.com/v1/projects/${ATTESTOR_PROJECT_ID}/notes/"

cat > /tmp/iam_request.json << EOM
{
  "resource": "${NOTE_URI}",
  "policy": {
    "bindings": [
      {
        "role": "roles/containeranalysis.notes.occurrences.viewer",
        "members": [
          "serviceAccount:${ATTESTOR_SERVICE_ACCOUNT}"
        ]
      }
    ]
  }
}
EOM

curl -X POST  \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "x-goog-user-project: ${ATTESTOR_PROJECT_ID}" \
    --data-binary @/tmp/iam_request.json \
    "https://containeranalysis.googleapis.com/v1/projects/${ATTESTOR_PROJECT_ID}/notes/${NOTE_ID}:setIamPolicy"

gcloud --project="${ATTESTOR_PROJECT_ID}" \
     container binauthz attestors create "${ATTESTOR_NAME}" \
    --attestation-authority-note="${NOTE_ID}" \
    --attestation-authority-note-project="${ATTESTOR_PROJECT_ID}"

gcloud container binauthz attestors add-iam-policy-binding \
  "projects/${ATTESTOR_PROJECT_ID}/attestors/${ATTESTOR_NAME}" \
  --member="serviceAccount:${DEPLOYER_SERVICE_ACCOUNT}" \
  --role=roles/binaryauthorization.attestorsVerifier

gcloud kms keyrings create $KEYNAME \
    --location $REGION

gcloud kms keys create $KEYNAME \
    --keyring $KEYNAME \
    --location $REGION \
    --purpose "asymmetric-signing" \
    --default-algorithm "ec-sign-p256-sha256"

gcloud --project="${ATTESTOR_PROJECT_ID}" \
     container binauthz attestors public-keys add \
    --attestor="${ATTESTOR_NAME}" \
    --keyversion-project="${KMS_KEY_PROJECT_ID}" \
    --keyversion-location="${KMS_KEY_LOCATION}" \
    --keyversion-keyring="${KMS_KEYRING_NAME}" \
    --keyversion-key="${KMS_KEY_NAME}" \
    --keyversion="${KMS_KEY_VERSION}"

gcloud --project="${ATTESTOR_PROJECT_ID}" \
     container binauthz attestors list

gcloud container binauthz policy import binauthz_policy.yaml

gcloud beta container binauthz attestations sign-and-create \
    --project="${ATTESTATION_PROJECT_ID}" \
    --artifact-url="${IMAGE_TO_ATTEST}" \
    --attestor="${ATTESTOR_NAME}" \
    --attestor-project="${ATTESTOR_PROJECT_ID}" \
    --keyversion-project="${KMS_KEY_PROJECT_ID}" \
    --keyversion-location="${KMS_KEY_LOCATION}" \
    --keyversion-keyring="${KMS_KEYRING_NAME}" \
    --keyversion-key="${KMS_KEY_NAME}" \
    --keyversion="${KMS_KEY_VERSION}"

