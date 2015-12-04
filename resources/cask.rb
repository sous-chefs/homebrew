actions :cask, :uncask, :install, :uninstall
default_action :install

attribute :name,
  name_attribute: true,
  kind_of: String,
  regex: /^[\w-]+$/

attribute :options,
  kind_of: String

def casked?
  shell_out("/usr/local/bin/brew cask list | grep #{name}").exitstatus == 0
end
