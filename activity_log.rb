class ActivityLog
  def self.get_user_input
    puts "What is the executable path for the process?"
    @process_path = STDIN.gets.chomp
    puts "What are the command-line argments for the process? (hit enter if no arguments)"
    @process_args = STDIN.gets.chomp
    puts "What file type should be created?"
    @file_type = STDIN.gets.chomp
    puts "What is the path for the file?"
    @file_path = STDIN.gets.chomp

    puts "Input values:"
    puts "process path: #{@process_path}"
    puts "process args: #{@process_args}"
    puts "file type: #{@file_type}"
    puts "file path: #{@file_path}"
  end
end

ActivityLog.get_user_input
