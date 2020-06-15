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

        GoldenRetriever::Deal.create(deal_params(opportunity))
        @imports += 1
      end
    end

    def fetch_company(buyer)
      GoldenRetriever::Company.find_or_create_by_name(buyer).id
    end

    def deal_params(opportunity)
      {
        name: opportunity.title,
        marketplace_id: opportunity.id,
        opportunity_link: opportunity.url,
        submission_deadline: opportunity.closing&.to_datetime,
        expected_start_date: opportunity.expected_start_date,
        company_id: fetch_company(opportunity.buyer)
      }
    end

    def opportunities
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all(type: 'digital-outcomes')
    end
  end
end
