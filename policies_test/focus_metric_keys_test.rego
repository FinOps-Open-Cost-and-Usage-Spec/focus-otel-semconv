package after_resolution

import rego.v1

test_passes_for_allowed_metric_keys if {
	count(deny) == 0 with input as {
		"registry": {"attributes": []},
		"refinements": {"metrics": [{"id": "focus.gen_ai.client.inference.usage.input_tokens", "attributes": [
			{"key": "focus.service_provider.name"},
			{"key": "focus.billing_account.id"},
			{"key": "focus.service.name"},
			{"key": "focus.workload.id"},
			{"key": "gen_ai.response.model"},
		]}]},
	}
}

test_fails_for_task_id_on_metric if {
	findings := deny with input as {
		"registry": {"attributes": []},
		"refinements": {"metrics": [{"id": "focus.test.metric", "attributes": [
			{"key": "focus.workload.id"},
			{"key": "focus.task.id"},
		]}]},
	}
	count(findings) == 1
	some f in findings
	f.id == "focus_metric_key"
	f.context.attribute == "focus.task.id"
	f.context.metric_refinement == "focus.test.metric"
	f.level == "violation"
}

test_fails_for_outcome_and_resource_ids_on_metric if {
	count(deny) == 2 with input as {
		"registry": {"attributes": []},
		"refinements": {"metrics": [{"id": "focus.test.metric", "attributes": [
			{"key": "focus.outcome.id"},
			{"key": "focus.resource.id"},
		]}]},
	}
}

test_ignores_span_refinements if {
	count(deny) == 0 with input as {
		"registry": {"attributes": []},
		"refinements": {
			"spans": [{"id": "focus.test.span", "attributes": [{"key": "focus.task.id"}, {"key": "focus.resource.id"}]}],
			"metrics": [],
		},
	}
}
