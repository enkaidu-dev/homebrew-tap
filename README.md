# `enkaidu-dev` Tap for Homebrew

> Enkaidu itself is [here](https://github.com/enkaidu-dev/enkaidu)

## How do I install Enkaidu?

### Direct

```sh
brew install enkaidu-dev/tap/enkaidu
```

### Tap first

```sh
brew tap enkaidu-dev/tap
```

And then

```sh
brew install enkaidu
```

### Bundle

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "enkaidu-dev/tap"
brew "<formula>"
```

## Development

### Releasing a new version

1. Bump `url`/`sha256` in `Formula/enkaidu.rb` (or bump `revision` for a
   rebuild with no source change, e.g. retroactively adding bottles).
2. Push to a branch, open a PR against `main`.
3. Wait for `tests.yml` to go green on **all** matrix jobs (Linux x86_64/arm64,
   macOS arm64/x86_64) — check the PR's checks tab.
4. Label the PR `pr-pull`. **Do this only after step 3** — labeling early
   fails since there are no bottle artifacts yet.
5. `publish.yml` runs automatically: uploads bottles to GitHub Packages,
   writes the `bottle do...end` block into the formula, pushes to `main`,
   and auto-closes the PR.

If `pr-pull` fails (e.g. labeled too early), remove the label, confirm
`tests.yml` is fully green, then re-add it to retry.

### How it works

`tests.yml` (`brew test-bot`) builds the formula from source on each
matrix runner and uploads the result as a bottle artifact. `publish.yml`
(`brew pr-pull`), triggered by the `pr-pull` label, picks up those
artifacts, uploads them to GitHub Packages, rewrites the formula with the
resulting `bottle do...end` block, and pushes straight to `main`.

```mermaid
sequenceDiagram
    participant You
    participant PR as PR (formula change)
    participant CI as tests.yml (test-bot)
    participant Pub as publish.yml (pr-pull)
    participant GHP as GitHub Packages
    participant User as brew install

    You->>PR: bump url/sha256 or revision
    PR->>CI: triggers on push/PR
    par per matrix OS
        CI->>CI: macos-latest (arm64): build + bottle
        CI->>CI: macos-13 (x86_64): build + bottle
        CI->>CI: ubuntu-latest (x86_64): build + bottle
        CI->>CI: ubuntu-24.04-arm (arm64): build + bottle
    end
    CI-->>PR: upload bottles as artifacts

    You->>PR: label "pr-pull" (after CI is green)
    PR->>Pub: triggers on label
    Pub->>Pub: download artifacts
    Pub->>GHP: upload bottles
    Pub->>PR: rewrite enkaidu.rb with bottle do...end
    Pub->>PR: commit + push to main

    User->>User: brew install enkaidu
    alt OS/arch matches bottle hash
        User->>GHP: download prebuilt bottle
    else no match
        User->>User: build from source
    end
```

Once a bottle hash matches the installer's OS/arch, `brew install` skips
compiling Crystal/Node entirely and just downloads the binary.
