module GoldenRetriever
  class Import
    attr_reader :opportunities

    def initialize
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all
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
      end
    end
  end
end