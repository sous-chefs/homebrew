require 'chefspec'
require 'chefspec/berkshelf'

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.log_level = :fatal
  config.order = 'random'
  config.color = true
  config.formatter = 'documentation'
end
