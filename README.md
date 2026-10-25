# FOCUS Identifiers Registry (`focus.*`)

This repository is the official registry of `focus.*` identifiers: OpenTelemetry semantic-convention identifiers that link OpenTelemetry telemetry (metrics, traces and resources) to [FOCUS](https://focus.finops.org) cost and usage data. Registering identifiers here does not change the FOCUS dataset itself.

FOCUS owns the meaning of each identifier. The OpenTelemetry Semantic Conventions SIG reviews each identifier to make sure it is consistent with OpenTelemetry conventions and tooling (Weaver).

The registry is developed under the [Community Specification](https://github.com/CommunitySpecification/1.0) process of the Joint Development Foundation.

## Scope

This registry covers the `focus.*` namespace only. Identifiers in any other namespace are out of scope and will not be registered here.

The full Scope is in [02-scope.md](02-scope.md). That file is the "Scope.md" that the Community Specification License (§9.13) refers to, and it sets the limits of the patent commitments made under that License.

## How a `focus.*` identifier is registered

1. **FOCUS WG approval.** The FOCUS Working Group agrees on the identifier through its own process, which runs outside this repository.
2. **Issue.** The FOCUS Program Manager opens an issue in this repository for the approved identifier, linking the FOCUS WG decision record.
3. **Pull request.** The Program Manager opens a pull request to `main`, linked to the issue. The pull request describes the identifier, its rationale, compatibility considerations and the related FOCUS requirement, cited by FOCUS version and requirement ID. FOCUS specification text is referenced, not copied. The pull request must confirm the Contributor License Agreement (see [Contributing](#contributing)).
4. **Automated checks.** GitHub Actions validates the pull request: CLA confirmation, schema compliance, uniqueness, references and the other registry rules.
5. **OpenTelemetry review.** OpenTelemetry reviewers check the identifier for consistency with OpenTelemetry conventions. They are expected to review it within 7 days of submission. **If the reviewers do not agree, the pull request is blocked** and the Maintainers resolve it (see [Decisions and appeals](#decisions-and-appeals)).
6. **Editor approval and merge.** Once the reviewers agree, an Editor approves and merges the pull request. Merging is blocked without Editor approval.

**A merged pull request is an official registration.** Once merged, the identifier is registered in the FOCUS Identifiers Registry, and `main` is always the authoritative registry.

Every decision is recorded in the issue or pull request, including decisions taken in meetings, so each registration has an auditable history.

## Participating

Anyone can take part in this repository.

| You want to… | How | CLA needed? |
|---|---|---|
| Ask a question or report a problem | Open a **Discussion or question** issue | No |
| Propose a new `focus.*` identifier | Open an **Identifier proposal** issue. The proposal is sent to the FOCUS WG, which decides whether to approve it. Pull requests for new identifiers come only from the FOCUS Program Manager, after FOCUS WG approval. | No |
| Review or comment on a pull request | Comment on the pull request | No |
| Fix an editorial or repository issue (typos, documentation, CI) | Open a pull request | Yes, via the PR checkbox |

Comments and reviews are not Contributions. If reviewers' ideas are adopted, they are written into the registry in the submitter's own words, not by copying the reviewer's text.

### Issue forms

All issues are opened through one of the following forms. Blank issues are disabled, so every issue records the information needed to act on it.

| Form | Who uses it | Purpose | Label | Title prefix |
|---|---|---|---|---|
| [Identifier registration](.github/ISSUE_TEMPLATE/01-identifier-registration.yaml) | FOCUS Program Manager only | Register, change or deprecate a `focus.*` identifier already approved by the FOCUS WG | `spec change` | `Spec Change:` |
| [Identifier proposal](.github/ISSUE_TEMPLATE/02-identifier-proposal.yaml) | Anyone | Suggest a new `focus.*` identifier for the FOCUS WG to consider | `proposal` | `Proposal:` |
| [Discussion or question](.github/ISSUE_TEMPLATE/03-discussion.yaml) | Anyone | Questions, editorial or repository problems, and governance or process topics | `discussion` | `Discussion:` |

These forms follow the three issue types in the [Contribution Policy](06-contributing.md) (§1.1.1). Registration issues opened by anyone other than the FOCUS Program Manager will be closed and can be resubmitted as an Identifier proposal.

Code of Conduct concerns should not be raised in a public issue. Contact the people listed in [03-notices.md](03-notices.md#code-of-conduct) instead.

## Contributing

This repository does not use a CLA bot. Instead, **every pull request must tick the Contributor License Agreement checkbox** in the pull request template, confirming that:

- the contribution is made under the [Community Specification Contributor License Agreement](00-contributor-license-agreement.md), and
- the contributor is authorized to make it, including on behalf of their employer where applicable.

Pull requests without a ticked checkbox will not be reviewed or merged. By making a Contribution, you agree to the [Community Specification License](01-community-specification-license-v1.md), the [Governance Policy](05-governance.md), the [Contribution Policy](06-contributing.md) and the [Code of Conduct](08-code-of-conduct.md).

## Roles

| Role | Who | Responsibilities |
|---|---|---|
| Maintainers | _[To be named]_ | Organize the work, determine consensus, resolve blocked or disputed pull requests, and handle appeals |
| Editors | [@FinOps-Open-Cost-and-Usage-Spec/focusID-editors](https://github.com/orgs/FinOps-Open-Cost-and-Usage-Spec/teams/focusID-editors) | Make sure the registry reflects the decisions made, enforce formatting and content conventions, and approve and merge pull requests |
| OpenTelemetry reviewers | _[To be named]_ | Review identifiers for consistency with OpenTelemetry semantic conventions |
| FOCUS Program Manager | _[To be named]_ | Submit FOCUS WG-approved identifiers as issues and pull requests |

New or additional Maintainers and Editors are selected with the approval of the Working Group Participants (Governance §1.1, §1.2).

## Decisions and appeals

The Maintainers make the final decision on blocked or disputed pull requests. They decide after considering the Participants' views in good faith, and they record their reasoning in writing on the issue or pull request (Governance §2.1).

When the OpenTelemetry reviewers block a pull request, the Maintainers will do one of the following:

- send the identifier back to the FOCUS WG, if resolving the objection would change what the FOCUS WG approved;
- approve an editorial change that resolves the objection without changing the identifier's meaning; or
- decide, with written reasoning, that the objection does not prevent registration.

Any decision may be appealed by opening an issue. The Maintainers will respond in writing within a reasonable time (Governance §2.2).

## Changes and deprecation

The Working Group will define the process for changing and deprecating identifiers. Until then, these principles apply:

- Registered identifiers are never deleted or reused. They can only be deprecated.
- A change in an identifier's meaning requires a new identifier. The old one is deprecated and points to its replacement.
- Stability and deprecation follow OpenTelemetry semantic-convention practice.

## Licensing

- **Specification content.** This includes the `focus.*` identifier definitions and their descriptions. It is licensed under the [Community Specification License 1.0](01-community-specification-license-v1.md).
- **Source code.** Any source code in this repository is licensed under the MIT License unless otherwise marked. Supporting tooling, such as Weaver templates and scripts, is kept in a separate repository.
- If the two licenses conflict, the Community Specification License applies.

See [04-license.md](04-license.md) for details.

Derivative works based on this registry must credit the FOCUS Identifiers Registry Working Group, including the material's name, version and source (License §1.2). Implementations do not need to give this credit.

## Notices

Code-of-conduct contacts, implementer license acceptances, withdrawals and patent exclusion notices are recorded in [03-notices.md](03-notices.md).

## Disclaimer

THESE MATERIALS ARE PROVIDED "AS IS." The Contributors and Licensees expressly disclaim any warranties (express, implied, or otherwise), including implied warranties of merchantability, non-infringement, fitness for a particular purpose, or title, related to the materials. The entire risk as to implementing or otherwise using the materials is assumed by the implementer and user. IN NO EVENT WILL THE CONTRIBUTORS OR LICENSEES BE LIABLE TO ANY OTHER PARTY FOR LOST PROFITS OR ANY FORM OF INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES OF ANY CHARACTER FROM ANY CAUSES OF ACTION OF ANY KIND WITH RESPECT TO THIS DELIVERABLE OR ITS GOVERNING AGREEMENT, WHETHER BASED ON BREACH OF CONTRACT, TORT (INCLUDING NEGLIGENCE), OR OTHERWISE, AND WHETHER OR NOT THE OTHER MEMBER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
