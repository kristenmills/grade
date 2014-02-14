require 'thor'

module Grade

  class CLI < Thor

    desc 'checkout', 'Pulls all repos and checks them out to the specific time'
    def checkout
      Helpers.pull_and_checkout
    end

    desc 'journal [dce]', 'Checks the activity journals for everyone'
    def journal(person=nil)
      if person.nil?
        Helpers.activity_journals
      else
        person = person.dup
        journals = YAML.load(File.open("_projects/#{CONFIG['project_name']}/journals.yml"))
        journals = '' unless journals
        journals = {} if journals.empty?
        begin
          journals[person] = Helpers.activity_journal(person)
          journals = Hash[journals.sort]
        ensure
          File.open("_projects/#{CONFIG['project_name']}/journals.yml", 'w') do |f|
            f.write(YAML.dump(journals))
          end
        end
      end
    end

    desc 'view [dce]', 'views the code for everyone or specific user'
    def view(person=nil)
      if person.nil?
        Helpers.view_code
      else
        person = person.dup
        code = YAML.load(File.open("_projects/#{CONFIG['project_name']}/code.yml"))
        code = '' unless code
        code = {} if code.empty?
        begin
          code[person] = Helpers.view_code_for(person)
          code = Hash[code.sort]
        ensure
          File.open("_projects/#{CONFIG['project_name']}/code.yml", 'w') do |f|
            f.write(YAML.dump(code))
          end
        end
      end
    end

    desc 'combine', 'combines all of the different files for a project'
    def combine
      Helpers.combine
    end

    desc 'run_tests [dce]', 'runs the tests for everyone or specific user'
    def run_tests(person=nil)
      if person.nil?
        Helpers.run_tests
      else
        person = person.dup
        tests = YAML.load(File.open("_projects/#{CONFIG['project_name']}/tests.yml"))
        tests = '' unless tests
        tests = {} if tests.empty?
        begin
          tests[person] = Helpers.run_tests_for(person)
          tests = Hash[tests.sort]
        ensure
          File.open("_projects/#{CONFIG['project_name']}/tests.yml", 'w') do |f|
            f.write(YAML.dump(tests))
          end
        end
      end
    end
  end
end
