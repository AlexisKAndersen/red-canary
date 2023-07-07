# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FileTasks do
  let(:klass) { FileTasks.new }

  describe :create do
    after { FileUtils.rm(filename) if File.exist?(filename) }

    subject(:result) { klass.create(filename) }
    let(:log_data) do
      {
        process_command_line: Gem.win_platform? ? /^fsutil file createnew/ : /^touch/,
        process_id: Integer,
        process_name: Gem.win_platform? ? "fsutil" : "touch",
        timestamp: be_within(60).of(Time.now),
        user: Etc.getlogin,
        path_to_file: File.expand_path(filename),
        file_activity: :create,
      }
    end

    context "without a valid filename" do
      let(:filename) { "" }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "with a valid filename" do
      subject(:result) { klass.create(filename) }
      let(:filename) { "meaning_of_life.pdf" }

      it "creates the file" do
        expect { subject }.to change { File.exist?(filename) }.to(true)
      end

      it "logs the relevant information" do
        expect(ActivityLog).to receive(:log_activity).with(match(log_data))
        subject
      end
    end

    context "with a filename elsewhere" do
      let(:filename) { File.join(Dir.home, "government_secrets.jpg") }

      it "creates the file" do
        expect { subject }.to change { File.exist?(filename) }.to(true)
      end

      it "logs the relevant information" do
        expect(ActivityLog).to receive(:log_activity).with(match(log_data))
        subject
      end
    end
  end
end
