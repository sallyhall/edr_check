require_relative 'event'
require 'json'
require 'securerandom'
require 'uri'

class EDRCheck
  def self.run
    set_user_options
    events = [
      execute_and_log_process,
      create_file,
      modify_file,
      delete_file,
      network_data_transmit
    ]

    File.open("tmp/logfile.json", "w") do |f|
      f.write(events.to_json)
    end
  end

  def self.get_user_input(prompt)
    puts prompt
    $stdin.gets.chomp
  end

  def self.set_user_options
    @process_path = get_user_input "What is the executable path for the process?"
    @process_args = get_user_input "What are the command-line argments for the process? (hit enter if no arguments)"
    @file_type = get_user_input "What file type should be created? Input the file extension, ex: txt, rb, csv, pdf"
    @file_name = get_user_input "What is the name for the file to be created?"
    @file_path = get_user_input "What is the path for the file to be created?"
    @full_file_path = File.join(@file_path, [@file_name, @file_type].join("."))
    @destination_address = get_user_input "What is the destination address for the network request? ex: http://www.example.com/data/goes/here"
    @destination_port = get_user_input "What is the port for the network request?"
  end

  def self.execute_and_log_process
    event = Event.new(@process_path, @process_args)
    event.run
    event.log_data.merge(
      {
        event_type: "process start",
      }
    )
  end

  def self.create_file
    event = Event.new("touch", @full_file_path)
    event.run
    event.log_data.merge(
      {
        event_type: "file",
        event_activity: "create",
        file_path: @full_file_path,
      }
    )
  end

  def self.modify_file
    event = Event.new("echo", "hello > #{@full_file_path}")
    event.run
    event.log_data.merge(
      {
        event_type: "file",
        event_activity: "modify",
        file_path: @full_file_path,
      }
    )
  end

  def self.delete_file
    event = Event.new("rm", @full_file_path)
    event.run
    event.log_data.merge(
      {
        event_type: "file",
        event_activity: "delete",
        file_path: @full_file_path,
      }
    )
  end

  def self.network_data_transmit
    create_test_data_file
    uri = URI.parse(@destination_address)
    uri.port = @destination_port unless @destination_port.nil? || @destination_port.empty?
    event = Event.new("curl", "-d @tmp/test_data.json -X POST #{uri} -w '****%{json}'")
    response = event.run
    response_data = JSON.parse(response.split("****")[1])
    event.log_data.merge(
      event_type: "network",
      destination_ip: response_data["remote_ip"],
      destination_port: response_data["remote_port"],
      source_ip: response_data["local_ip"],
      source_port: response_data["local_port"],
      protocol: response_data["scheme"],
      data_size: response_data["size_upload"]
    )
  end

  def self.create_test_data_file
    File.open("tmp/test_data.json", "wb") do |f|
      1_000.times { f.write(SecureRandom.random_bytes(1024)) }
    end
  end
end

