class ActivityLog
  class << self
    def logfile
      "log/activity.yml"
    end

    def log_activity data
      open(logfile,"a") { |f | f << data.to_yaml.gsub("\n","\n  ").gsub("---\n ","\n-") }
    end

    def records
      YAML.load_file(logfile, permitted_classes: [Time, Symbol])
    end
  end
end