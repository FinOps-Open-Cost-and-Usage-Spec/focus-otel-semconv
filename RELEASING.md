# Releasing

**Status:** draft. The Working Group defines the versioning and release policy before the first release (see [Releases](README.md#releases)). This page records the mechanics, following the [core](https://github.com/open-telemetry/semantic-conventions/blob/main/RELEASING.md) and [GenAI](https://github.com/open-telemetry/semantic-conventions-genai/blob/main/RELEASING.md) semantic-convention repositories.

## Before the first release

- [ ] The Working Group approves a versioning policy. Semantic versioning starting at `0.1.0` is the working assumption.
- [ ] FOCUS chooses a host for schema files, so that `schema_url` in [model/manifest.yaml](model/manifest.yaml) resolves. It is a placeholder today.
- [ ] Dependencies are pinned to released versions where they exist. The GenAI registry has no release tags yet and is pinned to a commit.

## Steps

1. Open a pull request that:
   - sets `schema_url` in [model/manifest.yaml](model/manifest.yaml) and `SCHEMA_URI` in the [Makefile](Makefile) to the new version;
   - moves the `Unreleased` entries in [CHANGELOG.md](CHANGELOG.md) under the version and date, and states the FOCUS specification versions the release references;
   - passes CI, including `make check`, `make test-policies`, `make live-check` and `make check-docs`.
2. After consensus and merge, the Maintainer tags the merge commit `vX.Y.Z` and creates a GitHub release with:
   - the resolved registry from `make package` (`.build/package/manifest.yaml` and `resolved.yaml`);
   - the Community Specification License terms, the required attribution and the disclaimer (Governance §4.3, §4.4).
3. Publish the resolved registry at the version's `schema_url`, so that telemetry carrying that schema URL can be traced to its definitions.

## After a release

- Open the next `Unreleased` section in the changelog.
- Announce the release to the FOCUS WG and the OpenTelemetry Semantic Conventions SIG.
