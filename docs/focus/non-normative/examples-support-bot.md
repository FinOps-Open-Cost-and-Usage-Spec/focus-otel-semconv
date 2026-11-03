# Worked example: a support bot

**Status**: [Development][DocumentStatus]

A support bot running on AWS handles ticket 4417 and calls OpenAI. Its telemetry joins to two different bill rows by two different routes, then links onward to the task. Values are illustrative.

## AWS row: the bot's own service

The bot's own service is a billed resource, so its keys sit on its OTel Resource ([rule 1](../placement.md#rules)) and the join uses provider, account, and resource.

```yaml
# OTel Resource of the bot
service.name: support-bot
focus.service_provider.name: Amazon Web Services
focus.billing_account.id: "123456789012"
focus.sub_account.id: "210987654321"
focus.resource.id: arn:aws:ecs:us-east-1:210987654321:service/support/bot
focus.service.name: Amazon Elastic Container Service
```

## OpenAI row: the model call

Pay-per-token usage has no ResourceId, so the client span carries provider, billing account, and service ([rule 2](../placement.md#rules)), and `gen_ai.response.model` matches SkuPriceDetails.ModelId on the bill. The value-attribution IDs ride on the same span ([rule 3](../placement.md#rules)).

```yaml
# gen_ai.client.inference span for the OpenAI call
gen_ai.operation.name: chat
gen_ai.response.model: gpt-5-2025-08-07
focus.service_provider.name: OpenAI
focus.billing_account.id: org-AbC123
focus.service.name: OpenAI API
focus.workload.id: support-bot
focus.task.id: ticket-4417
```

The token-usage metric for the same call carries no task or outcome ID ([rule 4](../placement.md#rules)).

```yaml
# gen_ai.client.inference.usage.input_tokens metric
focus.service_provider.name: OpenAI
focus.billing_account.id: org-AbC123
focus.service.name: OpenAI API
focus.workload.id: support-bot
```

## Onward to value

`focus.task.id` on the spans links to the Task dataset, then to Outcome and Value. If the deflection for ticket 4417 is confirmed days later, the Task dataset records its OutcomeId; the spans are not edited.

[DocumentStatus]: https://opentelemetry.io/docs/specs/otel/document-status
