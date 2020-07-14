DIR = $(shell pwd)
all: build

.PHONY: clean
clean:
	rm -rf isucoin

# init:
# 	mkdir -p ${DIR}/bin
# 	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | GOPATH=${DIR} DEP_RELEASE_TAG=v0.5.0 sh

deps:
	cd ${DIR}/src/bench; go mod init bench

.PHONY: build
build:
	cd src/bench && go build -v -o bench cmd/bench/main.go
	mv src/bench/bench bin/bench

build-isucointest:
	GOPATH=${DIR} go build -v -o bin/isucointest bench/cmd/isucointest
