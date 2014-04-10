require 'chefspec'

RSpec.configure do |config|
  # Specify the Chef log_level (default: :warn)
  # config.log_level = :debug
  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'ubuntu'
  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '12.04'
end
