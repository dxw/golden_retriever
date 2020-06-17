# frozen_string_literal: true

require "singleton"

module GoldenRetriever
  class ImportRunner
    include Singleton

    def run!
      @attempts ||= 1
      import.run!
      logger.info "#{import.opportunities.count} opportunities found, #{import.imports} new opportunities imported"
      slack_notification.send!
    rescue => e
      @attempts += 1
      retry if @attempts < 5
      send_error_notification(e.message)
    end

    private

    def import
      @import ||= GoldenRetriever::Import.new
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def slack_notification
      GoldenRetriever::SlackNotification.new(
        opportunity_count: import&.opportunities&.count,
        import_count: import&.imports
      )
    end

    def send_error_notification(error)
      HTTParty.post(ENV["SLACK_ERROR_WEBHOOK_URL"], body: error_payload(error).to_json)
    end

    def error_payload(error)
      {
        text: error_message(error).split.join(" ")
      }
    end

    def error_message(error)
      """
        Woof woof! :dog: There was a problem updating Golden Retriever,
        the error was `#{error}`. You might want to check the logs!
      """
    end
  end
end
