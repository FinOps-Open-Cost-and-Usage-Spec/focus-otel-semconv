package after_resolution

import rego.v1

test_passes_for_focus_attributes if {
	count(deny) == 0 with input as {"registry": {"attributes": [
		{"key": "focus.billing_account.id"},
		{"key": "focus.task.id"},
	]}}
}

test_fails_when_otel_attribute_is_redefined if {
	findings := deny with input as {"registry": {"attributes": [
		{"key": "focus.task.id"},
		{"key": "service.name"},
	]}}
	count(findings) == 1
	some f in findings
	f.id == "focus_namespace"
	f.context.attribute == "service.name"
	f.level == "violation"
}

test_fails_for_lookalike_prefix if {
	count(deny) == 1 with input as {"registry": {"attributes": [{"key": "focusx.task.id"}]}}
}

test_ignores_dependency_attributes if {
	count(deny) == 0 with input as {
		"registry": {"attributes": [{"key": "focus.task.id"}]},
		"dependencies": [{"registry": {"attributes": [{"key": "service.name"}]}}],
	}
}
