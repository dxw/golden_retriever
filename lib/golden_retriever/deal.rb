module GoldenRetriever
  class Deal
    HUBSPOT_PROPERTIES = [
      'marketplace_id',
      'dealname',
      'amount',
      'closedate',
      'marketplace_url'
    ]

    attr_accessor :id, :marketplace_id, :marketplace_url, :name, :amount

    def initialize(properties)
      @id = properties[:hs_object_id]
      @marketplace_id = properties[:marketplace_id]
      @marketplace_url = properties[:marketplace_url]
      @name = properties[:dealname] || properties[:name]
      @amount = properties[:amount]
      @close_date = properties[:close_date] || properties[:closedate]
    end

    def close_date
      @close_date.is_a?(String) ? DateTime.strptime(@close_date,'%s') : @close_date
    end

    def self.create(attrs)
      GoldenRetriever::Deal.new(attrs).save
    end

    def self.find_by_marketplace_id(id)
      all.find { |d| d.marketplace_id.to_s == id.to_s }
    end

    def self.all
      @@all ||= begin
        hasMore = true
        offset = nil
        deals = []

        while hasMore == true
          hubspot_deals = Hubspot::Deal.all(properties: HUBSPOT_PROPERTIES, offset: offset)
          deals += hubspot_deals['deals']
          hasMore = hubspot_deals['hasMore']
          offset = hubspot_deals['offset']
        end

        deals.map { |d| GoldenRetriever::Deal.new(d.properties) }
      end
    end

    def save
      Hubspot::Deal.create!(ENV['HUBSPOT_PORTAL_ID'], nil, nil, prepared_properties)
    end

    private

    def prepared_properties
      {
        dealname: name,
        marketplace_id: marketplace_id,
        marketplace_url: marketplace_url,
        closedate: close_date.to_i,
        amount: amount
      }
    end
  end
end