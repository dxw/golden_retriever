# frozen_string_literal: true

module GoldenRetriever
  class Import
    attr_reader :imports

    def initialize
      @imports = 0
    end

    def run!
      opportunities.each do |opportunity|
        next if GoldenRetriever::Deal.find_by_marketplace_id(opportunity.id)

        GoldenRetriever::Deal.create(
          name: opportunity.title,
          marketplace_id: opportunity.id,
          marketplace_url: opportunity.url,
          closedate: opportunity.closing.to_datetime
        )
        @imports += 1
      end
    end

    def opportunities
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all
    end
  end
end
