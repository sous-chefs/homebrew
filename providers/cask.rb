def whyrun_supported?
  true
end

def cask_path(name)
  "/opt/homebrew-cask/Caskroom/#{name}"
end

def load_current_resource
  @cask = Chef::Resource::HomebrewCask.new(new_resource.name)

  Chef::Log.debug("Checking whether we've already installed cask #{new_resource.name}")
  @cask.casked ::File.directory?(cask_path(new_resource.name))
end

use_inline_resources

action :cask do
  unless @cask.casked
    execute "installing cask #{new_resource.name}" do
      command "/usr/local/bin/brew cask install #{new_resource.name}"
      creates cask_path(new_resource.name)
    end
  end
end

action :uncask do
  if @cask.casked
    execute "uninstalling cask #{new_resource.name}" do
      command "/usr/local/bin/brew cask uninstall #{new_resource.name}"
      only_if "test -d #{cask_path(new_resource.name)}"
    end
  end
end
