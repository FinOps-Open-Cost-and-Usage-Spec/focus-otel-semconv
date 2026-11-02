include versions.env

WEAVER ?= weaver
POLICY := $(POLICY_REPO_URL)@$(POLICY_REPO_REF)[policies/check]
SCHEMA_URI := https://focus.finops.org/schemas/otel/0.1.0-dev/resolved.yaml

# Use `make WEAVER=docker-weaver check` to run Weaver in a container instead.
DOCKER_WEAVER := docker run --rm -u $$(id -u):$$(id -g) -v "$(CURDIR):/workspace" \
	-w /workspace -e HOME=/tmp otel/weaver:$(WEAVER_VERSION)
ifeq ($(WEAVER),docker-weaver)
WEAVER := $(DOCKER_WEAVER)
endif

.PHONY: check package clean

## check: validate the registry against OTel's policies and this registry's own
check:
	$(WEAVER) registry check -r ./model --v2 --policy '$(POLICY)' --policy ./policies

## package: write the resolved registry to ./.build/package
package:
	$(WEAVER) registry package -r ./model --v2 \
		--resolved-registry-uri $(SCHEMA_URI) -o ./.build/package

clean:
	rm -rf ./.build
