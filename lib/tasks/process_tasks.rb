class ProcessTasks < Thor
  desc "execute 'COMMAND'", "run an executable process called COMMAND"
  def execute(command)
    IO.popen(command, :err=>[:child, :out]) do |command_io|
      puts command_io.read
    end
  end
end