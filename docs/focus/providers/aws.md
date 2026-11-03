# Amazon Web Services

**Status**: [Development][DocumentStatus]

<!-- toc -->

- [Value map](#value-map)
- [Resource IDs by service](#resource-ids-by-service)
- [Open items](#open-items)

<!-- tocstop -->

How to fill the `focus.*` keys so telemetry from AWS workloads joins to the AWS [FOCUS export](https://docs.aws.amazon.com/cur/latest/userguide/table-dictionary-focus-1-2-aws.html). This page is non-normative. Values marked **unconfirmed** have not been checked against a real export.

## Value map

| Attribute | FOCUS column | AWS value | Runtime source | Related OTel attribute |
|---|---|---|---|---|
| `focus.service_provider.name` | ServiceProviderName | **Unconfirmed.** The AWS FOCUS 1.2 export documents ProviderName, not ServiceProviderName, and gives no literal value | Configuration | `cloud.provider` (`aws`), a fixed ID that is not the bill's display value |
| `focus.billing_account.id` | BillingAccountId | **Unconfirmed:** expected to be the management (payer) account ID | Configuration; the Organizations API is callable only from the management account | None |
| `focus.sub_account.id` | SubAccountId | **Unconfirmed:** expected to be the member account ID that owns the resource | Resource detectors | `cloud.account.id`, the same account. Set both even if the values match |
| `focus.resource.id` | ResourceId | **Unconfirmed:** expected to be the resource ARN | Derived from detector values; see [below](#resource-ids-by-service) | `cloud.resource_id`, which names the monitored resource |
| `focus.service.name` | ServiceName | **Unconfirmed:** expected to be the full service name, such as `Amazon Bedrock` | Configuration, or a lookup from the detected platform | `cloud.platform` (`aws_ecs`), a fixed ID that is not the bill's display value |
| `gen_ai.response.model` | SkuPriceDetails.ModelId | **Unconfirmed** for Bedrock | Bedrock instrumentation | Itself |

## Resource IDs by service

The billed resource can differ from the one telemetry describes. Each rule derives `focus.resource.id` from what detectors report. All are **unconfirmed** against the export.

| Service | Telemetry reports | Billed resource | Rule |
|---|---|---|---|
| AWS Lambda | `cloud.resource_id`: the function ARN, which can include a version or alias | The function | Strip the version or alias suffix |
| Amazon ECS | Task, container, or instance ARNs (`aws.ecs.*`) | Depends on the launch type: Fargate tasks are billed per task; EC2 launch bills the instances | Use the task ARN on Fargate and the EC2 instance ID otherwise |
| Amazon EKS | Pods and nodes (`k8s.*`, `host.id`) | The cluster and its nodes | Use the cluster ARN for the control plane and the instance ID for nodes; pod-level cost is allocation, not a join |
| Amazon Bedrock, on-demand | `gen_ai.*` on the client span | No resource; billed by service and model | Leave `focus.resource.id` unset |
| Amazon Bedrock, provisioned throughput | The provisioned model ARN in the request | The provisioned model | Use the provisioned model ARN |

## Open items

- Confirm each **unconfirmed** value against a FOCUS export.
- Confirm whether `cloud.account.id` always equals SubAccountId for AWS. That is evidence toward one of the [open questions](../README.md#open-questions): `focus.sub_account.id` can be deprecated in favor of `cloud.account.id` only once the two match for every provider, never provider by provider.
- The AWS export follows FOCUS 1.2, which predates ServiceProviderName. Joins on `focus.service_provider.name` need ProviderName as a stand-in until AWS publishes a later version.

[DocumentStatus]: https://opentelemetry.io/docs/specs/otel/document-status
