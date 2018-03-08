#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2016-2017, Chef Software, Inc.

node.default['homebrew']['formulas'] = %w(redis)
node.default['homebrew']['casks'] = %w(caffeine)
node.default['homebrew']['taps'] = [
  {
    'tap' => 'homebrew/bundle',
    'full' => true,
  },
  {
    'tap' => 'homebrew/services',
    'url' => 'https://github.com/homebrew/homebrew-services.git',
    'full' => true,
  },
  { 'tap' => 'homebrew/php',
    'url' => 'https://github.com/homebrew/homebrew-php.git',
    'full' => false,
  },
]
node.default['homebrew']['enable-analytics'] = false

ssh_known_hosts_entry 'github.com' do
  group 'wheel'
end

build_essential 'Install compilation tools'
include_recipe 'homebrew::install_formulas'
include_recipe 'homebrew::install_casks'
include_recipe 'homebrew::install_taps'
