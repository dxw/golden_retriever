# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")

require "rspec/core/rake_task"
require "standard/rake"
require "logger"
require "golden_retriever"

RSpec::Core::RakeTask.new(:spec)

task default: %i[standard spec]

namespace :opportunities do
  task :import do
    GoldenRetriever::ImportRunner.instance.run!
  end

  task :update do
    update = GoldenRetriever::Update.new
    update.run!
  end
end
