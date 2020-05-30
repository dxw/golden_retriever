# typed: true
# frozen_string_literal: true

module Hubspot
  class Company
    def self.all(opts = {})
      path = '/companies/v2/companies/paged'

      response = Hubspot::Connection.get_json(path, opts)
      response_with_offset = {}

      response_with_offset['companies'] = response['companies'].map { |c| new(c) }
      response_with_offset['hasMore'] = response['has-more']
      response_with_offset['offset'] = response['offset']
      response_with_offset
    end
  end
end
