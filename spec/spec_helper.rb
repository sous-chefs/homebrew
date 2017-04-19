require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/helpers'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
  config.platform = 'mac_os_x'
  config.version = '10.12'
end
