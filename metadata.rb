name             'homebrew'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Install Homebrew, and use it as the OS X package provider on Chef versions =< 11'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.5'
recipe           'homebrew', 'Install Homebrew'
supports         'mac_os_x'
supports         'mac_os_x_server'
depends          'build-essential', '>= 2.1.2'

source_url 'https://github.com/chef-cookbooks/homebrew' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/homebrew/issues' if respond_to?(:issues_url)
