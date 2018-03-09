#
# Author:: Joshua Timberman (<jtimberman@chef.io>)
# Author:: Graeme Mathieson (<mathie@woss.name>)
# Cookbook:: homebrew
# Resources:: tap
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

property :tap_name, String, name_property: true, regex: %r{^[\w-]+(?:\/[\w-]+)+$}
property :url, String
property :full, [TrueClass, FalseClass], default: false
property :homebrew_path, String, default: '/usr/local/bin/brew'
property :owner, String, default: lazy { Homebrew.owner } # lazy to prevent breaking compilation on non-macOS platforms

action :tap do
  unless tapped?(new_resource.name)
    converge_by("tap #{new_resource.name}") do
      shell_out!("#{new_resource.homebrew_path} tap #{new_resource.full ? '--full' : ''} #{new_resource.name} #{new_resource.url || ''}",
          user: new_resource.owner,
          env:  { 'HOME' => ::Dir.home(new_resource.owner), 'USER' => new_resource.owner },
          cwd: ::Dir.home(new_resource.owner))
    end
  end
end

action :untap do
  if tapped?(new_resource.name)
    converge_by("untap #{new_resource.name}") do
      shell_out!("#{new_resource.homebrew_path} untap #{new_resource.name}",
          user: new_resource.owner,
          env:  { 'HOME' => ::Dir.home(new_resource.owner), 'USER' => new_resource.owner },
          cwd: ::Dir.home(new_resource.owner))
    end
  end
end

def tapped?(name)
  tap_dir = name.gsub('/', '/homebrew-')
  ::File.directory?("/usr/local/Homebrew/Library/Taps/#{tap_dir}")
end
