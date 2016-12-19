#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2016, Chef Software, Inc.

node.default['homebrew']['formulas'] = %w(redis)
node.default['homebrew']['casks'] = %w(caffeine)
node.default['homebrew']['taps'] = %w(homebrew/homebrew-games)
node.default['homebrew']['enable-analytics'] = false

include_recipe 'build-essential::default'
include_recipe 'homebrew::install_formulas'
include_recipe 'homebrew::install_casks'
include_recipe 'homebrew::install_taps'
