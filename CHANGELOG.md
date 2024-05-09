<!-- SPDX-License-Identifier: CC0-1.0 -->

# Changelog

All notable changes to _Tool Versions Update Action_ will be documented in this
file.

The format is based on [Keep a Changelog], and this project adheres to [Semantic
Versioning].

## [Unreleased]

### `tool-versions-update-action`

- Fix failures due to tool updates that change the length of a version string.

### `tool-versions-update-action/commit`

- Bump `actions/checkout` from v4.1.3 to v4.1.5.
- Fix failures due to tool updates that change the length of a version string.

### `tool-versions-update-action/pr`

- Bump `actions/checkout` from v4.1.3 to v4.1.5.
- Bump `peter-evans/create-pull-request` from v6.0.4 to v6.0.5.
- Fix failures due to tool updates that change the length of a version string.

## [1.1.2] - 2024-04-23

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Bump `actions/checkout` from v4.1.1 to v4.1.3.
- Bump `stefanzweifel/git-auto-commit-action` from v5.0.0 to v5.0.1.

### `tool-versions-update-action/pr`

- Bump `actions/checkout` from v4.1.1 to v4.1.3.
- Bump `peter-evans/create-pull-request` from v6.0.0 to v6.0.4.

## [1.1.1] - 2024-02-03

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- _Version bump only._

### `tool-versions-update-action/pr`

- Bump `peter-evans/create-pull-request` from v5.0.2 to v6.0.0.

## [1.1.0] - 2024-01-26

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Add support for templating to the input `branch`.

### `tool-versions-update-action/pr`

- Add input `rebase-strategy` to configure when Pull Requests are rebased.
- Add support for templating to the input `branch`.

## [1.0.0] - 2024-01-15

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- _Version bump only._

### `tool-versions-update-action/pr`

- Add input `milestone` to set the milestone to be associated with Pull
  Requests.

## [0.3.13] - 2023-12-22

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Don't commit if there are no updates.
- Fix `{{updated-new-versions}}` and `{{updated-old-versions}}` being replaced
  with an empty string when templating.

### `tool-versions-update-action/pr`

- Don't open a Pull Request if there are no updates.
- Fix `{{updated-new-versions}}` and `{{updated-old-versions}}` being replaced
  with an empty string when templating.

## [0.3.12] - 2023-12-18

### `tool-versions-update-action`

- Add output `updated-new-versions`.
- Add output `updated-old-versions`.

### `tool-versions-update-action/commit`

- Add output `updated-new-versions`, which can also be used for templating.
- Add output `updated-old-versions`, which can also be used for templating.
- Update default `commit-message`.

### `tool-versions-update-action/pr`

- Add output `updated-new-versions`, which can also be used for templating.
- Add output `updated-old-versions`, which can also be used for templating.
- Update default `commit-message` and `pr-body`.

## [0.3.11] - 2023-12-13

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Fix runtime error when `commit-message` spans multiple lines.

### `tool-versions-update-action/pr`

- Fix runtime error when any of `commit-message`, `pr-body`, or `pr-title` spans
  multiple lines.
- Prevent force pushes to Pull Requests that were modified.

## [0.3.10] - 2023-12-09

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Add input `signoff` to add "Signed-off-by" line at the end of the commit
  message.
- Add support for templating `updated-count` and `updated-tools` into the input
  `commit-message`.
- Update default `commit-message`.

### `tool-versions-update-action/pr`

- Add support for templating `updated-count` and `updated-tools` into the inputs
  `commit-message`, `pr-body`, and `pr-title`.
- Update default `commit-message`, `pr-body`, and `pr-title`.

## [0.3.9] - 2023-11-19

### `tool-versions-update-action`

- Add output `updated-tools`.
- Improve debug logs with fewer repetitions.

### `tool-versions-update-action/commit`

- Add output `updated-tools`.
- Improve debug logs with fewer repetitions.

### `tool-versions-update-action/pr`

- Add input `signoff` to add "Signed-off-by" line at the end of the commit
  message.
- Add output `updated-tools`.
- Improve debug logs with fewer repetitions.

## [0.3.8] - 2023-11-05

### `tool-versions-update-action`

- Add input `skip` to configure versions of tools to skip when updating.
- Fix a bug where a log group wouldn't be closed when max. updates is reached.
- Improve debug logs with more details.

### `tool-versions-update-action/commit`

- Add input `skip` to configure versions of tools to skip when updating.
- Fix a bug where a log group wouldn't be closed when max. updates is reached.
- Fix a bug where an error occurs when a plugin is already installed.
- Improve debug logs with more details.

