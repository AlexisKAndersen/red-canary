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

  desc "delete [FILENAME]", "Delete a file with FILENAME"
  def delete(filename)
    fail ArgumentError, "Must provide a filename, but received '#{filename}'" if filename.nil? || filename.empty?

    command = Gem.win_platform? ? "del #{filename.gsub("/","\\")}" : "rm #{filename}"
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
      path_to_file: File.expand_path(filename),
      file_activity: :delete,
    }

    IO.popen(command) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end

  desc "append [FILENAME] \"[CONTENT]\"", "Append CONTENT to a file with FILENAME"
  def append(filename, content)
    fail ArgumentError, "Must provide a filename, but received '#{filename}'" if filename.nil? || filename.empty?
    fail ArgumentError, "Must provide data to append" if content.nil? || content.empty?

    command = "echo #{content} >> #{filename}"
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
      path_to_file: File.expand_path(filename),
      file_activity: :append,
    }

    IO.popen(command) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end
end