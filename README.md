# Homebrew Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/homebrew.svg)](https://supermarket.chef.io/cookbooks/homebrew)
[![CI State](https://github.com/sous-chefs/homebrew/workflows/ci/badge.svg)](https://github.com/sous-chefs/homebrew/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs [Homebrew](http://brew.sh/) and provides resources for working with taps and casks

Note: The `homebrew_tap` and `homebrew_cask` resources shipped in Chef 14.0. When Chef 15.0 is released in April 2019 these resources will be removed from this cookbook as all users should be on 14.0 or later.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- macOS

### Chef

- Chef 12.7+

### Cookbooks

- none

## Resources

### homebrew_tap

Resource for `brew tap`, a Homebrew command used to add additional formula repositories. From the `brew` man page:

```text
brew tap [--full] user/repo [URL]
    Tap a formula repository.

    With URL unspecified, taps a formula repository from GitHub using HTTPS.
    Since so many taps are hosted on GitHub, this command is a shortcut for
    tap user/repo https://github.com/user/homebrew-repo.

    With URL specified, taps a formula repository from anywhere, using
    any transport protocol that git handles. The one-argument form of tap
    simplifies but also limits. This two-argument command makes no
    assumptions, so taps can be cloned from places other than GitHub and
    using protocols other than HTTPS, e.g., SSH, GIT, HTTP, FTP(S), RSYNC.

    By default, the repository is cloned as a shallow copy (--depth=1), but
    if --full is passed, a full clone will be used. To convert a shallow copy
    to a full copy, you can retap passing --full without first untapping.
```

Default action is `:tap` which enables the repository. Use `:untap` to disable a tapped repository.

#### Actions

- `:tap` (default) - Add a tap
- `:untap` - Remove a tap

#### Properties

- `:tap_name` - Optional name property to override the resource name value
- `:url` - Optional URL to the tap
- `:full` - Perform a full clone rather than a shallow clone on the tap (default: false)
- `:homebrew_path` - the path to the homebrew binary (default: '/usr/local/bin/brew')
- `:owner` - the owner of the homebrew installation (default: calculated based on existing files)

#### Examples

```ruby
homebrew_tap 'homebrew/dupes'

homebrew_tap 'homebrew/dupes' do
  action :untap
end

homebrew_tap "Let's install homebrew/dupes" do
  tap_name 'homebrew/dupes'
  url 'https://github.com/homebrew/homebrew-dupes.git'
  full true
end
```

### homebrew_cask

Resource for `brew cask`, a Homebrew-style CLI workflow for the administration of Mac applications distributed as binaries. It's implemented as a homebrew "external command" called cask.

[homebrew-cask on GitHub](https://github.com/Homebrew/homebrew-cask)

#### Actions

- `:install` (default) - install an Application
- `:remove` - remove an Application.

#### Properties

- `:cask_name` - Optional name property to override the resource name value
- `:options` - options to pass to the brew CLI during installation
- `:install_cask` - auto install cask tap if necessary (default: true)
- `:homebrew_path` - the path to the homebrew binary (default: '/usr/local/bin/brew')
- `:owner` - the owner of the homebrew installation (default: calculated based on existing files)

#### Examples

```ruby
homebrew_cask 'google-chrome'

homebrew_cask "Let's remove google-chrome" do
  cask_name 'google-chrome'
  install_cask false
  action :remove
end
```

[View the list of available Casks](https://github.com/Homebrew/homebrew-cask/tree/master/Casks)

## Attributes

- `node['homebrew']['owner']` - The user that will own the Homebrew installation and packages. Setting this will override the default behavior which is to use the non-privileged user that has invoked the Chef run (or the `SUDO_USER` if invoked with sudo). The default is `nil`.
- `node['homebrew']['auto-update']` - Whether the default recipe should automatically update Homebrew each run or not. The default is `true` to maintain compatibility. Set to false or nil to disable. Note that disabling this feature may cause formula to not work.
- `node['homebrew']['formulas']` - An Array of formula that should be installed using Homebrew by default, used only in the `homebrew::install_formulas` recipe.

  - To install the most recent version, include just the recipe name: `- simple_formula`
  - To install a specific version, specify both its name and version:

    ```
    - name: special-version-formula
      version: 1.2.3
    ```

  - To install the HEAD of a formula, specify both its name and `head: true`:

    ```
    - name: head-tracking-formula
      head: true
    ```

  - To provide other options, specify both its name and options

    ```
    - name: formula-with-options
      options: --with-option-1 --with-other-option
    ```

- `node['homebrew']['casks']` - An Array of casks that should be installed using brew cask by default, used only in the `homebrew::install_casks` recipe.

- `node['homebrew']['taps']` - An Array of taps that should be installed using brew tap by default, used only in the `homebrew::install_taps` recipe. For example:

  ```ruby
  [
    'homebrew/science',
    # 'tap' is the only required key for the Hash
    { 'tap' => 'homebrew/dupes', 'url' => 'https://github.com', 'full' => true }
  ]
  ```

# Usage

We strongly recommend that you put "recipe[homebrew]" in your node's run list, to ensure that it is available on the system and that Homebrew itself gets installed. Putting an explicit dependency in the metadata will cause the cookbook to be downloaded and the library loaded, thus resulting in changing the package provider on macOS, so if you have systems you want to use the default (Mac Ports), they would be changed to Homebrew.

The default recipe also ensures that Homebrew is installed and up to date if the auto-update attribute (above) is true (default).

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
