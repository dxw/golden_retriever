require 'spec_helper'

RSpec.describe GoldenRetriever::Import, :vcr do
  let(:opportunity) do
    MarketplaceOpportunityScraper::Opportunity.find(9142)
  end

  before do
    allow(MarketplaceOpportunityScraper::Opportunity).to receive(:all) { [opportunity] }
  end

  context 'when a deal already exists' do
    before do
      allow(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { double('GoldenRetriever::Deal') }
    end

    it 'does not add the deal' do
      expect(GoldenRetriever::Deal).to_not receive(:create)
      described_class.new.run!
    end
  end

  context 'when a deal does not exist' do
    before do
      allow(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { nil }
    end

    it 'adds the deal' do
      expect(GoldenRetriever::Deal).to receive(:create).with(
        name: opportunity.title,
        marketplace_id: opportunity.id,
        marketplace_url: opportunity.url,
        closedate: opportunity.closing.to_datetime,
      )

      described_class.new.run!
    end
  end
end