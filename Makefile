APP=$(shell basename $(shell git remote get-url origin))
REGESTRY= asemua
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETARCH=amd64
linux: TARGETOS=linux 
windows: TARGETOS=windows 
darwin: TARGETOS=darwin
android: TARGETOS=android

format: 
	gofmt -s -w ./

get:
	go get

lint:
	golint

test: 
	go test -v

linux: format get
	GO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

windows: format get
	GO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

darwin: format get
	GO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

android: format get
	GO_ENABLED=0 GOOS=${TARGETOS} GOARCH=arm go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/ASEMUA/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean: 
	rm -rf kbot
	docker rmi ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}