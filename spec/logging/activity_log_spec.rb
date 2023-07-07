# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActivityLog do
  describe '.log_activity' do
    subject { described_class.log_activity(data) }
    let(:data) do
      {
        timestamp: Time.now,
        user: "alexis",
        process_name: "ls",
        process_command_line: "ls -la",
        process_id: 10791,
      }
    end

    context "when passed a complete hash of data" do
      it "adds a row to the logging yml" do
        subject
        expect(described_class.records.last).to eq(data)
      end
    end
  end
end
