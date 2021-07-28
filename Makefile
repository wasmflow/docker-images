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

##@ Building

.PHONY: all Dockerfile.*

build: $(wildcard Dockerfile.*) ## Build/push all images

aarch64-unknown-linux-gnu-base: ## Build base image for aarch64-unknown-linux-gnu
	@docker build . -f docker/Dockerfile.aarch64-unknown-linux-gnu  --build-arg VERSION=$(CROSS_VERSION) -t aarch64-unknown-linux-gnu-base

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
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_\-.*]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
