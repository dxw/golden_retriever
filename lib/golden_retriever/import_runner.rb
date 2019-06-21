# frozen_string_literal: true

require 'singleton'

module GoldenRetriever
  class ImportRunner
    include Singleton

    def run!
      import.run!
      logger.info "#{import.opportunities.count} opportunities found, #{import.imports} new opportunities imported"
      slack_notification.send!
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
        opportunity_count: import.opportunities.count,
        import_count: import.imports
      )
    end
  end
end
