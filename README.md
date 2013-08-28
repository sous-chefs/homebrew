Homebrew Cookbook
=================
This cookbook installs [Homebrew](http://mxcl.github.com/homebrew/) and replaces MacPorts as the *default package provider* for the package resource on OS X systems.

This cookbook is now maintained by Opscode. The original author, maintainer and copyright holder is Graeme Mathieson. The cookbook remains licensed under the Apache License version 2.

[Original blog post by Graeme](http://woss.name/2011/01/23/converging-your-home-directory-with-chef/)


Requirements
------------
### Prerequisites

In order for this recipe to work, your userid must own `/usr/local`. This is outside the scope of the cookbook because it's anticipated that you'll run the cookbook as your own user, not root and you'd have to be root to take ownership of the directory. Easiest way to get started:

```bash
sudo chown -R `whoami`:staff /usr/local
```

Bear in mind that this will take ownership of the entire folder and its contents, so if you've already got stuff in there (eg MySQL owned by a `mysql` user) you'll need to be a touch more careful. This is a recommendation from Homebrew.

### Platform

- Mac OS X (10.6+)

The only platform supported by Homebrew itself at the time of this writing is Mac OS X. It should work fine on Server edition as well, and on platforms that Homebrew supports in the future.


Attributes
----------
- `node['homebrew']['owner']` - The user that will own the Homebrew installation and packages. Setting this will override the default behavior which is to use the non-privileged user that has invoked the Chef run (or the `SUDO_USER` if invoked with sudo). The default is `nil`.


Resources and Providers
-----------------------
### package / homebrew\_package

This cookbook provides a package provider called `homebrew_package` which will install/remove packages using Homebrew. This becomes the default provider for `package` if your platform is Mac OS X.

As this extends the built-in package resource/provider in Chef, it has all the resource attributes and actions available to the package resource. However, a couple notes:

- Homebrew itself doesn't have a notion of "upgrade" per se. The "upgrade" action will simply perform an install, and if the Homebrew Formula for the package is newer, it will upgrade.
- Likewise, Homebrew doesn't have a purge, but the "purge" action will act like "remove".

#### Examples

```ruby
package 'mysql' do
  action :install
end

homebrew_package 'mysql'

package 'mysql' do
  provider Chef::Provider::Package::Homebrew
end
```

### homebrew\_tap

LWRP for `brew tap`, a Homebrew command used to add additional formula repositories. From the `brew` man page:

```text
tap [tap]
       Tap a new formula repository from GitHub, or list existing taps.

       tap is of the form user/repo, e.g. brew tap homebrew/dupes.
```

Default action is `:tap` which enables the repository. Use `:untap` to disable a tapped repository.

#### Examples

```ruby
homebrew_tap 'homebrew/dupes'

homebrew_tap 'homebrew/dupes' do
  action :untap
end
```


Usage
-----
We strongly recommend that you put "recipe[homebrew]" in your node's run list, to ensure that it is available on the system and that Homebrew itself gets installed. Putting an explicit dependency in the metadata will cause the cookbook to be downloaded and the library loaded, thus resulting in changing the package provider on Mac OS X, so if you have systems you want to use the default (Mac Ports), they would be changed to Homebrew.

The default itself ensures that Homebrew is installed and up to date.


License and Authors
-------------------
- Author:: Graeme Mathieson (<mathie@woss.name>)
- Author:: Joshua Timberman (<joshua@opscode.com>)

```text
Copyright:: 2011, Graeme Mathieson
Copyright:: 2012, Opscode, Inc <legal@opscode.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
