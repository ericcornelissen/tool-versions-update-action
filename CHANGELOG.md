# Changelog

All notable changes to _Tool Versions Update Action_ will be documented in this
file.

The format is based on [Keep a Changelog], and this project adheres to [Semantic
Versioning].

## [Unreleased]

- _No changes yet_

### `tool-versions-update-action`

- _No changes yet_

### `tool-versions-update-action/commit`

- _No changes yet_

### `tool-versions-update-action/pr`

- _No changes yet_

## [0.3.3] - 2023-07-22

### `tool-versions-update-action`

- _Version bump only._

### `tool-versions-update-action/commit`

- Add input `commit-message` to configure the commit message.
- Pin all actions used by this action.

### `tool-versions-update-action/pr`

- Add input `commit-message` to configure the commit message.
- Add input `pr-body` to configure the Pull Request description.
- Add input `pr-title`  to configure the Pull Request title.
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

### `tool-versions-update-action/comment`

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
