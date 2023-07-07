class FileTasks < Thor
  desc "create FILENAME", "Create a file with FILENAME"
  def create(filename)
    fail ArgumentError, "Must provide a filename, but received '#{filename}'" if filename.nil? || filename.empty?

    command = Gem.win_platform? ? "fsutil file createnew #{filename} 0" : "touch #{filename}"
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
      path_to_file: File.expand_path(filename),
      file_activity: :create,
    }

    IO.popen(command) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end
end