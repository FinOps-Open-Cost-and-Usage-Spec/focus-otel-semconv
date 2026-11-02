# Placement rules

**Status**: [Development][DocumentStatus]

<!-- toc -->

- [Rules](#rules)
- [When IDs are known](#when-ids-are-known)
- [From telemetry to the Telemetry dataset](#from-telemetry-to-the-telemetry-dataset)

<!-- tocstop -->

The registry defines no new signals. These rules say where `focus.*` attributes go on signals OpenTelemetry already defines. None of them names a workload type; a workload such as "support bot" is only a value. Signal-specific rules are written as refinements in the model; see [FOCUS attributes on GenAI signals](gen-ai.md).

## Rules

1. **Billing scope of the emitting service goes on the OTel Resource.** When a process is itself a billed resource (a container service, a VM), its billing-scope keys go on its OTel Resource, so every span, metric and log it emits carries them.
2. **Billing scope of a called service goes on the client span.** When a process calls a billed API or SaaS (a model provider, a managed database), that call's billing-scope keys go on the client span for the call, not on the caller's OTel Resource.
3. **Value-attribution IDs go on spans and travel in baggage.** `focus.workload.id`, `focus.task.id` and `focus.outcome.id` MAY be set on any span doing work for a task, and SHOULD be propagated in OTel baggage so shared services (a central search index, a guardrail service) attribute their work to the caller. `focus.outcome.id` is optional, since outcomes are usually linked later.
4. **Only low-cardinality keys go on metrics.** Billing-scope keys and `focus.workload.id` MAY be set on metrics. `focus.task.id` and `focus.outcome.id` MUST NOT be, since one value per task would create unbounded metric series.

## When IDs are known

The rules assume an ID is known when the span is created. That holds for some IDs and not others.

- **`focus.workload.id`:** almost always known at runtime, since it is set by configuration.
- **`focus.task.id`:** usually known at runtime, because it is typically an existing business key such as a ticket, pull request or job ID. When it is not, it is linked afterward by mapping an attribute the span already carries, such as the trace ID or a business key, to the task in the Task dataset.
- **`focus.outcome.id`:** often not known at runtime, because outcomes are verified later, such as a deflection confirmed days afterward or a pull request that survives its SLA window. It is linked through the Task dataset, which records each task's OutcomeId.

Linking after the fact means joining downstream, not editing telemetry. Exported spans cannot change, so late links are made at ingest, through Collector or backend enrichment from a lookup, or in the Telemetry dataset. Spans that are never linked roll up as `UNLINKED_SCRAP`.

The practical minimum at runtime is therefore `focus.workload.id` and `focus.task.id`. `focus.outcome.id` is needed on spans only for a direct path from telemetry to outcomes, used when a team does not track tasks.

## From telemetry to the Telemetry dataset

Spans are not joined to the bill one by one. They are aggregated into the Telemetry dataset, proposed for FOCUS 1.6 in the companion specification, which joins to cost, tasks and outcomes.

- **Grain:** leaf inference and tool spans are rolled up into hourly or daily windows, and span and trace IDs are dropped.
- **Keys:** each row is grouped by the billing-scope keys, the model and the value-attribution IDs, over a window aligned to the FOCUS charge period.
- **Measures:** traces are usually sampled and metrics are not, so exact usage totals come from metrics labeled by workload and billing scope, while sampled spans supply per-task proportions.
- **Joins:** rows join to Cost and Usage on the billing-scope keys and charge period, and to Task and Outcome on `focus.task.id` and `focus.outcome.id`. EffectiveCost is then apportioned across the tasks sharing a scope.
- **Unlinked work:** spans with no task ID roll up with TaskId and OutcomeId set to `UNLINKED_SCRAP`, so all cost still reconciles.

Weighting and apportionment formulas are out of scope for this registry. They belong to the companion specification.

[DocumentStatus]: https://opentelemetry.io/docs/specs/otel/document-status
