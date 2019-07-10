# typed: false
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoldenRetriever::SlackNotification, :vcr do
  let(:opportunity_count) { 123 }
  let(:import_count) { 5 }

  subject do
    described_class.new(
      opportunity_count: opportunity_count,
      import_count: import_count
    )
  end

  describe '#message' do
    let(:message) { subject.send(:message).split.join(' ') }

    context 'with imported opportunities' do
      let(:import_count) { 5 }

      it 'creates a success message' do
        expect(message).to match(/imported #{import_count} opportunities/)
        expect(message).to match(/Check them out/)
      end
    end

    context 'with no imported opportunities' do
      let(:import_count) { 0 }

      it 'creates a no new opportunities message' do
        expect(message).to match(/No new opportunities/)
      end
    end

    context 'with one opportunity' do
      let(:import_count) { 1 }

      it 'creates a success message' do
        expect(message).to match(/imported #{import_count} opportunity/)
        expect(message).to match(/Check it out/)
      end
    end
  end

  describe '#send!' do
    let(:message) { 'Hi!' }
    let(:payload) do
      {
        text: message
      }.to_json
    end

    before do
      allow(subject).to receive(:message) { message }
    end

    it 'sends a message to Slack' do
      expect(HTTParty).to receive(:post).with(ENV['SLACK_WEBHOOK_URL'], body: payload)
      subject.send!
    end
  end
end
