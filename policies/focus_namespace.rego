package after_resolution

import rego.v1

# Every attribute this registry defines must be in the focus.* namespace
# (02-scope.md, Out of scope, item 4). Because no OpenTelemetry attribute uses
# that namespace, this also stops the registry from redefining one; reuse an
# OpenTelemetry attribute with `ref` instead.
#
# input.registry holds only this registry's own definitions. Attributes from
# dependency registries are under input.dependencies and are not checked.

deny contains finding if {
    some attr in input.registry.attributes
    not startswith(attr.key, "focus.")

    finding := {
        "id": "focus_namespace",
        "context": {
            "attribute": attr.key,
        },
        "message": sprintf("Attribute '%s' is outside the focus.* namespace. Define only focus.* attributes; reuse an OpenTelemetry attribute with `ref`.", [attr.key]),
        "level": "violation",
    }
}
