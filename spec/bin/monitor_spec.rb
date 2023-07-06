RSpec.describe "monitor" do
  subject(:output) { %x(ruby bin/monitor.rb #{args}) }
  let(:args) { "" }

  context "when run with no arguments" do
    it "outputs help text" do
      expect(output).to include("monitor.rb help [COMMAND]  # Describe available commands or one specific")
    end
  end
end