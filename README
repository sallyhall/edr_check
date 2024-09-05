I've created two classes that work together to generate and log activity for the purpose of testing an EDR agent. The first, `EDR_check`, prompts user for inputs, creates and runs events, and logs metadata about those events to a logfile. The second, `Event`, is used to run a command and return metadata about that command.

To run the check from the root directory, load the file into an irb console by running `irb -r ./lib/EDR_check.rb`. Once the console is loaded, run `EDRCheck.run`. This will prompt you for the required inputs, execute the commands, then save the log to `tmp/logfile.json`.

The events that are run are:

1. `execute_process`: Given an executable path and command-line arguments, this executes the command and returns a hash containing the username, process name, process command line, process id, timestamp, and event type ("process start").
2. `create_file`: Given a file extension, file name, and file path, this creates an empty file and returns a hash containing the username, process name, process command line, process id, timestamp, file_path, event type ("file"), and event activity ("create").
3. `modify_file`: Given a file extension, file name, and file path, this writes "hello" to the file using `echo` and `>` and returns a hash containing the username, process name, process command line, process id, timestamp, file_path, event type ("file"), and event activity ("modify").
4. `delete_file`: Given a file extension, file name, and file path, this deletes the file and returns a hash containing the username, process name, process command line, process id, timestamp, file_path, event type ("file"), and event activity ("delete").
5. `network_data_transmit`: Given a destination address and port, this creates a test file of random data. It then makes an http post request with the file data to the destination and returns a hash containing the username, process name, process command line, process id, timestamp, destination_ip, destination_port, source_ip, source_port, protocol, data_size, and event type ("network").

I've also written a test that ensures the user is prompted with the expected prompts and that the logfile contains the expected data. In an ideal world, this would not be one big test. I'd like to refactor this to test methods separately in addition to the existing integration test.

If I were to continue working on this, my next steps would be:

1. Write tests for individual methods, including testing unhappy paths and edge cases.
2. Use Webmock to stub the network request in the specs instead of making a real request.
3. Expand the network data transmit event to allow specifying a protocol and the data to be sent.
4. Add error handling, especially for the network data transmit, to handle retrying and/or logging errors when processes don't exit successfully.
5. Find a way to get metadata about the process from the system, rather than inferring the username, timestamp, etc.
