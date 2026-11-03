# OpenTelemetry concepts

**Status**: [Development][DocumentStatus]

<!-- toc -->

- [Telemetry](#telemetry)
- [Semantic conventions](#semantic-conventions)
- [Tooling](#tooling)
- [How they fit together](#how-they-fit-together)

<!-- tocstop -->

This page explains the OpenTelemetry (OTel) terms these conventions use, for readers who know FOCUS but not OTel. It is non-normative. Two words mean different things in FOCUS and OTel, attribute and resource; [02-scope.md](../../02-scope.md) defines how this repository uses each.

## Telemetry

| Term | Meaning |
|---|---|
| Attribute | A key-value pair on a span, metric, log, or resource, such as `gen_ai.response.model` = `gpt-4o`. Not a FOCUS Attribute. |
| Baggage | Key-value pairs that travel with a request from service to service. Baggage values are not attributes until instrumentation or a processor copies them onto spans. This is how a shared service learns which workload and task it is serving. |
| Cardinality | The number of distinct values an attribute takes. Each distinct combination of attribute values on a metric creates a separate time series, so high-cardinality attributes, such as task IDs, are kept off metrics. |
| Collector | OTel's standalone pipeline that receives telemetry, transforms it, and exports it to backends. Its processors can add or change attributes, for example setting `focus.*` keys from configuration without changing application code. |
| Entity | A typed part of a resource, such as `service.instance` or `cloud`, defined with its own attributes. A newer way of describing resources. |
| Instrumentation | The code that emits telemetry, either in the application or in a library that wraps a framework or SDK, such as an instrumentation library for an AI provider's client. |
| Metric | A numeric measurement aggregated over time, such as tokens used per minute. Metrics usually count every event. |
| OpenTelemetry | An open-source, vendor-neutral standard for producing telemetry, the data a running system emits about its own behavior. It is a Cloud Native Computing Foundation project. Applications instrumented with OTel can send their telemetry to any compatible backend. |
| Resource | The attributes that describe what is emitting telemetry, such as the service name, host, or cloud account. They are attached to everything that source emits. Not a FOCUS Resource. |
| Sampling | Keeping only a share of traces to limit volume. Because traces are usually sampled and metrics are not, exact usage totals come from metrics, and spans supply proportions. |
| Signal | A kind of telemetry. The main signals are traces, metrics, and logs. These conventions define no new signals; they add attributes to existing ones. |
| Span | One timed operation, such as a model call or an agent step, with a name, a start and end time, and attributes. |
| Span kind | The role of a span. A client span is an outgoing call to another service, such as a model provider's API; an internal span is work within one process, such as a workflow or agent step. This registry's [placement rules](placement.md) use this distinction: a called service's billing scope goes on the client span. |
| Trace | The tree of spans that one request produces as it moves through services, linked by a shared trace ID. |

## Semantic conventions

| Term | Meaning |
|---|---|
| Attribute group | A named list of attributes, with no signal of its own. A group can be included in signals, rendered as a table in docs, or used by live-check as the keys a sample may carry. A group can also set each attribute's requirement level, so signals that share a set reference one group instead of repeating it. This registry has three public groups, `attributes.focus.billing_scope`, `attributes.focus.value_attribution`, and `attributes.focus.metric_keys`, and internal groups that its refinements share. |
| Deprecation | How a convention is retired. It is never deleted or reused; it is marked deprecated, usually naming its replacement, and stays in the registry. |
| Federated registry | A registry maintained outside OTel that depends on OTel's registries and adds its own namespace. This repository is one. It needs no OTel approval, but it must not redefine OTel attributes. |
| Namespace | The first segment of an attribute key, such as `gen_ai`, `cloud`, or `focus`. Each namespace has one owner, which defines every key in it. |
| Refinement | One registry's addition to a signal that another registry defines. It adds attributes and their requirement levels without changing the original. For example, `focus.gen_ai.client.inference` refines GenAI's `gen_ai.client.inference` span by adding the billing-scope keys and value-attribution IDs. Instrumentation still emits the original span; the refinement's ID names it in the registry and never appears in telemetry. |
| Registry | A set of conventions written as machine-readable YAML, from which docs and code are generated. OTel's core registry is in [open-telemetry/semantic-conventions](https://github.com/open-telemetry/semantic-conventions), and the GenAI registry is in [open-telemetry/semantic-conventions-genai](https://github.com/open-telemetry/semantic-conventions-genai). |
| Requirement level | How strongly a signal expects an attribute. Required: always set. Conditionally required: set when a stated condition holds. Recommended: set when the value is available. Opt-in: set only when the user turns it on, usually because it is costly or high-cardinality. |
| Semantic conventions (semconv) | Agreed names, types, and meanings for attributes and signals, so that telemetry from different sources means the same thing. For example, every GenAI instrumentation names the model in `gen_ai.response.model`. |
| SIG | A Special Interest Group, one of the working groups that run OTel. The Semantic Conventions (SemConv) SIG oversees conventions as a whole; domain SIGs own their namespaces, as the GenAI SIG owns `gen_ai.*`. |
| Signal definition | A registry entry for a span, metric, event, or entity, giving its name, its kind or instrument, and the attributes it carries. |
| Stability | A convention's maturity, from development to stable. A stable convention cannot change in a breaking way. Everything in this registry is at development stability. |

## Tooling

| Term | Meaning |
|---|---|
| Live-check | A Weaver feature that compares telemetry, real or sample, with the registry and reports keys that are unknown, mistyped, or out of place. See [reference/](../../reference/README.md). |
| Policy | A rule that Weaver applies to a registry, written in the Rego language. This repository runs OTel's naming and stability policies and its own, which rejects any attribute outside `focus.*`. |
| Resolved registry | A registry merged with everything it depends on into one file. A release publishes it, so tools can look up any key the release uses. |
| Schema URL | A versioned URL that telemetry carries to name the registry version it follows. |
| Weaver | OTel's tool for registries. It validates a registry, resolves its dependencies, generates docs and code, and checks telemetry against it. |

## How they fit together

This registry defines eight `focus.*` attributes and references one GenAI attribute, `gen_ai.response.model`. Attribute groups sort them into billing-scope keys and value-attribution IDs. Refinements say which existing signals carry which keys, at which requirement level: the OTel Resource of a billed service, the client spans of billed calls, the internal spans where tasks start, and the token-usage metrics. Instrumentation or a Collector sets the keys, baggage carries the value-attribution IDs to shared services, and Weaver checks the registry and sample telemetry in CI.

[DocumentStatus]: https://opentelemetry.io/docs/specs/otel/document-status
