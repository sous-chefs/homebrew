## v1.3.2:

* [COOK-1793] - use homebrew "go" script to install homebrew
* [COOK-1821] - Discovered version using Homebrew Formula factory
  fails check that verifies that version is a String
* [COOK-1843] - Homebrew README.md contains non-ASCII characters,
  triggering same issue as COOK-522

## v1.3.0:

* [COOK-1425] - use new json output format for formula
* [COOK-1578] - Use shell_out! instead of popen4

## v1.2.0:

Opscode has taken maintenance of this cookbook as the original author
has other commitments. This is the initial release with Opscode as
maintainer.

Changes in this release:

* [pull/2] - support for option passing to brew
* [pull/3] - add brew upgrade and control return value from command
* [pull/9] - added LWRP for "brew tap"
* README is now markdown, not rdoc.
