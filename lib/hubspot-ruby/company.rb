# frozen_string_literal: true

module Hubspot
  class Company
    def self.all(opts = {})
      path = RECENTLY_MODIFIED_COMPANIES_PATH

      response = Hubspot::Connection.get_json(path, opts)
      response_with_offset = {}
      response_with_offset['companies'] = response['results'].map { |c| new(c) }
      response_with_offset['hasMore'] = response['hasMore']
      response_with_offset['offset'] = response['offset']
      response_with_offset
    end
  end
end
