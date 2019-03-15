# frozen_string_literal: true

module GoldenRetriever
  class Deal < Model
    HUBSPOT_PROPERTIES = %w[
      marketplace_id
      dealname
      amount
      marketplace_url
      expected_close_date
      deadline_for_questions
    ].freeze

    ID_ATTRIBUTE = 'deal_id'

    attr_accessor :id, :marketplace_id, :marketplace_url, :name, :amount, :company_id

    def initialize(properties)
      @id = properties[:hs_object_id]
      @marketplace_id = properties[:marketplace_id]
      @marketplace_url = properties[:marketplace_url]
      @name = properties[:dealname] || properties[:name]
      @amount = properties[:amount]
      @expected_close_date = properties[:expected_close_date]
      @company_id = properties[:company_id]
      @deadline_for_questions = properties[:deadline_for_questions]
    end

    class << self
      def properties(item)
        item.properties.merge(
          id: item.send(self::ID_ATTRIBUTE),
          company_id: item.company_ids.first
        )
      end
    end

    def deadline_for_questions
      format_date(@deadline_for_questions)
    end

    def expected_close_date
      format_date(@expected_close_date)
    end

    def save
      self.class.hubspot_class.create!(ENV['HUBSPOT_PORTAL_ID'], [company_id], nil, prepared_properties)
    end

    private

    def format_date(date)
      date.is_a?(String) ? Date.strptime(date, '%Q') : date
    end

    def prepared_properties
      {
        dealname: name,
        marketplace_id: marketplace_id,
        marketplace_url: marketplace_url,
        expected_close_date: expected_close_date.strftime('%Q').to_i,
        deadline_for_questions: deadline_for_questions.strftime('%Q').to_i,
        amount: amount,
        pipeline: ENV['HUBSPOT_PIPELINE_ID'],
        dealstage: ENV['HUBSPOT_DEAL_STAGE_ID']
      }
    end
  end
end
