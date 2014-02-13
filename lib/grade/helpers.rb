module Grade
  module Helpers
    # Pulls all of the repos
    def pull_and_checkout
      Dir.new('.').each do |directory|
        next if directory == '.' or directory == '..' or !Dir.exists?(directory)
        g = Git.open('.')
        g.reset
        g.pull
        commit = g.log.until(CONFIG['due_date']).first
        g.reset(commit)
      end
    end
  end
end