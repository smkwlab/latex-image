.PHONY: all build

DOCKER=docker

IMAGE=ghcr.io/smkwlab/$(notdir $(CURDIR))
TAG1=$(IMAGE):latest
TAG2=$(IMAGE):$(shell date +'%Y%m%d')

all: build

build:
	$(DOCKER) image build -t $(TAG1) -t $(TAG2) .
