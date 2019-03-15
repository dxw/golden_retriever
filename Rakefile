# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'logger'
require 'golden_retriever'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec]

namespace :opportunities do
  task :import do
    logger = Logger.new(STDOUT)
    import = GoldenRetriever::Import.new
    import.run!

    logger.info "#{import.opportunities.count} opportunities found, #{import.imports} new opportunities imported"

    GoldenRetriever::SlackNotification.new(
      opportunity_count: import.opportunities.count,
      import_count: import.imports
    ).send!
  end
end
