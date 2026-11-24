package after_resolution

import rego.v1

# Rule 4 in docs/focus/where-attributes-go.md: only low-cardinality keys go on
# metrics. Task and outcome IDs take one value per task, and a resource ID set
# on each measurement multiplies series within one process; the resource ID
# reaches metrics only through the emitting service's OTel Resource.
#
# input.refinements.metrics holds this registry's metric refinements. Live-check
# enforces the same rule on sample telemetry; this policy enforces it on the
# registry itself.

forbidden_metric_keys := {"focus.task.id", "focus.outcome.id", "focus.resource.id"}

deny contains finding if {
    some metric in input.refinements.metrics
    some attr in metric.attributes
    attr.key in forbidden_metric_keys

    finding := {
        "id": "focus_metric_key",
        "context": {
            "attribute": attr.key,
            "metric_refinement": object.get(metric, "id", ""),
        },
        "message": sprintf("Attribute '%s' must not be set on metric refinement '%s'. Only billing-scope keys other than focus.resource.id, and focus.workload.id, may be set on metric data points.", [attr.key, object.get(metric, "id", "")]),
        "level": "violation",
    }
}
