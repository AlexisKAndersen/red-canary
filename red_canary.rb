require "thor"
require "yaml"
require "time"
require "etc"

lib = File.expand_path("lib",File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "tasks"
require "logging"

ENV["THOR_SILENCE_DEPRECATION"] = "true"

#not a sustainable way to configure this per environment
class ActivityLog
  def self.logfile
    "log/test-activity.yml"
  end
end