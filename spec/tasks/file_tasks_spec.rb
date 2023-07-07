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

    ["meaning_of_life.pdf", File.join(Dir.home, "government_secrets.jpg")].each do |file|
      context "with a valid filename" do
        let(:filename) { file }

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

  describe :delete do
    subject(:result) { klass.delete(filename) }
    let(:log_data) do
      {
        process_command_line: Gem.win_platform? ? "del #{filename.gsub("/","\\")}" : "rm #{filename}",
        process_id: Integer,
        process_name: Gem.win_platform? ? "del" : "rm",
        timestamp: be_within(60).of(Time.now),
        user: Etc.getlogin,
        path_to_file: File.expand_path(filename),
        file_activity: :delete,
      }
    end

    context "without a valid filename" do
      let(:filename) { "" }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    ["meaning_of_life.pdf", File.join(Dir.home, "rick_roll.mp3")].each do |file|
      context "with valid file: #{file}" do
        before { FileUtils.touch(filename) }

        let(:filename) { file }

        it "deletes the file" do
          expect { subject }.to change { File.exist?(filename) }.to(false)
        end

        it "logs the relevant information" do
          expect(ActivityLog).to receive(:log_activity).with(match(log_data))
          subject
        end
      end
    end
  end


  describe :append do
    subject(:result) { klass.append(filename, added) }
    let(:content) { "some text\n" }
    let(:added) { "some more text" }
    let(:log_data) do
      {
        process_command_line: %|echo #{added} >> #{filename}|,
        process_id: Integer,
        process_name: "echo",
        timestamp: be_within(60).of(Time.now),
        user: Etc.getlogin,
        path_to_file: File.expand_path(filename),
        file_activity: :append,
      }
    end

    context "without a valid filename" do
      let(:filename) { "" }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    ["ive_run_out_of_file_names.txt", File.join(Dir.home, "actually_good_life_hacks.txt")].each do |file|
      context "with valid filename: #{file}" do
        around(:example) do |ex|
          File.write(filename, content)
          ex.run
          FileUtils.rm(filename) if File.exist?(filename)
        end

        let(:filename) { file }

        it "appends to the file" do
          expect { subject }.to change { File.read(filename) }.to(/^#{content}#{added}\s*$/)
        end

        it "logs the relevant information" do
          expect(ActivityLog).to receive(:log_activity).with(match(log_data))
          subject
        end
      end
    end
  end
end
