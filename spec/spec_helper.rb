require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :fatal
  config.order = 'random'
  config.color = true
  config.formatter = 'documentation'
end
