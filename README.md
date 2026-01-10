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

To trigger `publish` workflow, remember to label the PR with `pr-pull` before merging.
