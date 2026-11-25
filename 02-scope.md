# Scope

This Working Group develops and maintains FOCUS Semantic Conventions for OpenTelemetry. The registry is a specification of identifiers in the `focus.*` namespace, for use as OpenTelemetry semantic conventions. These identifiers associate OpenTelemetry resources, metrics and traces with cost, usage, and value-attribution / unit-economics data defined by the FinOps Open Cost and Usage Specification (FOCUS) Working Group.

## In scope

1. The names of identifiers in the `focus.*` namespace.
2. The definition of each identifier: its type, allowed values, unit, requirement level, stability status, description and deprecation status.
3. A reference from each identifier to the FOCUS column, requirement, or FOCUS WG-approved companion specification it relates to.
   - A reference to a column or requirement is given by FOCUS version and requirement ID.
   - A reference to a companion specification is given by its name and version, together with the FOCUS WG decision record that approved it. For this purpose, a companion specification is one developed and approved under the FOCUS Working Group Charter and published by FOCUS, such as its value-attribution and unit-economics work. A specification from any other body is not a companion specification, and the decision record must be publicly accessible so that the reference can be audited.
4. The registry's structure, naming rules, and the rules for using the identifiers in OpenTelemetry resources, metrics and traces.

## Out of scope

1. The FOCUS specification itself, including its columns, dataset and normative requirements.
2. The FOCUS WG-approved companion specifications themselves, including their data models, requirements and decision records. This registry references them; it does not develop, define or amend them.
3. OpenTelemetry semantic conventions outside the `focus.*` namespace, and the OpenTelemetry data model, protocol (OTLP), APIs and SDKs.
4. Identifiers in any namespace other than `focus.*`.
5. Methods for generating, collecting, processing, storing, correlating, allocating or analyzing telemetry, cost or usage data.
6. Implementations and tooling, including Weaver templates, code generation and scripts.

Any changes of Scope are not retroactive.
