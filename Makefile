.DEFAULT_GOAL:=all

# Enforce bash as the shell for consistency
SHELL := bash
# Use bash strict mode
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CROSS_VERSION := 0.2.1
IMAGE         := vinodotdev/cross
RELEASE       ?= false

BASE_IMAGES := armv7-unknown-linux-gnueabihf-base aarch64-unknown-linux-gnu-base x86_64-pc-windows-gnu-base i686-pc-windows-gnu-base

##@ Building

.PHONY: all $(BASE_IMAGES) Dockerfile.*

all: build

build: $(BASE_IMAGES) $(wildcard Dockerfile.*) ## Build/push all images

armv7-unknown-linux-gnueabihf-base: ## Build base image for armv7-unknown-linux-gnueabihf
	@cd docker; \
		docker build . -f Dockerfile.armv7-unknown-linux-gnueabihf  --build-arg VERSION=$(CROSS_VERSION) -t $(IMAGE):$@
	@cd ..
ifeq ($(RELEASE),true)
	docker push $(IMAGE):$@
endif

aarch64-unknown-linux-gnu-base: ## Build base image for aarch64-unknown-linux-gnu
	@cd docker; \
		docker build . -f Dockerfile.aarch64-unknown-linux-gnu  --build-arg VERSION=$(CROSS_VERSION) -t $(IMAGE):$@
	@cd ..
ifeq ($(RELEASE),true)
	docker push $(IMAGE):$@
endif

i686-pc-windows-gnu-base: ## Build base image for i686-pc-windows-gnu
	@cd docker; \
	 	docker build . -f Dockerfile.i686-pc-windows-gnu  --build-arg VERSION=$(CROSS_VERSION) -t $(IMAGE):$@
	@cd ..
ifeq ($(RELEASE),true)
	docker push $(IMAGE):$@
endif

x86_64-pc-windows-gnu-base: ## Build base image for x86_64-pc-windows-gnu
	@cd docker; \
	 	docker build . -f Dockerfile.x86_64-pc-windows-gnu  --build-arg VERSION=$(CROSS_VERSION) -t $(IMAGE):$@
	@cd ..
ifeq ($(RELEASE),true)
	docker push $(IMAGE):$@
endif

Dockerfile.*: ## Build specific image
	@docker build . -f $@ --build-arg VERSION=$(CROSS_VERSION) \
		-t $(IMAGE):$(@:Dockerfile.%=%)
ifeq ($(RELEASE),true)
		docker push $(IMAGE):$(@:Dockerfile.%=%)
endif

##@ Helpers

.PHONY: help

list: ## Display supported images
	@ls Dockerfile.* | sed -nE 's/Dockerfile\.(.*)/\1/p' | sort

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_\-.*]+:.*?##/ { printf "  \033[36m%-32s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
