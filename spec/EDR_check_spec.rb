require "./lib/EDR_check"
require "debug"

RSpec.describe EDRCheck do
  describe ".run" do
    it "runs events and logs metadata" do
      allow(EDRCheck).to receive(:get_user_input)
        .and_return("ls", "-al", "txt", "new_file", "~/Desktop", "https://posttestserver.dev/p/sally/post", "")

      EDRCheck.run

       [
        "What is the executable path for the process?",
        "What are the command-line argments for the process? (hit enter if no arguments)",
        "What file type should be created? Input the file extension, ex: txt, rb, csv, pdf",
        "What is the name for the file to be created?",
        "What is the path for the file to be created?",
        "What is the destination address for the network request? ex: http://www.example.com/data/goes/here",
        "What is the port for the network request?"
      ].each do |prompt|
        expect(EDRCheck).to have_received(:get_user_input).with(prompt)
      end

      expect(File).to exist("tmp/logfile.json")

      log_data = JSON.parse(File.read("tmp/logfile.json"))
      process_data = log_data.find{|event| event["event_type"]=="process start"}
      file_create_data = log_data.find{|event| event["event_type"]=="file" && event["event_activity"] == "create"}
      file_modify_data = log_data.find{|event| event["event_type"]=="file" && event["event_activity"] == "modify"}
      file_delete_data = log_data.find{|event| event["event_type"]=="file" && event["event_activity"] == "delete"}
      network_data = log_data.find{|event| event["event_type"]=="network"}

      expect(process_data).to include({
        "username" => "root",
        "process_name" => "ls",
        "process_command_line" => "ls -al"
      })
      expect(process_data["process_id"]).to be_an_instance_of(Integer)

      expect(file_create_data).to include({
        "username" => "root",
        "process_name" => "touch",
        "process_command_line" => "touch ~/Desktop/new_file.txt",
        "file_path" => "~/Desktop/new_file.txt"
      })

      expect(file_create_data["process_id"]).to be_an_instance_of(Integer)

      expect(file_modify_data).to include({
        "username" => "root",
        "process_name" => "echo",
        "process_command_line" => "echo hello > ~/Desktop/new_file.txt",
        "file_path" => "~/Desktop/new_file.txt"
      })

      expect(file_modify_data["process_id"]).to be_an_instance_of(Integer)

      expect(file_delete_data).to include({
        "username" => "root",
        "process_name" => "rm",
        "process_command_line" => "rm ~/Desktop/new_file.txt",
        "file_path" => "~/Desktop/new_file.txt"
      })

      expect(file_delete_data["process_id"]).to be_an_instance_of(Integer)

      expect(network_data).to include({
        "username" => "root",
        "process_name" => "curl",
        "process_command_line" => "curl -d @tmp/test_data.json -X POST https://posttestserver.dev/p/sally/post -w '****%{json}'",
        "protocol" => "HTTPS",
      })

      expect(network_data["process_id"]).to be_an_instance_of(Integer)
      expect(network_data["destination_ip"]).not_to be_empty
      expect(network_data["destination_port"]).to be_an_instance_of(Integer)
      expect(network_data["source_ip"]).not_to be_empty
      expect(network_data["source_port"]).to be_an_instance_of(Integer)
      expect(network_data["data_size"]).to be_an_instance_of(Integer)
    end
  end
end
