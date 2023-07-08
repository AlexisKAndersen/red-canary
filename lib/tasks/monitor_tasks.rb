class MonitorTasks < Thor
  desc "process", "Run executable processes"
  subcommand "process", ProcessTasks

  desc "file", "Manage Files"
  subcommand "file", FileTasks

  desc "connection", "Make network calls"
  subcommand "connection", ConnectionTasks
end