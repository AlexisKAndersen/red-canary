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
      subject(:result) { klass.execute("echo Hello")}
      it "calls the command" do
        expect { subject }.to output("Hello\n").to_stdout
      end
    end
  end
end
