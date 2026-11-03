# Reference telemetry

Sample telemetry that follows the `focus.*` conventions, checked against the registry with [Weaver live-check](https://github.com/open-telemetry/weaver/tree/main/crates/weaver_live_check). It is modeled on the [GenAI reference implementations](https://github.com/open-telemetry/semantic-conventions-genai/tree/main/reference), which validate real client libraries the same way.

| Path | Contents |
|---|---|
| [samples/support-bot.json](samples/support-bot.json) | The [support-bot worked example](../docs/focus/non-normative/examples-support-bot.md) as telemetry: the bot's OTel Resource, an OpenAI inference span and an input-token metric |
| [.weaver.toml](.weaver.toml) | Live-check matchers and finding filters |

Run it with:

```bash
make live-check
```

CI runs the same check on every pull request.

## What is checked

The check fails on any violation:

- a `focus.*` key that is not in the registry, such as `focus.task_id`;
- a `focus.*` value of the wrong type.

It reports, without failing:

- an OpenTelemetry attribute outside the `focus.*` groups, such as `gen_ai.operation.name`;
- a task or outcome ID on a metric, which [placement rule 4](../docs/focus/placement.md#rules) forbids. Weaver cannot yet raise one attribute's finding to a violation.

## Limits

Weaver 0.28 does not match telemetry to refinements. Live-check finds no span type or metric for `focus.gen_ai.client.inference` or the token-usage refinements, so samples are compared with the `focus.*` attribute groups instead. As a result, requirement levels from the refinements are not enforced: a span missing `focus.service_provider.name` passes. When Weaver resolves refinements, the matchers should name them as signals.

## Adding a sample

Add a JSON file under `samples/` in [live-check's sample format](https://github.com/open-telemetry/weaver/tree/main/crates/weaver_live_check), and add it to the `live-check` target in the [Makefile](../Makefile). An implementation, such as a gateway or Collector configuration, can contribute telemetry it actually emitted, which shows which `focus.*` keys it supports.
