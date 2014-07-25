require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut
include ::Homebrew::Mixin

def load_current_resource
  @cask = Chef::Resource::HomebrewCask.new(new_resource.name)
  Chef::Log.debug("Checking whether #{new_resource.name} is installed")
  @cask.casked shell_out("/usr/local/bin/brew cask list #{new_resource.name}").exitstatus == 0
end

action :install do
  unless @cask.casked
    execute "installing cask #{new_resource.name}" do
      command "/usr/local/bin/brew cask install #{new_resource.name}"
      user homebrew_owner
    end
  end
end

action :uninstall do
  if @cask.casked
    execute "uninstalling cask #{new_resource.name}" do
      command "/usr/local/bin/brew cask uninstall #{new_resource.name}"
      user homebrew_owner
    end
  end
end

action :cask do
  action_install
end

action :uncask do
  action_uninstall
end
