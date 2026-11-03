# Changelog

All notable changes to the `focus.*` registry are recorded here. Each release states the FOCUS specification versions it references.

## Unreleased

### Added

- Initial draft registry, at `development` stability and not yet approved by the FOCUS WG:
  - Cost and Usage scope: `focus.service_provider.name`, `focus.billing_account.id`, `focus.sub_account.id`, `focus.resource.id`, `focus.service.name` (FOCUS 1.4); `gen_ai.response.model` reused for SkuPriceDetails.ModelId (FOCUS 1.5).
  - Value scope: `focus.workload.id`, `focus.task.id`, `focus.outcome.id` (*Value Attribution Data Architecture: Schema and Explainer* v0.1.4).
  - Refinements of the core `service.instance` entity, `gen_ai.client.inference`, and the GenAI input, output, cache-read, cache-write and reasoning token-usage metrics.
- Docs in OpenTelemetry's format: a Weaver-generated attribute registry and convention pages with generated tables, using the core semantic-conventions v1.45.0 Markdown templates.
- Weaver check workflow with OpenTelemetry naming and stability policies, plus a `focus.*` namespace policy that rejects redefinition of OpenTelemetry attributes, with OPA unit tests.
- Reference telemetry for the support-bot example, checked with Weaver live-check in CI.
- Non-normative provider mapping pages, starting with AWS.
- Draft release steps in `RELEASING.md`.
