require 'git'
require 'colorize'

module Grade
  module Helpers
    extend self
    # Pulls all of the repos
    def pull_and_checkout
      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory)
        puts "Pulling repo for #{directory.cyan}"
        g = Git.open(directory)
        g.reset
        g.pull
        date = CONFIG['extended']['dce'].include?(directory) ? CONFIG['extended']['due_date'] : CONFIG['due_date']
        commit = g.log.until(date).first
        puts "Reseting to commit #{commit.sha.cyan}"
        g.reset(commit)
      end
    end
  end
end