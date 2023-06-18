# Tool Versions Update Action - Pull Request

A [GitHub Action] to automatically update the tools in your `.tool-versions`
file through a Pull Request.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action/pr@v0.1.1
  with:
    # The maximum number of tools to update. 0 indicates no maximum.
    #
    # Default: 0
    max: 0

    # The $GITHUB_TOKEN or a repository scoped Personal Access Token (PAT).
    #
    # Default: $GITHUB_TOKEN
    token: ${{ github.token }}
```

### Full Example

This example is for a workflow that can be triggered manually to create a Pull
Request to update at most 2 tools defined in `.tool-versions` at the time.

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
        uses: ericcornelissen/tool-versions-update-action/pr@v0.1.1
        with:
          max: 2
```

## Security

### Permissions

This action requires the following permissions:

```yml
permissions:
  contents: write # To push a commit
  pull-requests: write # To open a Pull Request
```

### Network

This action requires network access to:

```txt
github.com:443
objects.githubusercontent.com:443
```

in addition to any endpoints your [asdf] plugins use.

---

The contents of this document are licensed under [CC BY 4.0].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github action]: https://github.com/features/actions