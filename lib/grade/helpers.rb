require 'git'
require 'colorize'
require 'highline/import'

module Grade
  module Helpers
    extend self

    # Pulls all of the repos
    def pull_and_checkout
      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory)
        puts "Pulling repo for #{directory.cyan}"
        g = Git.open(directory)
        g.pull
        date = CONFIG['extended']['dce'].include?(directory) ? CONFIG['extended']['due_date'] : CONFIG['due_date']
        commit = g.log.until(date).first
        puts "Reseting to commit #{commit.sha.cyan}"
        g.reset_hard(commit)
      end
    end

    # Looks at everyones activity journals
    def activity_journals
      journals = YAML.load(File.open("Projects/#{CONFIG['project_name']}/journals.yml"))
      journals = '' unless journals
      journals = {} if journals.empty?

      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory) and journals[directory].nil?
        journals[directory] = activity_journal(directory)
      end
    ensure
      File.open("Projects/#{CONFIG['project_name']}/journals.yml", 'w') do |f|
        f.write(YAML.dump(journals))
      end
    end

    # looks at an activity journal for a specific user
    def activity_journal(user)
      results = {}
      puts "Displaying activity journal for #{user.cyan}"
      if File.exists?("#{user}/#{CONFIG['project_name']}/Activity_Journal.txt")
        results['has_journal'] = 'yes'
        journal = File.open("#{user}/#{CONFIG['project_name']}/Activity_Journal.txt").read
        puts journal
        results['acceptable'] = ask('Is this acceptable? ').to_s
        results['notes'] = ask('Additional notes: ').to_s
      else
        puts "No activity journal for #{user}".red
        results['has_journal'] = 'no'
        results['acceptable'] = 'no'
        results['notes'] = 'File not there'
      end
      results
    end
  end
end