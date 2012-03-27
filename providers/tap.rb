def load_current_resource
  @tap = Chef::Resource::HomebrewTap.new(new_resource.name)
  tap_dir = @tap.name.gsub('/', '-')

  Chef::Log.debug("Checking whether we've already tapped #{new_resource.name}")
  if ::File.directory?("/usr/local/Library/Taps/#{tap_dir}")
    @tap.tapped true
  else
    @tap.tapped false
  end
end

action :tap do
  unless @tap.tapped
    execute "tapping #{new_resource.name}" do
      command "/usr/local/bin/brew tap #{new_resource.name}"
    end
  end
end

action :untap do
  if @tap.tapped
    execute "untapping #{new_resource.name}" do
      command "/usr/local/bin/brew untap #{new_resource.name}"
    end
  end
end
