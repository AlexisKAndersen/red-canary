RSpec.describe "monitor" do
  subject(:result) { %x(#{command}) }
  let(:command) { "ruby bin/monitor.rb #{task} #{subtask} #{args}" }
  let(:args) { "" }
  let(:task) { "" }
  let(:subtask) { "" }
  let(:logfile) { CSV.read("log/activity.csv") }

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
      end
    end
  end
end