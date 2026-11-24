# Provider mappings

**Status**: [Development][DocumentStatus]

The `focus.*` attributes are provider-neutral. What differs by provider is how to fill them: which value matches that provider's FOCUS export, where instrumentation can find it at runtime, and which billed resource stands behind the monitored one. These non-normative pages record that mapping, one per provider.

- [Amazon Web Services](aws.md)

Each page has the same two parts: a value map for each key, and resource-ID rules by service. Values marked **unconfirmed** have not been checked against the provider's export. Providers are invited to confirm them, or to report a mismatch, through a [Discussion or question](../../../.github/ISSUE_TEMPLATE/03-discussion.yaml) issue.

[DocumentStatus]: https://opentelemetry.io/docs/specs/otel/document-status
