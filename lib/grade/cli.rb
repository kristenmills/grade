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
        Helpers.activity_journal(person)
      end
    end
  end

end
