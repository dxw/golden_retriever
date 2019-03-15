# frozen_string_literal: true

module GoldenRetriever
  class SlackNotification
    def initialize(opportunity_count:, import_count:)
      @opportunity_count = opportunity_count
      @import_count = import_count
    end

    def send!
      HTTParty.post(ENV['SLACK_WEBHOOK_URL'], body: payload.to_json)
    end

    private

    def payload
      {
        text: message.split.join(' ')
      }
    end

    def message
      @import_count.positive? ? successful_import : no_imports
    end

    def successful_import
      ''"
        Woof woof! :dog: :wave: I found #{@opportunity_count}
        opportunities on the marketplace and imported
        #{@import_count} of them this morning!
      "''
    end

    def no_imports
      'Woof woof! :dog: No new opportunities on the marketplace today'
    end
  end
end
