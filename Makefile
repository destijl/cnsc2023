IMG = cnsc2023
TAG = latest
REGION = us-central1
PROJECT = gcastle-gke-dev
REPO = gcastle-test
REGISTRY = ${REGION}-docker.pkg.dev/${PROJECT}/${REPO}
FULL_PATH = ${REGISTRY}/${IMG}:${TAG}

server: server.go
	CGO_ENABLED=0 go build -a -ldflags '-w'  -o server server.go

$(REGISTRY)/$(IMG): server
	podman build -t $@:$(TAG) .

image: $(REGISTRY)/$(IMG) ;

push: image
	gcloud auth print-access-token | podman login -u oauth2accesstoken --password-stdin ${REGION}-docker.pkg.dev
	podman push ${FULL_PATH}

run: image
	podman run --rm -p 8080:8080 ${FULL_PATH}
