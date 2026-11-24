include versions.env

WEAVER ?= weaver
OPA ?= opa
POLICY := $(POLICY_REPO_URL)@$(POLICY_REPO_REF)[policies/check]
SCHEMA_URI := https://focus.finops.org/schemas/otel/0.1.0-dev/resolved.yaml

# Use `make WEAVER=docker-weaver check` to run Weaver in a container instead.
DOCKER_WEAVER := docker run --rm -u $$(id -u):$$(id -g) -v "$(CURDIR):/workspace" \
	-w /workspace -e HOME=/tmp otel/weaver:$(WEAVER_VERSION)
ifeq ($(WEAVER),docker-weaver)
WEAVER := $(DOCKER_WEAVER)
endif

.PHONY: check test-policies live-check package generate-docs check-docs clean

## check: validate the registry against OTel's policies and this registry's own
check:
	$(WEAVER) registry check -r ./model --v2 --policy '$(POLICY)' --policy ./policies

## test-policies: run the unit tests for this registry's own policies
test-policies:
	$(OPA) test --explain fails ./policies ./policies_test

## live-check: check the reference telemetry samples against the registry
live-check:
	$(WEAVER) registry live-check -r ./model --v2 --config reference/.weaver.toml \
		--input-source reference/samples/support-bot.json --no-stream

# The core templates read Weaver's v1 resolved schema, so docs targets omit --v2.
## generate-docs: regenerate docs/registry and every <!-- semconv --> block
generate-docs:
	$(WEAVER) registry generate -r ./model --templates '$(TEMPLATES_URL)' \
		markdown ./docs/registry
	$(WEAVER) registry update-markdown -r ./model --templates '$(TEMPLATES_URL)' \
		--target markdown --param registry_base_url=/docs/registry/ ./docs
	# Only focus.* pages are generated here. Point generated links into
	# OpenTelemetry's docs (other namespaces, notes inherited from GenAI, and
	# the registry index's naming guidance) at the published OpenTelemetry
	# site, and drop the index link to entities, which this registry does not
	# define.
	find docs -name '*.md' -exec sed -i.bak -E \
		-e 's#\(/docs/([a-z0-9/-]+)\.md(\#[a-z0-9-]+)?\)#(https://opentelemetry.io/docs/specs/semconv/\1/\2)#g' \
		-e 's#\(https://opentelemetry.io/docs/specs/semconv/registry/attributes/focus/\)#(/docs/registry/attributes/focus.md)#g' \
		-e 's#\]: \.\./\.\./general/([a-z0-9-]+)\.md#]: https://opentelemetry.io/docs/specs/semconv/general/\1/#g' \
		-e '/^- \[Entities\]\(entities\/README\.md\)$$/d' {} + && find docs -name '*.bak' -delete

## check-docs: fail if generated docs are out of date
check-docs: generate-docs
	git diff --exit-code -- docs || \
		(echo "Generated docs are out of date. Run 'make generate-docs' and commit." && exit 1)

## package: write the resolved registry to ./.build/package
package:
	$(WEAVER) registry package -r ./model --v2 \
		--resolved-registry-uri $(SCHEMA_URI) -o ./.build/package

clean:
	rm -rf ./.build
