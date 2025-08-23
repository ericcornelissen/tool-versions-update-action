<!-- SPDX-License-Identifier: CC0-1.0 -->

# Release Guidelines

To release a new version of the _Tool Versions Update Action_ follow the steps
found in this file (using v2.3.4 as an example):

1. Make sure that your local copy of the repository is up-to-date, sync:

   ```shell
   git checkout main
   git pull origin main
   ```

   Or clone:

   ```shell
   git clone git@github.com:ericcornelissen/tool-versions-update-action.git
   ```

1. Update the version number following [Semantic Versioning]:

   ```shell
   ./script/version-bump.sh [major|minor|patch]
   ```

   Or edit the `.version` file manually:

   ```diff
   - 1.2.2
   + 1.2.3
   ```

1. Update the changelog:

   ```shell
   ./script/update-changelog.sh
   ```

   Or edit the `CHANGELOG.md` file manually. First, replace all instances of
   `_No changes yet._` with `_Version bump only._`. Second, add the following
   after the `## [Unreleased]` line, adjusting the version number for the
   release:

   ```markdown

   ### `tool-versions-update-action`

   - _No changes yet._

   ### `tool-versions-update-action/commit`

   - _No changes yet._

   ### `tool-versions-update-action/pr`

   - _No changes yet._

   ## [1.2.3] - YYYY-MM-DD

   ```

   The date should follow the year-month-day format where single-digit months
   and days should be prefixed with a `0` (e.g. `2022-01-01`).

1. Commit the changes to a new branch and push using:

   ```shell
   git checkout -b release-$(sha1sum .version | awk '{print $1}' | head -c 7)
   git add .version CHANGELOG.md
   git commit --message "Version bump"
   git push origin release-$(sha1sum .version | awk '{print $1}' | head -c 7)
   ```

1. Create a Pull Request to merge the new branch into `main`.

1. Merge the Pull Request if the changes look OK and all continuous integration
   checks are passing.

1. Immediately after the Pull Request is merged, sync the `main` branch:

   ```shell
   git checkout main
   git pull origin main
   ```

1. Create a [git tag] for the new version and push it:

   ```shell
   git tag "v$(cat .version)"
   git push origin "v$(cat .version)"
   ```

   > **Note** At this point, the continuous delivery automation may pick up and
   > complete the release process. If not, or only partially, continue following
   > the remaining steps.

1. Update the `v2` branch to point to the same commit as the new tag:

   ```shell
   git checkout v2
   git merge main
   ```

1. Push the `v2` branch:

   ```shell
   git push origin v2
   ```

1. Create a [GitHub Release] for the [git tag] of the new release. The release
   title should be "Release {_version_}" (e.g. "Release v2.3.4"). The release
   text should be identical.

   Ensure the version is published to the [GitHub Marketplace] as well.

[git tag]: https://git-scm.com/book/en/v2/Git-Basics-Tagging
[github marketplace]: https://github.com/marketplace
[github release]: https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository
[semantic versioning]: https://semver.org/spec/v2.0.0.html
