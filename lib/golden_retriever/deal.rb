# frozen_string_literal: true

module GoldenRetriever
  class Deal < Model
    HUBSPOT_PROPERTIES = %w[
      marketplace_id
      dealname
      amount
      submission_deadline
      opportunity_link
      expected_start_date
    ].freeze

    ID_ATTRIBUTE = 'deal_id'

    attr_accessor :id, :marketplace_id, :opportunity_link, :name, :amount, :company_id, :successful_bidder

    def initialize(properties)
      @id = properties[:hs_object_id]
      @marketplace_id = properties[:marketplace_id]
      @opportunity_link = properties[:opportunity_link]
      @name = properties[:dealname] || properties[:name]
      @amount = properties[:amount]
      @submission_deadline = properties[:submission_deadline]
      @expected_start_date = properties[:expected_start_date]
      @company_id = properties[:company_id]
      @deadline_for_questions = properties[:deadline_for_questions]
      @successful_bidder = properties[:successful_bidder]
    end

    class << self
      def properties(item)
        item.properties.merge(
          id: item.send(self::ID_ATTRIBUTE),
          company_id: item.company_ids.first
        )
      end
    end

    def submission_deadline
      format_date(@submission_deadline)
    end

    def expected_start_date
      format_date(@expected_start_date)
    end

    def save
      if @id.nil?
        self.class.hubspot_class.create!(ENV['HUBSPOT_PORTAL_ID'], [company_id], nil, prepared_properties)
      else
        hubspot_deal.update!(update_properties)
      end
    end

    def hubspot_deal
      @hubspot_deal ||= self.class.hubspot_class.find(id)
    end

    private

    def format_date(date)
      date.is_a?(String) ? Date.strptime(date, '%Q') : date
    end

    def prepared_properties
      {
        dealname: name,
        marketplace_id: marketplace_id,
        opportunity_link: opportunity_link,
        submission_deadline: submission_deadline.strftime('%Q').to_i,
        expected_start_date: expected_start_date.strftime('%Q').to_i,
        amount: amount,
        pipeline: ENV['HUBSPOT_PIPELINE_ID'],
        dealstage: ENV['HUBSPOT_DEAL_STAGE_ID']
      }
    end

    def update_properties
      {
        successful_bidder: successful_bidder
      }
    end
  end
end
