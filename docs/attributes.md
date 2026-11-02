# `focus.*` attributes

<!-- Hand-maintained until the Working Group's Weaver templates (kept in a separate
repository) generate this page. The source of truth is model/focus/registry.yaml. -->

The registry carries join keys only: the values telemetry needs to find its charge or its task. Region, price, cost and quantities come from the charge once the join is made. All attributes are type `string` at `development` stability.

A `focus.*` attribute carries the value of a FOCUS column on an OpenTelemetry signal. It has nothing to do with FOCUS Attributes.

## Cost and Usage scope

These locate a telemetry record's charge in the FOCUS Cost and Usage dataset. FOCUS references are to FOCUS 1.4.

| Attribute | FOCUS column (section) | Nearest OTel attribute | Status |
|---|---|---|---|
| `focus.service_provider.name` | ServiceProviderName (3.1.54) | `cloud.provider` (fixed cloud list) | Define |
| `focus.billing_account.id` | BillingAccountId (3.1.8) | None | Define |
| `focus.sub_account.id` | SubAccountId (3.1.62) | `cloud.account.id` | Open: reuse if bill-exact |
| `focus.resource.id` | ResourceId (3.1.51) | `cloud.resource_id` (monitored, not billed) | Open: define unless OTel adds a billing-level ID |
| `focus.service.name` | ServiceName (3.1.56) | `service.name` (different concept) | Define |
| `gen_ai.response.model` | SkuPriceDetails.ModelId (FOCUS 1.5) | Itself | Reused, not a `focus.*` attribute |

Every join starts from the provider and billing account. Each charge then has at most one finer key: the resource, when the charge is tied to one; the model, for pay-per-token usage, where ResourceId is null; or neither, as with a support plan or SaaS seat, where the join stops at the service.

## Value scope

These link a telemetry record to the Task, Outcome and Value datasets of the FOCUS companion specification *Value Attribution Data Architecture: Schema and Explainer* (v0.1.4).

| Attribute | Links to | On metrics? | Status |
|---|---|---|---|
| `focus.workload.id` | All datasets, for portfolio rollups | Yes | Define, pending SemConv SIG review |
| `focus.task.id` | Task dataset | No | Define |
| `focus.outcome.id` | Outcome dataset, and Value through it | No | Define, optional on spans |

## Attribute groups

| Group | Members |
|---|---|
| `attributes.focus.billing_scope` | The five Cost and Usage keys and `gen_ai.response.model` |
| `attributes.focus.value_attribution` | `focus.workload.id`, `focus.task.id`, `focus.outcome.id` |

## Naming

Take the FOCUS column, split off its final property word (Id, Name) as the last segment, and write the rest in snake_case: `BillingAccountId` becomes `focus.billing_account.id`. Anyone who knows FOCUS can predict the attribute name.

## Reuse decisions

The registry reuses an OTel attribute wherever its meaning and its values match the bill, and defines a `focus.*` attribute only where they do not:

1. **Reuse** when the concept and the values match (`gen_ai.response.model`).
2. **Define** a distinct attribute when the word matches but the concept differs (`focus.service.name`).
3. **Negotiate** with the SemConv SIG when the concept matches but the scope or format differs (`focus.sub_account.id`, `focus.resource.id`).

The obstacle in the third case is exactness, not the `cloud.*` namespace. Where a `cloud.*` attribute can guarantee bill-exact values, FOCUS reuses it and deprecates the `focus.*` attribute, so providers emit one attribute, not two.
