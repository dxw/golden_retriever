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
    GoldenRetriever::ImportRunner.instance.run!
  end

  task :update do
    update = GoldenRetriever::Update.new
    update.run!
  end
end
