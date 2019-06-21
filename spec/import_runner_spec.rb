# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoldenRetriever::ImportRunner do
  let(:runner) { described_class.instance }

  describe 'run!' do
    let(:slack) { double(:notification, send!: nil) }
    let(:opportunities) { double(:opportunities, count: 5) }
    let(:import) do
      double(:import, opportunities: opportunities, imports: 2, run!: nil)
    end
    let(:logger) { double(:logger, info: nil) }

    before do
      allow(runner).to receive(:import) { import }
      allow(runner).to receive(:logger) { logger }
      allow(runner).to receive(:slack_notification) { slack }
      runner.run!
    end

    it 'runs the import' do
      expect(import).to have_received(:run!)
    end

    it 'logs to STDOUT' do
      expect(logger).to have_received(:info)
    end

    it 'sends a notification' do
      expect(slack).to have_received(:send!)
    end
  end
end
