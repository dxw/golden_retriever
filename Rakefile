# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

task default: %i[rubocop spec]

namespace :opportunities do
  task :import do
    logger = Logger.new(STDOUT)
    import = GoldenRetriever::Import.new
    import.run!

    logger.info "#{import.opportunities.count} opportunities found, #{import.imports} new opportunities imported"
  end
end
