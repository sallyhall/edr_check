class EDRCheck
  def self.run
    create_log_file
    banana
  end

  def self.get_user_input(prompt)
    puts prompt
    @log_file.puts(prompt)
    $stdin.gets.chomp
  end

  def self.banana
    @process_path = get_user_input "What is the executable path for the process?"
    @log_file.puts(@process_path)
    @process_args = get_user_input "What are the command-line argments for the process? (hit enter if no arguments)"
    @log_file.puts(@process_args)
    @file_type = get_user_input "What file type should be created?"
    @log_file.puts(@file_type)
    @file_path = get_user_input "What is the path for the file?"
    @log_file.puts(@file_path)
    puts "Input values:"
    puts "process path: #{@process_path}"
    puts "process args: #{@process_args}"
    puts "file type: #{@file_type}"
    puts "file path: #{@file_path}"
  end

  def self.create_log_file
    @log_file = File.open("tmp/logfile.csv", "wb")
  end
end

# EDRCheck.run
