require 'thor'

module Grade

  class CLI < Thor

    desc 'checkout', 'Pulls all repos and checks them out to the specific time'
    def checkout
      Helpers.pull_and_checkout
    end

    desc 'journal [dce]', 'Checks the activity journals for everyone'
    def journal(person=nil)
      FileUtils.mkdir_p("_projects/#{CONFIG['project_name']}")
      FileUtils.touch("_projects/#{CONFIG['project_name']}/journals.yml")
      file = File.open("_projects/#{CONFIG['project_name']}/journals.yml", 'r+')
      if person.nil?
        Helpers.activity_journals(file)
      else
        person = person.dup
        journals = YAML.load(file)
        journals = '' unless journals
        journals = {} if journals.empty?
        begin
          journals[person] = Helpers.activity_journal_for(person)
          journals = Hash[journals.sort]
        ensure
          file.write(YAML.dump(journals))
        end
      end
    end

    desc 'view [dce]', 'views the code for everyone or specific user'
    def view(person=nil)
      FileUtils.mkdir_p("_projects/#{CONFIG['project_name']}")
      FileUtils.touch("_projects/#{CONFIG['project_name']}/code.yml")
      file = File.open("_projects/#{CONFIG['project_name']}/code.yml", 'r+')
      if person.nil?
        Helpers.view_code
      else
        person = person.dup
        code = YAML.load(file)
        code = '' unless code
        code = {} if code.empty?
        begin
          code[person] = Helpers.view_code_for(person)
          code = Hash[code.sort]
        ensure
          file.write(YAML.dump(code))
        end
      end
    end

    desc 'combine', 'combines all of the different files for a project'
    def combine
      Helpers.combine
    end

    desc 'run_tests [dce]', 'runs the tests for everyone or specific user'
    def run_tests(person=nil)
      FileUtils.mkdir_p("_projects/#{CONFIG['project_name']}")
      FileUtils.touch("_projects/#{CONFIG['project_name']}/tests.yml")
      file = File.open("_projects/#{CONFIG['project_name']}/tests.yml", "r+")
      if person.nil?
        Helpers.run_tests
      else
        person = person.dup
        tests = YAML.load(file)
        tests = '' unless tests
        tests = {} if tests.empty?
        begin
          tests[person] = Helpers.run_tests_for(person)
          tests = Hash[tests.sort]
        ensure
          file.write(YAML.dump(tests))
        end
      end
    end
  end
end
