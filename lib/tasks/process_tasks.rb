class ProcessTasks < Thor
  desc "execute 'COMMAND'", "run an executable process called COMMAND"
  def execute(command)
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
    }

    IO.popen(command, :err => [:child, :out]) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end
end