APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=asemua
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64

format: 
	gofmt -s -w ./

get:
	go get

lint:
	golint

test: 
	go test -v

linux:
	GO_ENABLED=0 GOOS=linux GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

windows:
	TARGETOS=windows GO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

darwin:
	GO_ENABLED=0 GOOS=darwin GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

arm:
	GO_ENABLED=0 GOOS=arm GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean: 
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}