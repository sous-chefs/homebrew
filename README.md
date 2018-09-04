# Homebrew Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/homebrew.svg?branch=master)](http://travis-ci.org/chef-cookbooks/homebrew) [![Cookbook Version](https://img.shields.io/cookbook/v/homebrew.svg)](https://supermarket.chef.io/cookbooks/homebrew)

This cookbook installs [Homebrew](http://brew.sh/) and provides resources for working with taps and casks

Note: The homebrew_tap and homebrew_cask resources shipped in Chef 14.0. When Chef 15.0 is released in April 2019 these resources will be removed from this cookbook as all users should be on 14.0 or later.

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

[homebrew-cask on GitHub](https://github.com/caskroom/homebrew-cask)

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

[View the list of available Casks](https://github.com/caskroom/homebrew-cask/tree/master/Casks)

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

- `node['homebrew']['taps']` - An Array of taps that should be installed using brew tap by default, used only in the `homebrew::install_taps` recipe. For example:<br>

  ```ruby
  [
    'homebrew/science',
    # 'tap' is the only required key for the Hash
    { 'tap' => 'homebrew/dupes', 'url' => 'https://github.com', 'full' => true }
  ]
  ```

# Usage

We strongly recommend that you put "recipe[homebrew]" in your node's run list, to ensure that it is available on the system and that Homebrew itself gets installed. Putting an explicit dependency in the metadata will cause the cookbook to be downloaded and the library loaded, thus resulting in changing the package provider on Mac OS X, so if you have systems you want to use the default (Mac Ports), they would be changed to Homebrew.

The default recipe also ensures that Homebrew is installed and up to date if the auto update attribute (above) is true (default).

## License and Authors

This cookbook is maintained by CHEF. The original author, maintainer and copyright holder is Graeme Mathieson. The cookbook remains licensed under the Apache License version 2.

[Original blog post by Graeme](https://woss.name/articles/converging-your-home-directory-with-chef/)

Author:: Graeme Mathieson ([mathie@woss.name](mailto:mathie@woss.name))

Author:: Joshua Timberman ([joshua@chef.io](mailto:joshua@chef.io))

```text
Copyright:: 2011, Graeme Mathieson
Copyright:: 2012-2016, Chef Software, Inc. <legal@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
