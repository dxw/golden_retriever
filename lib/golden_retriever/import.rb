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
        marketplace_url: opportunity.url,
        expected_close_date: opportunity.closing.to_datetime,
        deadline_for_questions: opportunity.question_deadline.to_datetime,
        company_id: fetch_company(opportunity.buyer)
      }
    end

    def opportunities
      @opportunities ||= MarketplaceOpportunityScraper::Opportunity.all('digital-outcomes')
    end
  end
end
