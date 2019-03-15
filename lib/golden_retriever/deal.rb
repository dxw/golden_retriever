# frozen_string_literal: true

module GoldenRetriever
  class Deal < Model
    HUBSPOT_PROPERTIES = %w[
      marketplace_id
      dealname
      amount
      closedate
      marketplace_url
    ].freeze

    ID_ATTRIBUTE = 'deal_id'

    attr_accessor :id, :marketplace_id, :marketplace_url, :name, :amount, :company_id

    def initialize(properties)
      @id = properties[:hs_object_id]
      @marketplace_id = properties[:marketplace_id]
      @marketplace_url = properties[:marketplace_url]
      @name = properties[:dealname] || properties[:name]
      @amount = properties[:amount]
      @close_date = properties[:close_date] || properties[:closedate]
      @company_id = properties[:company_id]
    end

    class << self
      def properties(item)
        item.properties.merge(
          id: item.send(self::ID_ATTRIBUTE),
          company_id: item.company_ids.first
        )
      end
    end

    def close_date
      @close_date.is_a?(String) ? DateTime.strptime(@close_date, '%Q') : @close_date
    end

    def save
      self.class.hubspot_class.create!(ENV['HUBSPOT_PORTAL_ID'], [company_id], nil, prepared_properties)
    end

    private

    def prepared_properties
      {
        dealname: name,
        marketplace_id: marketplace_id,
        marketplace_url: marketplace_url,
        closedate: close_date.strftime('%Q').to_i,
        amount: amount
      }
    end
  end
end
