<!-- SPDX-License-Identifier: CC-BY-4.0 -->

# Tool Versions Update Action - Pull Request

A [GitHub Action] to automatically update the tools in your `.tool-versions`
file through a Pull Request.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action/pr@v1
  with:
    # A comma or newline-separated list of assignees for Pull Requests (by their
    # GitHub username).
    #
    # Default: ""
    assignees: ericcornelissen

    # The branch name to use for Pull Requests.
    #
    # This input supports templating, see the "Templating" section for more
    # information.
    #
    # Default: "tool-versions-updates"
    branch: update-tooling

    # The message to use for commits.
    #
    # This input supports templating, see the "Templating" section for more
    # information.
    #
    # Default (1st line): "Update {{updated-tools}}"
    commit-message: |
      Update {{updated-count}} tool(s)

      Update {{updated-tools}}

    # A comma or newline-separated list of labels for Pull Requests.
    #
    # Default: *no labels*
    labels: tools

    # The maximum number of tools to update. 0 indicates no maximum.
    #
    # Default: 0
    max: 2

    # The numeric identifier of the milestone to associate Pull Requests with.
    #
    # Default: *no milestone*
    milestone: 1

    # A comma-separated list of tools that should NOT be updated.
    #
    # Default: ""
    not: actionlint,shfmt

    # A comma-separated list of tools that should be updated, ignoring others.
    #
    # Default: ""
    only: shellcheck

    # A newline-separated list of "plugin url" pairs that should be installed.
    # If omitted the default plugins will be available.
    #
    # Default: ""
    plugins: |
      actionlint https://github.com/crazy-matt/asdf-actionlint
      shellcheck https://github.com/luizm/asdf-shellcheck

    # The base branch to use for Pull Requests.
    #
    # Default: *current branch*
    pr-base: develop

    # The body text to use for Pull Requests.
    #
    # This input supports templating, see the "Templating" section for more
    # information.
    #
    # Default: *depends on rebase-strategy*
    pr-body: |
      Update {{updated-count}} tool(s): {{updated-tools}}

      ---

      _This Pull Request was generated using the `tool-versions-update-action`_

    # The title to use for Pull Requests.
    #
    # This input supports templating, see the "Templating" section for more
    # information.
    #
    # Default: "Update {{updated-count}} tool(s)"
    pr-title: Update tooling

    # Configure when Pull Requests are rebased.
    #
    # A Pull Request may be rebased if the base branch is updated, a new version
    # of any of the updated tools becomes available, or a new version of another
    # tool becomes available.
    #
    # Available rebase strategies are:
    # - always: Always rebase when that is possible.
    # - untouched (default): Only rebase when there are no additional commits on
    #   the Pull Request branch.
    # - never: Never rebase, once a Pull Request is created it won't be updated.
    rebase-strategy: never

    # A comma or newline-separated list of reviewers for Pull Requests (by their
    # GitHub username).
    #
    # Default: ""
    reviewers: ericcornelissen

    # Add "Signed-off-by" line at the end of the commit message. See `--signoff`
    # in <https://git-scm.com/docs/git-commit> for more detail.
    #
    # Default: false
    signoff: true

    # A newline-separated list of "tool version" pairs that should NOT be
    # updated to.
    #
    # Default: ""
    skip: |
      shfmt 3.6.0
      yamllint 1.31.0

    # The $GITHUB_TOKEN or a repository scoped Personal Access Token (PAT).
    #
    # Default: $GITHUB_TOKEN
    token: ${{ github.token }}
```

### Outputs

The following outputs are made available:

| Name                   | Description                                                 |
| ---------------------- | ----------------------------------------------------------- |
| `commit-sha`           | The SHA identifier of the created commit                    |
| `did-update`           | `true` if at least one tool was updated, `false` otherwise  |
| `pr-number`            | The number of the created Pull Request                      |
| `updated-count`        | The number of tools that were updated                       |
| `updated-new-versions` | A comma separated list of the new versions of updated tools |
| `updated-old-versions` | A comma separated list of the old versions of updated tools |
| `updated-tools`        | A comma separated list of the names of the updated tools    |

For information on how to use outputs see the [GitHub Actions output docs].

#### Templating

Some inputs support a simple templating language to embed outputs before use. To
use a template variable use the string `{{output-name}}` in the input value, for
example:

```text
This template string uses the '{{updated-count}}' output
```

could become:

```text
This template string uses the '3' output
```

The following inputs support templating:

- `branch`
- `commit-message`
- `pr-body`
- `pr-title`

The following outputs are available for templating:

- `updated-count`
- `updated-new-versions`
- `updated-old-versions`
- `updated-tools`

### Full Example

This example is for a workflow that can be triggered manually to create a Pull
Request to update one or more tools defined in `.tool-versions` at the time.

```yml
name: Tooling
on:
  workflow_dispatch: ~

permissions: read-all

jobs:
  tooling:
    name: Update tooling
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/pr@v1
```

For more examples see the [recipes].

### Runners

This action is tested on the official [`ubuntu-22.04`] and [`ubuntu-24.04`]
runner images. It is recommended to use one of these images when using this
action.

### Security

#### Permissions

This action requires the following permissions:

```yml
permissions:
  contents: write # To push a commit
  pull-requests: write # To open a Pull Request
```

#### Network

This action requires network access to:

```txt
github.com:443
objects.githubusercontent.com:443
```

in addition to any endpoints your [asdf] plugins use.

## Recipes

### Parallel Updates

This workflow will create a Pull Request for each tool independently, and try to
do so daily. The result is that you may get one Pull Request to update one tool
and another to update another tool at the same time. This is similar to how
Dependabot Pull Requests work.

To achieve this the recipe uses the `only:` option to update only one tool at
the time and sets a tool-dependent `branch:` name to create separate Pull
Requests.

A limitation is that you can't limit the overall number of Pull Request to a
maximum. A drawback of this approach is that the list of tools is duplicated
between the workflow (in `matrix:`) and `.tool-versions` file.

```yml
name: Tooling
on:
  schedule:
    - cron: "0 0 * * *" # see https://crontab.guru/daily

permissions: read-all

jobs:
  tooling:
    name: Update ${{ matrix.tool }}
    runs-on: ubuntu-latest
    matrix:
      tool:
        - actionlint
        - shellcheck
    permissions:
      contents: write
      pull-requests: write
    steps:
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/pr@v1
        with:
          branch: bot/tool_versions/{{updated-tools}}-{{updated-new-versions}}
          only: ${{ matrix.tool }}
```

### One at the Time

This workflow create one Pull Request at the time for only one tool on daily
schedule. This reduces noise and per-Pull Request load to a minimum.

To achieve this the recipe uses the `max:` option to limit to updating one tool
at the time and uses `rebase-strategy:` to prevent any further changes to the
Pull Request after that.

```yml
name: Tooling
on:
  schedule:
    - cron: "0 0 * * *" # see https://crontab.guru/daily

permissions: read-all

jobs:
  tooling:
    name: Update tool
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - name: Update tooling
        uses: ericcornelissen/tool-versions-update-action/pr@v1
        with:
          max: 1
          rebase-strategy: never
```

---

The contents of this document are licensed under [CC BY 4.0], code snippets
under the [MIT-0 license].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github action]: https://github.com/features/actions
[github actions output docs]: https://help.github.com/en/actions/reference/contexts-and-expression-syntax-for-github-actions#steps-context
[mit-0 license]: https://opensource.org/license/mit-0/
[recipes]: #recipes
[`ubuntu-22.04`]: https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2204-Readme.md
[`ubuntu-24.04`]: https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md
