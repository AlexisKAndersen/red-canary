# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConnectionTasks do
  subject(:result) { klass.get(url) }
  let(:klass) { described_class.new }

  describe "#get" do
    context "url is empty" do
      let(:url) { "" }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "a successful connection" do
      let(:url) { 'https://postman-echo.com/get' }
      let(:log_data) do
        {
          process_command_line: "curl #{url}",
          process_id: Integer,
          process_name: "curl",
          timestamp: be_within(60).of(Time.now),
          user: Etc.getlogin,
          destination_address: "https://postman-echo.com:443/get",
          source_address: described_class.my_ip,
        }
      end

      it "calls the command" do
        expect { subject }.to output(%r|"url": "https://postman-echo.com/get"|).to_stdout
      end

      it "logs the relevant information" do
        expect(ActivityLog).to receive(:log_activity).with(match(log_data))
        subject
      end
    end
  end

  describe "#post" do
    before { allow(klass).to receive(:options).and_return({content_type: content_type})}
    subject(:result) { klass.post(url, payload) }
    let(:content_type) { "text/plain" }

    context "url is empty" do
      let(:url) { "" }
      let(:payload) { "" }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    {
      "application/json" => '{"json":"data"}',
      "text/plain" => "plain text data"
    }.each do |payload_type|
      context "posting a payload of type #{payload_type[0]}" do
        let(:url) { "https://postman-echo.com/post" }
        let(:content_type) { payload_type[0] }
        let(:payload) { payload_type[1] }
        let(:log_data) do
          {
            process_command_line: %|curl #{url} -d #{payload.dump} -H Content-Type:#{content_type}|,
            process_id: Integer,
            process_name: "curl",
            timestamp: be_within(60).of(Time.now),
            user: Etc.getlogin,
            destination_address: "https://postman-echo.com:443/post",
            source_address: described_class.my_ip,
            content_size: payload.bytesize,
            content_type: content_type,
          }
        end

        it "calls the command" do
          expect { subject }.to output(%r|"url": "https://postman-echo.com/post"|).to_stdout
        end

        it "logs the relevant information" do
          expect(ActivityLog).to receive(:log_activity).with(match(log_data))
          subject
        end
      end
    end
  end
end
