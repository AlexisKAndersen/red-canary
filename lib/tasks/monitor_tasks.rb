class MonitorTasks < Thor
  desc "process", "Run executable processes"
  subcommand "process", ProcessTasks
end