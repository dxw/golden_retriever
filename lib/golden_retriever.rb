# typed: strict
# frozen_string_literal: true

require 'dotenv'
Dotenv.load

require 'hubspot-ruby'
require 'hubspot-ruby/company'

require 'marketplace_opportunity_scraper'
require 'httparty'
require 'fuzzy_match'

require 'golden_retriever/model'
require 'golden_retriever/deal'
require 'golden_retriever/company'
require 'golden_retriever/import'
require 'golden_retriever/update'
require 'golden_retriever/slack_notification'
require 'golden_retriever/import_runner'

Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY'])

module GoldenRetriever
end
