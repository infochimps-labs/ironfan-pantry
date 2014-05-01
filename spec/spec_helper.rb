require 'chefspec'

COOKBOOK_PATH = ENV['COOKBOOK_PATH'] || File.expand_path("../../cookbooks", __FILE__)

RSpec.configure do |config|
  config.cookbook_path = [COOKBOOK_PATH]

  config.tty   = true
  config.color = true
  config.order = 'random'
end
