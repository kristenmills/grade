require 'git'
require 'colorize'
require 'highline/import'
require "#{Dir.pwd}/_projects/#{Grade::CONFIG['project_name']}/#{Grade::CONFIG['test_file']}" unless Grade::CONFIG['test_file'].nil?

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
        unless commit.nil?
          puts "Reseting to commit #{commit.sha.cyan}"
          g.reset_hard(commit)
        end
      end
    end

    # Looks at everyones activity journals
    def activity_journals(file)
      journals = YAML.load(file)
      journals = '' unless journals
      journals = {} if journals.empty?

      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory) and journals[directory].nil?
        journals[directory] = activity_journal_for(directory)
      end
    ensure
      file.write(YAML.dump(journals))
    end

    # looks at an activity journal for a specific user
    def activity_journal_for(user)
      results = {}
      puts "Displaying activity journal for #{user.cyan}"
      if File.exists?("#{user}/#{CONFIG['project_name']}/Activity_Journal.txt")
        results['has_journal'] = 'yes'
        journal = File.open("#{user}/#{CONFIG['project_name']}/Activity_Journal.txt").read
        puts journal
        results['points'] = ask('how many points is this worth?', Integer)
        results['notes'] = ask('Additional notes: ').to_s
      else
        puts "No activity journal for #{user}".red
        results['has_journal'] = 'no'
        results['points'] = 0
        results['notes'] = 'File not there'
      end
      results
    end

    # View code for people
    def view_code(file)
      code = YAML.load(file)
      code = '' unless code
      code = {} if code.empty?

      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory) and code[directory].nil?
        code[directory] = view_code_for(directory)
      end
    ensure
      file.write(YAML.dump(code))
    end

    # View code for a specific user
    def view_code_for(user)
      results = {}
      puts "Displaying code for #{user.cyan}"
      CONFIG['project_files'].each do |file|
        if File.exists?("#{user}/#{CONFIG['project_name']}/#{file}")
          puts "Displaying #{file.yellow}"
          code = File.open("#{user}/#{CONFIG['project_name']}/#{file}").read
          puts code
        else
          puts "No #{file} for #{user}".red
        end
      end
      puts
      puts "Displaying #{'git logs'.yellow}"
      g = Git.open("#{user}")
      g.log.each {|x| puts x.message}
      results['points'] = ask('How many points is this worth? ', Integer)
      results['notes'] = ask('Aditional notes: ').to_s
      results
    end

    def combine
      hash = {}
      Dir.new("_projects/#{CONFIG['project_name']}").each do |file|
        next if not /(.)\.yml/.match(file) or file == 'combined.yml'
        puts "Loading #{file.cyan}"
        file_name = /(.*)\.yml/.match(file)[1]
        yml = YAML.load(File.open("_projects/#{CONFIG['project_name']}/#{file}"))
        yml.each do |user, values|
          hash[user] ||= {}
          hash[user][file_name] = values
        end
      end
      hash.each do |user, projects|
        points = 0
        projects.each do |project,info|
          points += info['points']
        end
        projects['total_points'] = points
      end

      File.open("_projects/#{CONFIG['project_name']}/combined.yml", 'w') do |f|
        f.write(YAML.dump(hash))
      end
    end

    def run_tests(file)
      tests = YAML.load(file)
      tests = '' unless tests
      tests = {} if tests.empty?

      Dir.new('.').each do |directory|
        next unless /[a-z]{2,3}\d{4}/.match(directory) and tests[directory].nil?
        tests[directory] = run_tests_for(directory)
      end
    ensure
      file.write(YAML.dump(tests))
    end

    def run_tests_for(person)
      results = {}
      test(person)
      results['points'] = ask('How many points is this worth?', Integer)
      results['notes'] = ask('Aditional notes: ').to_s
      results
    end
  end
end