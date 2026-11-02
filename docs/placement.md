# Placement rules

The registry defines no new signals. These rules say where `focus.*` attributes go on signals OpenTelemetry already defines. Signal-specific rules are written as refinements in [model/focus/refinements.yaml](../model/focus/refinements.yaml) and are proposals until agreed with the owning SIG.

## Rules

1. **Billing scope of the emitting service goes on the OTel Resource.** When a process is itself a billed resource (a container service, a VM), its billing-scope keys go on its OTel Resource, so every span, metric and log it emits carries them.
2. **Billing scope of a called service goes on the client span.** When a process calls a billed API or SaaS (a model provider, a managed database), that call's billing-scope keys go on the client span, not on the caller's OTel Resource.
3. **Value-attribution IDs go on spans and travel in baggage.** `focus.workload.id`, `focus.task.id` and `focus.outcome.id` may be set on any span doing work for a task, and are propagated in OTel baggage so shared services (a search index, a guardrail service) attribute their work to the caller.
4. **Only low-cardinality keys go on metrics.** Billing-scope keys and `focus.workload.id` may be set on metrics. `focus.task.id` and `focus.outcome.id` must not be.

| Refinement | Refines | Adds |
|---|---|---|
| `focus.gen_ai.client.inference` | `gen_ai.client.inference` span | Billing scope and value-attribution IDs |
| `focus.gen_ai.client.inference.usage.input_tokens` | Input-token usage metric | Provider, billing account, service, workload |
| `focus.gen_ai.client.inference.usage.output_tokens` | Output-token usage metric | Provider, billing account, service, workload |

## When IDs are known

| ID | Known at runtime? | If not |
|---|---|---|
| `focus.workload.id` | Almost always, from configuration | |
| `focus.task.id` | Usually, as an existing business key | Map a trace ID or business key to the task in the Task dataset |
| `focus.outcome.id` | Often not, since outcomes are verified later | Link through the Task dataset's OutcomeId |

Value is never part of telemetry. Late links are made by joining downstream, at ingest or in the Telemetry dataset, never by editing exported spans. Spans never linked to a task roll up as `UNLINKED_SCRAP`, so all cost still reconciles.

## Worked example

A support bot on AWS handles ticket 4417 and calls OpenAI. Values are illustrative.

```yaml
# OTel Resource of the bot (rule 1): joins the AWS charge on provider, account and resource
service.name: support-bot
focus.service_provider.name: Amazon Web Services
focus.billing_account.id: "123456789012"
focus.sub_account.id: "210987654321"
focus.resource.id: arn:aws:ecs:us-east-1:210987654321:service/support/bot

---
# gen_ai.client.inference span for the OpenAI call (rules 2 and 3):
# pay-per-token, so no resource; the model is the finest key
gen_ai.operation.name: chat
gen_ai.response.model: gpt-5-2025-08-07
focus.service_provider.name: OpenAI
focus.billing_account.id: org-AbC123
focus.service.name: OpenAI API
focus.workload.id: support-bot
focus.task.id: ticket-4417

---
# gen_ai.client.inference.usage.input_tokens metric (rule 4): no task or outcome ID
focus.service_provider.name: OpenAI
focus.billing_account.id: org-AbC123
focus.service.name: OpenAI API
focus.workload.id: support-bot
```

Spans are not joined to the bill one by one. They are aggregated into the Telemetry dataset, keyed by billing scope, model and value-attribution IDs over a window aligned to the FOCUS charge period. Unsampled metrics supply exact usage totals; sampled spans supply per-task proportions.
