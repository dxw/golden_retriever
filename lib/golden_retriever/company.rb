# frozen_string_literal: true

module GoldenRetriever
  class Company < Model
    HUBSPOT_PROPERTIES = %w[
      name
    ].freeze

    ID_ATTRIBUTE = 'vid'

    attr_accessor :name, :id

    def initialize(properties)
      @id = properties[:id]
      @name = properties[:name]
    end

    class << self
      def find_or_create_by_name(name)
        find_by_name(name) || create(name: name)
      end
    end

    def save
      company = Hubspot::Company.create!(@name, {})
      self.id = company.vid
      self
    end
  end
end
