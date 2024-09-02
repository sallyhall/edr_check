require "./lib/EDR_check"

RSpec.describe EDRCheck do
  describe ".run" do
    it "logs prompts and user input to file" do
      allow(EDRCheck).to receive(:get_user_input)
        .and_return("path/to/process", "command line args", "file type", "path/to/file")

      EDRCheck.run

      expect(EDRCheck).to have_received(:get_user_input).with(
        "What is the executable path for the process?"
      )
      expect(EDRCheck).to have_received(:get_user_input).with(
        "What are the command-line argments for the process? (hit enter if no arguments)"
      )
      expect(EDRCheck).to have_received(:get_user_input).with(
        "What file type should be created?"
      )
      expect(EDRCheck).to have_received(:get_user_input).with(
        "What is the path for the file?"
      )
    end
  end
end
