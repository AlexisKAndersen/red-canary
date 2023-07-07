# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ProcessTasks' do
  let(:klass) { ProcessTasks.new }
  describe :execute do
    context "an invalid executable command" do
      subject(:result) { klass.execute("doesnotexist")}
      it "raises an error" do
        expect { subject }.to raise_error(Errno::ENOENT,/No such file or directory - doesnotexist/)
      end
    end

    context "a valid executable command" do
      let(:log_data) do
        {
          :process_command_line=>"echo Hello",
          :process_id => Integer,
          :process_name=>"echo",
          :timestamp => be_within(60).of(Time.now),
          :user => Etc.getlogin,
        }
      end
      subject(:result) { klass.execute("echo Hello")}
      it "calls the command" do
        expect { subject }.to output("Hello\n").to_stdout
      end

      it "logs the relevant information" do
        expect(ActivityLog).to receive(:log_activity).with(match(log_data))
        subject
      end
    end
  end
end
