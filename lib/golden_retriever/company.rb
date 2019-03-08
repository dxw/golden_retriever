# frozen_string_literal: true

module GoldenRetriever
  class Company < Model
    HUBSPOT_PROPERTIES = %w[
      companyname
    ].freeze

    attr_accessor :name

    def initialize(properties)
      @name = properties[:name]
    end

    def save
      Hubspot::Company.create!(@name, {})
    end
  end
end
