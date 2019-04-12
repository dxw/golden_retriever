# frozen_string_literal: true

module GoldenRetriever
  class Update
    def run!
      opportunities.each do |opportunity|
        next if opportunity.awarded_to.nil?

        deal = GoldenRetriever::Deal.find_by_marketplace_id(opportunity.id)

        next if deal.nil?
        next unless deal.successful_bidder.nil?

        deal.successful_bidder = opportunity.awarded_to
        deal.save
      end
    end

    def opportunities
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all(
        type: 'digital-outcomes',
        status: 'closed'
      )
    end
  end
end
