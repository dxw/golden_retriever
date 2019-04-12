# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GoldenRetriever::Update, :vcr do
  before do
    allow(MarketplaceOpportunityScraper::Opportunity).to receive(:all) { [opportunity] }
  end

  context 'when an opportunity has been awarded' do
    let(:opportunity) { MarketplaceOpportunityScraper::Opportunity.find(9115) }

    it 'updates the successful_bidder' do
      deal = double('GoldenRetriever::Deal')
      expect(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { deal }
      expect(deal).to receive('successful_bidder=').with(opportunity.awarded_to)
      expect(deal).to receive(:save)

      GoldenRetriever::Update.new.run!
    end
  end

  context 'when an opportunity has not been awarded' do
    let(:opportunity) { MarketplaceOpportunityScraper::Opportunity.find(9482) }

    it 'does not fetch the deal' do
      expect(GoldenRetriever::Deal).to_not receive(:find_by_marketplace_id)

      GoldenRetriever::Update.new.run!
    end
  end

  context 'when the deal does not exist' do
    let(:opportunity) { MarketplaceOpportunityScraper::Opportunity.find(9115) }

    it 'does not error' do
      expect(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { nil }

      GoldenRetriever::Update.new.run!
    end
  end
end
