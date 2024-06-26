#
# Author:: Joshua Timberman (<jtimberman@chef.io>)
# Author:: Graeme Mathieson (<mathie@woss.name>)
# Cookbook:: homebrew
# Library:: helpers
#
# Copyright:: 2011-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class HomebrewUserWrapper
  require 'chef/mixin/homebrew_user'
  include Chef::Mixin::HomebrewUser
  include Chef::Mixin::Which
end

module Homebrew
  extend self

  require 'mixlib/shellout'
  include Chef::Mixin::ShellOut

  def self.included(base)
    base.extend(Homebrew)
  end

  def install_path
    arm64_test = shell_out('sysctl -n hw.optional.arm64')
    if arm64_test.stdout.chomp == '1'
      '/opt/homebrew'
    else
      '/usr/local'
    end
  end

  def repository_path
    arm64_test = shell_out('sysctl -n hw.optional.arm64')
    if arm64_test.stdout.chomp == '1'
      '/opt/homebrew'
    else
      '/usr/local/Homebrew'
    end
  end

  def exist?
    Chef::Log.debug('Checking to see if the homebrew binary exists')
    ::File.exist?("#{HomebrewWrapper.new.install_path}/bin/brew")
  end

  def owner
    @owner ||= begin
      # once we only support 14.0 we can switch this to find_homebrew_username
      require 'etc'
      ::Etc.getpwuid(HomebrewUserWrapper.new.find_homebrew_uid).name
               rescue Chef::Exceptions::CannotDetermineHomebrewOwner
                 calculate_owner
    end.tap do |owner|
      Chef::Log.debug("Homebrew owner is #{owner}")
    end
  end

  private

  def calculate_owner
    owner = homebrew_owner_attr || sudo_user || current_user
    if owner == 'root'
      raise Chef::Exceptions::User,
           "Homebrew owner is 'root' which is not supported. " \
           "To set an explicit owner, please set node['homebrew']['owner']."
    end
    owner
  end

  def homebrew_owner_attr
    Chef.node['homebrew']['owner']
  end

  def sudo_user
    ENV['SUDO_USER']
  end

  def current_user
    ENV['USER']
  end
end unless defined?(Homebrew)

class HomebrewWrapper
  include Homebrew
end
