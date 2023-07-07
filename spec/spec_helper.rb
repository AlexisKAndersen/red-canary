require 'rspec'

require_relative '../red_canary.rb'

RSpec.configure do |config|
  config.order = 'random'
end

ENV["ACTIVITY_LOG_FILE"] = File.join("log","test-activity.yml")