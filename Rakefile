# frozen_string_literal: true

require 'rspec/core/rake_task'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'golden_retriever'

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec]

namespace :opportunities do
  task :import do
    GoldenRetriever::Import.new.run!
  end
end