# Scope

This Working Group develops and maintains FOCUS Semantic Conventions for OpenTelemetry. The registry is a specification of conventions in the `focus.*` namespace, for use as OpenTelemetry semantic conventions. These conventions associate OpenTelemetry resources, metrics and spans with cost, usage, and value-attribution / unit-economics data defined by the FinOps Open Cost and Usage Specification (FOCUS) Working Group.

## Terminology

- **Attribute:** as in OpenTelemetry, a named field on a resource, span or metric.
- **FOCUS Attribute:** as in FOCUS, a set of requirements that applies across columns and datasets. This document always writes it in full and capitalized, never as "attribute" alone.
- **Convention:** anything this registry defines, such as an attribute.
- **Placement rule:** a rule for which OpenTelemetry signals carry which `focus.*` attributes, such as "only low-cardinality keys go on metrics." The term is this registry's own, not OpenTelemetry's. The rules are listed in [docs/focus/placement.md](docs/focus/placement.md).

## In scope

1. The names of conventions in the `focus.*` namespace.
2. The definition of each convention: its type, allowed values, unit, requirement level, stability status, description and deprecation status.
3. A reference from each convention to the FOCUS column, FOCUS Attribute, requirement, or FOCUS WG-approved companion specification it relates to.
   - A reference to a column, FOCUS Attribute or requirement is given by FOCUS version and requirement ID.
   - A reference to a companion specification is given by its name and version, together with the FOCUS WG decision record that approved it. For this purpose, a companion specification is one developed and approved under the FOCUS Working Group Charter and published by FOCUS, such as its value-attribution and unit-economics work. A specification from any other body is not a companion specification, and the decision record must be publicly accessible so that the reference can be audited.
4. The registry's structure, naming rules, and the rules for using its attributes (placement rules) in OpenTelemetry resources, metrics and spans.

## Out of scope

1. The FOCUS specification itself, including its columns, FOCUS Attributes, dataset and normative requirements.
2. The FOCUS WG-approved companion specifications themselves, including their data models, requirements and decision records. This registry references them; it does not develop, define or amend them.
3. OpenTelemetry semantic conventions outside the `focus.*` namespace, and the OpenTelemetry data model, protocol (OTLP), APIs and SDKs.
4. Conventions in any namespace other than `focus.*`.
5. Methods for generating, collecting, processing, storing, correlating, allocating or analyzing telemetry, cost or usage data.
6. Implementations and tooling, including Weaver templates, code generation and scripts.

Any changes of Scope are not retroactive.
