require 'rspec'

require_relative '../red_canary.rb'

test_logfile = "test-activity.yml"

ENV["ACTIVITY_LOG_FILE"] = File.join("log",test_logfile)

RSpec.configure do |config|
  config.order = 'random'
  config.before(:suite) { FileUtils.rm_f(File.join("log", test_logfile)) }
end
