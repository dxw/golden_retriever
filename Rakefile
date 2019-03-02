# frozen_string_literal: true

require 'rspec/core/rake_task'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'golden_retriever'

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec]

namespace :opportunities do
  task :import do
    logger = Logger.new(STDOUT)
    import = GoldenRetriever::Import.new
    import.run!

    logger.info "#{import.opportunities.count} opportunities found, #{import.imports} new opportunities imported"
  end
end