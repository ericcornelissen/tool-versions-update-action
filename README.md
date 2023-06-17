# Tool Versions Update Action

A [GitHub Action] to automatically update the tools in your `.tool-versions`
file.

This action uses [asdf] and various other GitHub Actions to try and update any
tools defined in your project's `.tool-versions` and open a Pull Request to
apply those updates to the project.

## Early Development Notice

This action is currently in early development and so you should expect breaking
changes from one version to the next. When using this action it is advised to
pin to an exact version or commit SHA.

The first stable release (if reached) will be v1.0.0.

## Usage

```yml
- uses: ericcornelissen/tool-versions-update-action@v0.1.1
  with:
    # The $GITHUB_TOKEN or a repository scoped Personal Access Token (PAT).
    # Default: $GITHUB_TOKEN
    token: ${{ github.token }}

    # The maximum number of tools to update. 0 indicates no maximum.
    # Default: 0
    max: 0
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
        uses: ericcornelissen/tool-versions-update-action@v0.1.1
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

in addition to any endpoints your asdf plugins use.

## License

All source code is licensed under the MIT license, see [LICENSE] for the full
license text. The contents of documentation is licensed under [CC BY 4.0].

[asdf]: https://asdf-vm.com/
[cc by 4.0]: https://creativecommons.org/licenses/by/4.0/
[github action]: https://github.com/features/actions
[license]: ./LICENSE
