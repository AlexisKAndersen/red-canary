require "thor"
require "yaml"
require "time"
require "etc"
require "fileutils"
require "json"
require "uri"

lib = File.expand_path("lib",File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "tasks"
require "logging"

ENV["ACTIVITY_LOG_FILE"] ||= File.join("log","activity.yml")
ENV["THOR_SILENCE_DEPRECATION"] = "true"
