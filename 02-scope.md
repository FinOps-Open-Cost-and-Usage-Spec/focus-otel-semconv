# Scope

This Working Group develops and maintains FOCUS Semantic Conventions for OpenTelemetry. The registry is a specification of identifiers in the `focus.*` namespace, for use as OpenTelemetry semantic conventions. These identifiers associate OpenTelemetry resources, metrics and traces with cost, usage, and value-attribution / unit-economics data defined by the FinOps Open Cost and Usage Specification (FOCUS) Working Group.

## In scope

1. The names of identifiers in the `focus.*` namespace.
2. The definition of each identifier: its type, allowed values, unit, requirement level, stability status, description and deprecation status.
3. A reference from each identifier to the FOCUS column, requirement, or FOCUS WG-approved companion specification / decision record it relates to. A reference to a column or requirement is given by FOCUS version and requirement ID.
4. The registry's structure, naming rules, and the rules for using the identifiers in OpenTelemetry resources, metrics and traces.

## Out of scope

1. The FOCUS specification itself, including its columns, dataset and normative requirements.
2. OpenTelemetry semantic conventions outside the `focus.*` namespace, and the OpenTelemetry data model, protocol (OTLP), APIs and SDKs.
3. Identifiers in any namespace other than `focus.*`.
4. Methods for generating, collecting, processing, storing, correlating, allocating or analyzing telemetry, cost or usage data.
5. Implementations and tooling, including Weaver templates, code generation and scripts.

Any changes of Scope are not retroactive.
