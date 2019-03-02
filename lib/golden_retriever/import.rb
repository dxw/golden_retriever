module GoldenRetriever
  class Import
    attr_reader :opportunities, :imports

    def initialize
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all
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
  end
end