require 'thor'

module Grade

  class CLI < Thor

    desc 'checkout', 'Pulls all repos and checks them out to the specific time'
    def checkout
      Helpers.pull_and_checkout
    end
  end

end
