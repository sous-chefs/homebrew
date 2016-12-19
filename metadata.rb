name             'homebrew'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Install Homebrew and includes resources for working with taps and casks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.0'
recipe           'homebrew', 'Install Homebrew'
supports         'mac_os_x'

source_url 'https://github.com/chef-cookbooks/homebrew'
issues_url 'https://github.com/chef-cookbooks/homebrew/issues'
chef_version '>= 12.1'
