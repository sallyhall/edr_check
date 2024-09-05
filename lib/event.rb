require 'open3'
require 'etc'

class Event
  attr :command_line
  attr :command_path
  attr :pid
  attr :process_name
  attr :timestamp

  def initialize(command_path, args)
    @command_path = command_path
    @process_name = File.basename(command_path)
    @command_line = [command_path, args].join(" ")
  end

  def run
    stdout_s, status  = Open3.capture2(command_line)
    @pid = status.pid
    stdout_s
  end

  def log_data
    {
      username: Etc.getlogin,
      process_name: @process_name,
      process_command_line: @command_line,
      process_id: @pid
    }
  end
end
