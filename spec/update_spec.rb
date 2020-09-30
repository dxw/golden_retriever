# frozen_string_literal: true

require "spec_helper"

RSpec.describe GoldenRetriever::Update, :vcr do
  before do
    allow(MarketplaceOpportunityScraper::Opportunity).to receive(:all) { [opportunity] }
  end

  let(:opportunity) { double("MarketplaceOpportunityScraper::Opportunity", id: 12345) }

  context "when an opportunity has been awarded" do
    before do
      allow(opportunity).to receive(:awarded_to) { "ACME Inc" }
    end

    it "updates the successful_bidder" do
      deal = double("GoldenRetriever::Deal")
      expect(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { deal }
      expect(deal).to receive(:successful_bidder) { nil }
      expect(deal).to receive("successful_bidder=").with("ACME Inc")
      expect(deal).to receive(:save)

      GoldenRetriever::Update.new.run!
    end

    context "when the deal does not exist" do
      it "does not error" do
        expect(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { nil }

        GoldenRetriever::Update.new.run!
      end
    end

    context "when the deal already has a successful_bidder set" do
      it "does not set it again" do
        deal = double("GoldenRetriever::Deal")
        expect(GoldenRetriever::Deal).to receive(:find_by_marketplace_id).with(opportunity.id) { deal }
        expect(deal).to receive(:successful_bidder) { "ACME Inc" }
        expect(deal).to_not receive(:save)

        GoldenRetriever::Update.new.run!
      end
    end
  end

  context "when an opportunity has not been awarded" do
    before do
      allow(opportunity).to receive(:awarded_to) { nil }
    end

    it "does not fetch the deal" do
      expect(GoldenRetriever::Deal).to_not receive(:find_by_marketplace_id)

      GoldenRetriever::Update.new.run!
    end
  end
end