### `tool-versions-update-action/pr`

- Add input `skip` to configure versions of tools to skip when updating.
- Fix a bug where a log group wouldn't be closed when max. updates is reached.
- Fix a bug where an error occurs when a plugin is already installed.
- Improve debug logs with more details.

## [0.3.7] - 2023-10-29

### `tool-versions-update-action`

- Add output `updated-count`.

### `tool-versions-update-action/commit`

- BREAKING: Require support for the Node.js v20 runtime from the Actions runner.
- Add output `updated-count`.
- Bump `actions/checkout` from v3.6.0 to v4.1.1.
- Bump `asdf-vm/actions` from v2.2.0 to v3.0.2.
- Bump `stefanzweifel/git-auto-commit-action` from v4.16.0 to v5.0.0.

### `tool-versions-update-action/pr`

- BREAKING: Require support for the Node.js v20 runtime from the Actions runner.
- Add output `updated-count`.
- Bump `actions/checkout` from v3.6.0 to v4.1.1.
- Bump `asdf-vm/actions` from v2.2.0 to v3.0.2.

## [0.3.6] - 2023-09-12

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Bump `actions/checkout` from v3.5.3 to v3.6.0.

### `tool-versions-update-action/pr`

- Add input `branch` to configure the branch name for Pull Requests.
- Bump `actions/checkout` from v3.5.3 to v3.6.0.

## [0.3.5] - 2023-08-19

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Add output `commit-sha`.

### `tool-versions-update-action/pr`

- Add input `assignees` to configure the user(s) assigned to Pull Requests.
- Add input `reviewers` to configure the user(s) to review Pull Requests.
- Add output `commit-sha`.
- Add output `pr-number`.

## [0.3.4] - 2023-08-03

### `tool-versions-update-action`

- Add output `did-update`.

### `tool-versions-update-action/commit`

- Add output `did-update`.

### `tool-versions-update-action/pr`

- Add input `pr-base` input to configure the base branch of Pull Requests.
- Add output `did-update`.

## [0.3.3] - 2023-07-22

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Add input `commit-message` to configure the commit message.
- Pin all actions used by this action.

### `tool-versions-update-action/pr`

- Add input `commit-message` to configure the commit message.
- Add input `pr-body` to configure the description of Pull Requests.
- Add input `pr-title`  to configure the title of Pull Requests.
- Pin all actions used by this action.

## [0.3.2] - 2023-07-18

### `tool-versions-update-action`

- Add input `only` to consider updating only certain tools.

### `tool-versions-update-action/commit`

- Add input `only` to consider updating only certain tools.

### `tool-versions-update-action/pr`

- Add input `only` to consider updating only certain tools.

## [0.3.1] - 2023-07-16

### `tool-versions-update-action`

- Add input `not` to exclude certain tools from being updated.
- Exit immediately when an error occurs.

### `tool-versions-update-action/commit`

- Add input `not` to exclude certain tools from being updated.
- Exit immediately when an error occurs.

### `tool-versions-update-action/pr`

- Add input `not` to exclude certain tools from being updated.
- Exit immediately when an error occurs.

## [0.3.0] - 2023-07-15

### `tool-versions-update-action`

- BREAKING: No longer installs asdf.
- Add missing `.tool-versions` detection.

### `tool-versions-update-action/commit`

- Add input `plugins` to install asdf plugins.
- Add missing `.tool-versions` detection.

### `tool-versions-update-action/pr`

- Add input `plugins` to install asdf plugins.
- Add missing `.tool-versions` detection.

## [0.2.1] - 2023-07-07

### `tool-versions-update-action`

- _Initial release._

### `tool-versions-update-action/commit`

- _Version bump only._

### `tool-versions-update-action/pr`

- Add input `labels` to configure the initial labels on Pull Requests.

## [0.2.0] - 2023-06-18

### `tool-versions-update-action`

- BREAKING: Moved to `tool-versions-update-action/pr`.

### `tool-versions-update-action/commit`

- _Initial release._

### `tool-versions-update-action/pr`

- BREAKING: Moved from `tool-versions-update-action`.
- Add log grouping.
- Improve debug logs with more details.

## [0.1.1] - 2023-06-17

### `tool-versions-update-action`

- Fix creating multiple Pull Requests.
- Fix logging format & hide debug logs by default.

## [0.1.0] - 2023-06-15

### `tool-versions-update-action`

- _Initial release._

[keep a changelog]: https://keepachangelog.com/en/1.0.0/
[semantic versioning]: https://semver.org/spec/v2.0.0.html
