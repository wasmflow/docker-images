.DEFAULT_GOAL:=all

# Enforce bash as the shell for consistency
SHELL := bash
# Use bash strict mode
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CROSS_VERSION := 0.2.1
ORG         := vinodotdev
RELEASE       ?= false

GIT_HASH:=$(shell git -C . rev-parse --short HEAD)
GIT_STATUS:=$(shell git diff --quiet && echo clean || echo dirty)

##@ Building

.PHONY: all Dockerfile.*

all: $(wildcard Dockerfile.*)

Dockerfile.*: ## Build specific image
	@docker build . -f $@ -t $(ORG)/$(@:Dockerfile.%=%)
ifeq ($(RELEASE),true)
ifeq ($(GIT_STATUS),clean)
	docker tag $(ORG)/$(@:Dockerfile.%=%) -t $(ORG)/$(@:Dockerfile.%=%):latest
	docker tag $(ORG)/$(@:Dockerfile.%=%) -t $(ORG)/$(@:Dockerfile.%=%):$(GIT_HASH)
	docker push $(ORG)/$(@:Dockerfile.%=%):latest
	docker push $(ORG)/$(@:Dockerfile.%=%):$(GIT_HASH)
else
	@echo Refusing to release. Commit your changes and try again.
endif
endif

##@ Helpers

.PHONY: help

list: ## Display supported images
	@ls Dockerfile.* | sed -nE 's/Dockerfile\.(.*)/\1/p' | sort

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_\-.*]+:.*?##/ { printf "  \033[36m%-32s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
