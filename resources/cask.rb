actions :cask, :uncask, :install, :uninstall
default_action :install

attribute :name,
  name_attribute: true,
  kind_of: String,
  regex: /^[\w-]+$/

attribute :casked,
  kind_of: [TrueClass, FalseClass]

attribute :options,
  kind_of: String
