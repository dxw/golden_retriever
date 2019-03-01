require 'dotenv'
Dotenv.load

require 'hubspot-ruby'
require 'marketplace_opportunity_scraper'

require 'golden_retriever/deal'
require 'golden_retriever/import'

Hubspot.configure({hapikey: ENV['HUBSPOT_API_KEY']})

module GoldenRetriever
end
