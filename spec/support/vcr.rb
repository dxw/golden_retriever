# frozen_string_literal: true

require 'vcr'

dotenv = File.open('.env')
filter_vars = File.exist?(dotenv) ? Dotenv::Environment.new(dotenv, true) : ENV

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'fixtures/cassettes'
  c.default_cassette_options = { record: :new_episodes }
  c.configure_rspec_metadata!
  filter_vars.each do |key, value|
    c.filter_sensitive_data("<#{key}>") { value }
  end
end
