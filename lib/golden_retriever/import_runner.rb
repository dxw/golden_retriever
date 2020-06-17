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
      raise(e)
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
  end
end
