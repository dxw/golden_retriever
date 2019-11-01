[![Build Status](https://github.com/dxw/golden_retriever/workflows/Build/badge.svg)](https://github.com/dxw/golden_retriever/actions)

# Golden Retriever

Imports opportuntities from the [Digital Marketplace](https://www.digitalmarketplace.service.gov.uk/digital-outcomes-and-specialists/opportunities) into Hubspot

## Dependencies

* Ruby 2.60

## Installation

* Copy `.env.example` to `.env` and fill in the variables
* Run `bundle install`

## Running

To import the newest opportunities run the following:

```bash
bundle exec rake opportunities:import
```

You'll probably want to run this as a daily scheduled task.
