#
# Author:: Joshua Timberman (<jtimberman@chef.io>)
# Author:: Graeme Mathieson (<mathie@woss.name>)
# Cookbook:: homebrew
# Resources:: cask
#
# Copyright:: 2011-2018, Chef Software, Inc.
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
property :cask_name, String, regex: %r{^[\w/-]+$}, name_property: true
property :options, String
property :install_cask, [true, false], default: true
property :homebrew_path, String, default: '/usr/local/bin/brew'
property :owner, String, default: lazy { Homebrew.owner } # lazy to prevent breaking compilation on non-macOS platforms

action :install do
  homebrew_tap 'caskroom/cask' if new_resource.install_cask

  unless casked?
    converge_by("install cask #{new_resource.name} #{new_resource.options}") do
      shell_out!("#{new_resource.homebrew_path} cask install #{new_resource.name} #{new_resource.options}",
          user: new_resource.owner,
          env:  { 'HOME' => ::Dir.home(new_resource.owner), 'USER' => new_resource.owner },
          cwd: ::Dir.home(new_resource.owner))
    end
  end
end

action :remove do
  homebrew_tap 'caskroom/cask' if new_resource.install_cask

  if casked?
    converge_by("uninstall cask #{new_resource.name}") do
      shell_out!("#{new_resource.homebrew_path} cask uninstall #{new_resource.name}",
          user: new_resource.owner,
          env:  { 'HOME' => ::Dir.home(new_resource.owner), 'USER' => new_resource.owner },
          cwd: ::Dir.home(new_resource.owner))
    end
  end
end

action_class do
  alias_method :action_cask, :action_install
  alias_method :action_uncask, :action_remove
  alias_method :action_uninstall, :action_remove

  def casked?
    unscoped_name = new_resource.name.split('/').last
    shell_out!('#{new_resource.homebrew_path} cask list 2>/dev/null',
      user: new_resource.owner,
      env:  { 'HOME' => ::Dir.home(new_resource.owner), 'USER' => new_resource.owner },
      cwd: ::Dir.home(new_resource.owner)).stdout.split.include?(unscoped_name)
  end
end
