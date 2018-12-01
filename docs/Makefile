DOCKER       ?= docker
HUGO_VERSION ?= 0.50
DOCKER_IMAGE ?= jojomi/hugo:$(HUGO_VERSION)
DOCKER_RUN   ?= $(DOCKER) run --rm --interactive --tty --volume $(PWD):/src

.PHONY: all build build-preview help serve test

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: build ## Build site with production settings and put deliverables in ./public

build: ## Build site with production settings and put deliverables in ./public
	$(DOCKER_RUN) $(DOCKER_IMAGE) hugo

build-preview: ## Build site with drafts and future posts enabled
	$(DOCKER_RUN) $(DOCKER_IMAGE) hugo -D -F

check-headers-file:
	scripts/check-headers-file.sh

build-production: build check-headers-file ## Build the production site and ensure that noindex headers aren't added

build-non-production: ## Build the non-production site, which adds noindex headers to prevent indexing
	$(DOCKER_RUN) $(DOCKER_IMAGE) hugo --enableGitInfo

# https://github.com/wjdp/htmltest
# TODO: run this in a container
test: ## Test for broken links with htmltest
	htmltest

serve: ## Boot the development server
	$(DOCKER_RUN) -p 1313:1313 $(DOCKER_IMAGE) hugo server --watch --ignoreCache --disableFastRender --bind 0.0.0.0
