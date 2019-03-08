# frozen_string_literal: true

module GoldenRetriever
  class Company < Model
    HUBSPOT_PROPERTIES = %w[
      companyname
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
      Hubspot::Company.create!(@name, {})
    end
  end
end
