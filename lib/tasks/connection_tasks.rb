class ConnectionTasks < Thor
  def self.my_ip
    @ip ||= `curl https://www.icanhazip.com/`.delete("\n")
  end

  desc "get [ADDRESS]", "Make a get request to ADDRESS"
  def get(address)
    fail ArgumentError, "Must provide an address, but received '#{address}'" if address.nil? || address.empty?

    uri = URI(address)
    command = "curl #{address}"
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
      destination_address: "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.request_uri}",
      source_address: self.class.my_ip,
    }

    IO.popen(command) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end

  desc "post [ADDRESS] '[PAYLOAD]'", "Make a post request with PAYLOAD to ADDRESS"
  method_option :content_type, :default => "text/plain"
  def post(address, payload)
    fail ArgumentError, "Must provide an address, but received '#{address}'" if address.nil? || address.empty?

    uri = URI(address)
    command = %|curl #{address} -d "#{payload.gsub(/"/,'\"')}" -H Content-Type:#{options[:content_type]}|
    log_data = {
      timestamp: Time.now,
      user: Etc.getlogin,
      process_name: command[/^[^ ]*/],
      process_command_line: command,
      destination_address: "#{uri.scheme}://#{uri.host}:#{uri.port}#{uri.request_uri}",
      source_address: self.class.my_ip,
      content_size: payload.bytesize,
      content_type: options[:content_type],
    }

    IO.popen(command) do |command_io|
      log_data[:process_id] = command_io.pid
      puts command_io.read
    end

    ActivityLog.log_activity(log_data)
  end
end