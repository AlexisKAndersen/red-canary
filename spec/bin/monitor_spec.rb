require "spec_helper"

RSpec.describe "monitor" do
  subject(:result) { %x(#{command}) }
  let(:command) { "ruby #{File.join("bin","monitor.rb")} #{task} #{subtask} #{args}" }
  let(:args) { "" }
  let(:task) { "" }
  let(:subtask) { "" }

  context "running with no command" do
    it "outputs help text" do
      expect(result).to include("monitor.rb help [COMMAND]  # Describe available commands or one specific")
    end
  end

  describe "running processes" do
    let(:task) { "process" }

    context "with no subtask" do
      it "outputs help text" do
        expect(result).to include("monitor.rb process help [COMMAND]")
      end
    end

    describe "execute" do
      let(:subtask) { "execute" }

      context "running a simple command" do
        let(:args) { '"ruby -v"' }

        it "returns the output of the command" do
          expect(result).to include("ruby 3.2.2")
        end

        it "logs the call" do
          expect { subject }.to change { ActivityLog.records.count }.by(1)
        end
      end
    end
  end

  describe "managing files" do
    let(:task) { "file" }

    context "with no subtask" do
      it "outputs help text" do
        expect(result).to include("monitor.rb file help [COMMAND]")
      end
    end

    describe "create" do
      let(:subtask) { "create" }

      after { FileUtils.rm(args) if File.exist?(args) }

      context "creating a file" do
        let(:args) { 'ultra_sensitive_pii.xml' }

        it "creates the file" do
          expect { subject }.to change{ File.exist?(args) }.to(true)
        end

        it "logs the call" do
          expect { subject }.to change { ActivityLog.records.count }.by(1)
        end
      end
    end

    describe "delete" do
      let(:subtask) { "delete" }

      before { FileUtils.touch(args) unless File.exist?(args) }

      context "deleting a file" do
        let(:args) { 'mona_lisa_original.png' }

        it "deletes the file" do
          expect { subject }.to change{ File.exist?(args) }.to(false)
        end

        it "logs the call" do
          expect { subject }.to change { ActivityLog.records.count }.by(1)
        end
      end
    end

    describe "append" do
      let(:subtask) { "append" }
      let(:content) { "This file has one line\n" }
      let(:added) { "This file actually has two lines" }
      let(:filename) { "inane_ramblings.txt" }

      around(:example) do |ex|
        File.write(filename, content) unless File.exist?(filename)
        ex.run
        FileUtils.rm(filename) if File.exist?(filename)
      end

      context "appending to a file" do
        let(:args) { %|#{filename} "#{added}"|}

        it "appends to the file" do
          expect { subject }.to change{ File.read(filename) }.from(content).to(/^#{content}#{added}\s*$/)
        end

        it "logs the call" do
          expect { subject }.to change { ActivityLog.records.count }.by(1)
        end
      end
    end
  end
end