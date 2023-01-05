.PHONY: all build

DOCKER=docker
IMAGE=ghcr.io/smkwlab/latex-image

all: build

build:
	$(DOCKER) image build -t $(IMAGE) .
